require 'total_flog_score'

describe TotalFlogScore do
  it 'returns the flog score for a file' do
    parser = described_class.new('spec/test_doubles/complicated_flog.rb')

    response = parser.call

    expect(response).to eq(93.12357494059891)
  end
end

