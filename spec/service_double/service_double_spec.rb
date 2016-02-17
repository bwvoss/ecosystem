require 'service_double/service_double'
require 'service_double/server'

describe ServiceDouble do
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

  xit 'can hang before responding' do
    described_class.set(
      path: path,
      response: { a: 2 },
      hang: 0.01
    )

    response = described_class.inspect(path)

    status_code = response.code

    expect(status_code).to eq(200)
    expect(parse(response.body)).to eq(a: 2)
  end
end

