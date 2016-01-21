require 'proof/full_run_duration'
require 'sequel'
require 'spec_helper'

describe Proof::FullRunDuration do
  let(:db) { @db }
  let(:run_uuid) { '8sdfu72bf' }

  def add_metrics(metrics)
    db[:duration_metric].multi_insert(metrics)
  end

  def build_proof
    Proof::FullRunDuration.new(
      db[:duration_metric],
      1,
      run_uuid
    )
  end

  it 'passes when no records exist', services: [:rds] do
    proof = build_proof

    proof.check!

    expect(proof).to be_passed
  end

  context 'when the sum duration is' do
    it 'less than the threshold it passes', services: [:rds] do
      add_metrics([
        { run_uuid: run_uuid, duration: 0.3 },
        { run_uuid: run_uuid, duration: 0.4 }
      ])

      proof = build_proof

      proof.check!

      expect(proof).to be_passed
    end

    it 'equal to the threshold fails', services: [:rds] do
      add_metrics([
        { run_uuid: run_uuid, duration: 0.5 },
        { run_uuid: run_uuid, duration: 0.4 },
        { run_uuid: run_uuid, duration: 0.1 }
      ])

      proof = build_proof

      proof.check!

      expect(proof).not_to be_passed
    end

    it 'greater than the threshold it fails', services: [:rds] do
      add_metrics([
        { run_uuid: run_uuid, duration: 0.5 },
        { run_uuid: run_uuid, duration: 0.5 },
        { run_uuid: run_uuid, duration: 0.1 }
      ])

      proof = build_proof

      proof.check!

      expect(proof).not_to be_passed
    end
  end

  it 'ignores different run_uuids', services: [:rds] do
    add_metrics([
      { run_uuid: 'some-other-uuid', duration: 1.5 },
      { run_uuid: run_uuid, duration: 0.5 },
      { run_uuid: run_uuid, duration: 0.1 }
    ])

    proof = build_proof

    proof.check!

    expect(proof).to be_passed
  end
end

