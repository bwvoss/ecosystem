require 'proof/action_duration'

class MockDb
  attr_reader :count
  def initialize(count)
    @count = count
  end

  def where(_query)
    self
  end

  def filter(_query, _data)
    self
  end
end

describe Proof::ActionDuration do
  let(:duration_threshold) { 1 }
  let(:from_time_utc) { Time.now.utc }

  it 'passes when no records match the query with duration in the time range' do
    db = MockDb.new(0)
    proof = described_class.new(db, duration_threshold, from_time_utc)

    proof.check!

    expect(proof).to be_passed
  end

  it 'fails when records exist within time range and duration' do
    db = MockDb.new(1)
    proof = described_class.new(db, duration_threshold, from_time_utc)

    proof.check!

    expect(proof).not_to be_passed
  end
end

