class RequestsController < ApplicationController
  def create
    trap_request
    render nothing: true, status: 200
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
end