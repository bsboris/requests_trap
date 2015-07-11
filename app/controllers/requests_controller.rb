class RequestsController < ApplicationController
  include ActionController::Live
  POLL_DELAY_SECONDS = 2

  def create
    trap_request
    render nothing: true, status: 200
  end

  def index
    load_requests
  end

  def show
    load_requests
    @request = Request.all_for_trap(params[:trap]).find(params[:id])
    respond_to do |format|
      format.js
      format.html { render :index }
    end
  end

  def events
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 300, event: "event")
    start = Time.current
    loop do
      Request.uncached do
        requests = Request.all_for_trap(params[:trap]).where('created_at > ?', start).all
        if requests.any?
          string = requests.map do |r|
            render_to_string(partial: 'request_row.html.slim', locals: { request: r }).gsub(/\n/, '')
          end.join
          sse.write string
          start = requests.first.created_at
        end
      end
      sleep POLL_DELAY_SECONDS
    end
  rescue IOError
    logger.error 'Stream closed.'
  ensure
    sse.close
  end

  private

  def trap_request
    Request.create! trap: params[:trap], data: parsed_request_data, raw: raw_request
  end

  def parsed_request_data
    headers = request.env.select { |k, v| k.match(/^HTTP.*/) }
    {
      via: request.method,
      url: request.url,
      scheme: request.protocol,
      port: request.port,
      format: request.format.to_s,
      remote_ip: request.remote_ip,
      query_string: request.query_string,
      params: params.except(:controller, :action, :format, :trap),
      headers: headers,
      cookies: request.cookies,
    }
  end

  def raw_request
    request.env.inspect
  end

  def load_requests
    @requests = Request.all_for_trap(params[:trap])
  end
end
