require 'rack/test'
require 'http_test_harness/server'

describe HttpTestHarness::Server do
  include Rack::Test::Methods

  def app
    HttpTestHarness::Server.new
  end

  it 'blows up on paths not registered' do
    get '/jibberish-i-dont-exist'

    expect(last_response).not_to be_ok
  end

  it 'allows the creation of routes with responses' do
    uri = '/__config__/set_response'
    json = {
      path: '/test_path',
      response: { a: 2 }
    }.to_json

    put(uri, json, 'CONTENT_TYPE' => 'application/json')

    expect(last_response).to be_ok

    get '/test_path'

    expect(JSON.parse(last_response.body)).to eq('a' => 2)
  end
end

