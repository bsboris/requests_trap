require 'test_helper'

class RequestsControllerTest < ActionController::TestCase
  test 'should accept new requests' do
    %i(get post put patch delete).each do |m|
      send m, :create, trap: 'test'
      assert_response :success, "Failed to #{m.to_s.upcase}"
    end
  end

  test 'should trap requests' do
    assert_difference 'Request.count' do
      get :create, trap: 'test'
    end
  end

  test 'should store required attributes' do
    get :create, trap: 'test'
    r = Request.last
    assert_equal 'GET', r.data['via']
    assert_equal 'http://test.host/test', r.data['url']
    assert_equal 'http://', r.data['scheme']
    assert_equal 80, r.data['port']
    assert_equal 'text/html', r.data['format']
    assert_equal '0.0.0.0', r.data['remote_ip']
  end

  test 'should store params' do
    post :create, trap: 'test', foo: 'bar'
    r = Request.last
    assert_equal 'bar', r.data['params']['foo']
  end

  test 'should store cookies' do
    @request.cookies['foo'] = 'bar'
    get :create, trap: 'test'
    r = Request.last
    assert_equal 'bar', r.data['cookies']['foo']
  end

  test 'should store HTTP headers' do
    @request.env["HTTP_CUSTOM_HEADER"] = "bar"
    get :create, trap: 'test'
    r = Request.last
    assert_equal 'bar', r.data['headers']['HTTP_CUSTOM_HEADER']
  end

  test 'should list trapped requests' do
    create(:request)
    get :index, trap: 'test'
    assert_response :success
  end

  test 'should get individual trapped request' do
    r = create(:request)
    get :show, trap: 'test', id: r
    assert_response :success
  end

  test 'should not allow to view requests by id only' do
    r = create(:request)
    assert_raise ActiveRecord::RecordNotFound do
      get :show, trap: 'test123', id: r
    end
  end
end
