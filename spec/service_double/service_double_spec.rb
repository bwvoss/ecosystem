require 'service_double/service_double'

describe ServiceDouble do
  let(:path) { '/test_path' }

  let(:set_call) do
    described_class.set(
      path: path,
      response: { a: 2 }
    )
  end

  def parse(response)
    JSON.parse(
      response,
      symbolize_names: true
    )
  end

  it 'sets paths and responses' do
    expect(JSON.parse(set_call.body)).to eq('a' => 2)
  end

  it 'inspects responses for paths' do
    set_call

    response = parse(described_class.inspect(path).body)

    expect(response).to eq(a: 2)
  end

  it 'sets errors and error messages' do
    described_class.set(
      path: path,
      response: {
        fail: {
          code: 500,
          message: 'Blow up'
        }
      }
    )

    response = described_class.inspect(path)
    status_code = response.code

    expect(status_code).to eq(500)
    expect(response.parsed_response).to eq('Blow up')
  end
end

