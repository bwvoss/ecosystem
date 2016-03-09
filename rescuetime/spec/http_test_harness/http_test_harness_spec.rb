require 'http_test_harness/http_test_harness'
require 'http_test_harness/server'

describe HttpTestHarness do
  let(:path) { '/test_path' }

  def parse(response)
    JSON.parse(
      response,
      symbolize_names: true
    )
  end

  it 'sets and inspects responses for paths' do
    described_class.set(
      path: path,
      response: { a: 2 }
    )

    response = parse(described_class.inspect(path).body)

    expect(response).to eq(a: 2)
  end

  it 'uses the full querystring' do
    path = '/foo?baz=bar'

    described_class.set(
      path: path,
      response: { foo: 'bar' }
    )

    response = parse(described_class.inspect(path).body)

    expect(response).to eq(foo: 'bar')
  end

  it 'sets errors and error messages' do
    described_class.set(
      path: path,
      code: 500,
      response: 'Blow up'
    )

    response = described_class.inspect(path)
    status_code = response.code

    expect(status_code).to eq(500)
    expect(response.parsed_response).to eq('Blow up')
  end
end

