require 'rescuetime/invalid_api_key_error'

describe Rescuetime::InvalidApiKeyError do
  it 'acts like an exception' do
    expect(described_class.new.to_s).to eq(
      'Rescuetime::InvalidApiKeyError'
    )
  end
end
