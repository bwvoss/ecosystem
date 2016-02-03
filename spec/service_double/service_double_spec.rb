require 'rack/test'
require 'service_double/service_double'

describe ServiceDouble do
  include Rack::Test::Methods

  def app
    ServiceDouble.new
  end

  # TODO: test without sleeping

  it 'responds to the rescuetime interval fetch for October 2nd' do
    query_string = 'key=example-api-key&restrict_begin=2015-10-02&restrict_end=2015-10-02&perspective=interval&resolution_time=minute&format=json'

    get "/rescuetime?#{query_string}"

    expect(JSON.parse(last_response.body)).to eq(RescuetimeResponse.response)
  end

  it 'responds to the rescuetime interval fetch for October 2nd for deduplication' do
    query_string = 'key=example-api-key&restrict_begin=2015-10-02&restrict_end=2015-10-02&perspective=interval&resolution_time=minute&format=json'

    get "/rescuetime/deduplication?#{query_string}"

    expect(JSON.parse(last_response.body)).to eq(RescuetimeDeduplicationResponse.response)
  end
end
