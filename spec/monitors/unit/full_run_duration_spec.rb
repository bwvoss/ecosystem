require 'monitors/full_run_duration'
require 'test_doubles/db'

describe Monitors::FullRunDuration do
  let(:duration_threshold) { 1 }
  let(:run_uuid) { 'sdf8sdhj' }

  it 'passes when records that match the run_uuid do not exceed threshold' do
    db = TestDoubles::Db.new(sum: 0.5)
    proof = described_class.new(db, duration_threshold, run_uuid)

    proof.check!

    expect(proof).to be_passed
  end

  it 'fails when records duration match threshold' do
    db = TestDoubles::Db.new(sum: 1)
    proof = described_class.new(db, duration_threshold, run_uuid)

    proof.check!

    expect(proof).not_to be_passed
  end

  it 'fails when records duration exceed threshold' do
    db = TestDoubles::Db.new(sum: 1.1)
    proof = described_class.new(db, duration_threshold, run_uuid)

    proof.check!

    expect(proof).not_to be_passed
  end
end

