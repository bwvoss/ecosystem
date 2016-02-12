require 'flog_score'

describe FlogScore do
  it 'returns the flog scores for a file by class' do
    parser = described_class.new('spec/test_data/flog/complicated.rb')

    response = parser.per_class

    expect(response).to eq([
      { score: 58.9, klass: 'Complicated::Dirty' }
    ])
  end

  it 'returns the flog scores for a directory by class' do
    parser = described_class.new('spec/test_data/flog')

    response = parser.per_class

    expect(response).to eq([
      { score: 53.9, klass: 'Complicated::Dirty' },
      { score: 11.3, klass: 'Simple::BuildUrl' }
    ])
  end
end

