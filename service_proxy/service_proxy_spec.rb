require "rack/test"
require_relative "service_proxy"
require_relative "rescuetime_response"
require_relative "rescuetime_deduplication_response"
require "json"

describe ServiceProxy do
  include Rack::Test::Methods

  def app
    ServiceProxy.new
  end

  it 'hangs a response' do
    time = Time.now
    get "/hang?seconds=2"

    expect(Time.now - time).to be > 2
    expect(last_response).to be_ok
  end

  it 'responds to the rescuetime interval fetch for October 2nd' do
    query_string = "key=example-api-key&restrict_begin=2015-10-02&restrict_end=2015-10-02&perspective=interval&resolution_time=minute&format=json"

    get "/rescuetime?#{query_string}"

    expect(JSON.parse(last_response.body)).to eq(RescuetimeResponse.response)
  end

  it 'responds to the rescuetime interval fetch for October 2nd for deduplication' do
    query_string = "key=example-api-key&restrict_begin=2015-10-02&restrict_end=2015-10-02&perspective=interval&resolution_time=minute&format=json"

    get "/rescuetime/deduplication?#{query_string}"

    expect(JSON.parse(last_response.body)).to eq(RescuetimeDeduplicationResponse.response)
  end
end
