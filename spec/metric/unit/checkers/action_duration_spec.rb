require 'metric/checkers/action_duration'
require 'test_doubles/db'

describe Metric::Checkers::ActionDuration do
  let(:duration_threshold) { 1 }
  let(:from_time_utc) { Time.now.utc }

  it 'passes when no records match the query with duration in the time range' do
    db = TestDoubles::Db.new(count: 0)
    proof = described_class.new(db, duration_threshold, from_time_utc)

    proof.check!

    expect(proof).to be_passed
  end

  it 'fails when records exist within time range and duration' do
    db = TestDoubles::Db.new(count: 1)
    proof = described_class.new(db, duration_threshold, from_time_utc)

    proof.check!

    expect(proof).not_to be_passed
  end
end

