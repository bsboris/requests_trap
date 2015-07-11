FactoryGirl.define do
  factory :request do
    trap 'test'
    data {{
      via: 'get',
      url: 'http://test.com',
      scheme: 'http://',
      port: 80,
      format: 'text/html',
      remote_ip: '0.0.0.0'
    }}
    raw "Raw data here"
  end
end
