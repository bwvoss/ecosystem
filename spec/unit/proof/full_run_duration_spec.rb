require 'proof/full_run_duration'

class MockDb
  def initialize(sum)
    @sum = sum
  end

  def where(_query)
    self
  end

  def sum(_column)
    @sum
  end
end

describe Proof::FullRunDuration do
  let(:duration_threshold) { 1 }
  let(:run_uuid) { 'sdf8sdhj' }

  it 'passes when records that match the run_uuid do not exceed threshold' do
    db = MockDb.new(0.5)
    proof = described_class.new(db, duration_threshold, run_uuid)

    proof.check!

    expect(proof).to be_passed
  end

  it 'fails when records duration match threshold' do
    db = MockDb.new(1)
    proof = described_class.new(db, duration_threshold, run_uuid)

    proof.check!

    expect(proof).not_to be_passed
  end

  it 'fails when records duration exceed threshold' do
    db = MockDb.new(1.1)
    proof = described_class.new(db, duration_threshold, run_uuid)

    proof.check!

    expect(proof).not_to be_passed
  end
end

