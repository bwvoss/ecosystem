require 'metric/receivers/no_op'

describe Metric::Receivers::NoOp do
  it 'responds to the correct receiver interface but does nothing' do
    expect do
      receiver = described_class.new
      receiver << {}
    end.not_to raise_error
  end
end
