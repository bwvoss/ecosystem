require 'service_double/service_double'

describe ServiceDouble do
  let(:path) { '/test_path' }

  before :each do
    @set_call = described_class.set(
      path: path,
      response: { a: 2 }
    )
  end

  it 'sets paths and responses' do
    expect(JSON.parse(@set_call.body)).to eq('a' => 2)
  end

  it 'inspects responses for paths' do
    response = described_class.inspect(path)

    expect(response).to eq(a: 2)
  end
end

