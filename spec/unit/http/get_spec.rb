require 'http/get'

describe Http::Get do
  it 'makes a get request with the http client' do
    response = {}
    mock_http = double(get: response)

    result = described_class.execute(get_url: 'http://example.com', http: mock_http)

    expect(result.get_response).to eq(response)
  end
end

