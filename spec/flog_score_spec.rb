require 'flog_score'

describe FlogScore do
  it 'returns the flog scores for a file by class' do
    parser = described_class.new('spec/test_doubles/flog/complicated.rb')

    response = parser.per_class

    # TODO: {
    #   klass: 'Complicated::Dirty',
    #   score: 58.9
    # }
    expect(response).to eq(['58.9: Complicated::Dirty total'])
  end

  it 'returns the flog scores for a directory by class' do
    parser = described_class.new('spec/test_doubles/flog')

    response = parser.per_class

    expect(response).to eq([
      '53.9: Complicated::Dirty total',
      '11.3: Simple::BuildUrl total'
    ])
  end
end

