require 'metric/checkers/full_run_duration'
require 'spec_helper'

describe Metric::Checkers::FullRunDuration do
  let(:run_uuid) { '8sdfu72bf' }

  def add_metrics(metrics)
    DB[:duration_metric].multi_insert(metrics)
  end

  def build_proof
    described_class.new(
      DB[:duration_metric],
      1,
      run_uuid
    )
  end

  it 'passes when no records exist' do
    proof = build_proof

    proof.check!

    expect(proof).to be_passed
  end

  context 'when the sum duration is' do
    it 'less than the threshold it passes' do
      add_metrics([
        { run_uuid: run_uuid, duration: 0.3 },
        { run_uuid: run_uuid, duration: 0.4 }
      ])

      proof = build_proof

      proof.check!

      expect(proof).to be_passed
    end

    it 'equal to the threshold fails' do
      add_metrics([
        { run_uuid: run_uuid, duration: 0.5 },
        { run_uuid: run_uuid, duration: 0.4 },
        { run_uuid: run_uuid, duration: 0.1 }
      ])

      proof = build_proof

      proof.check!

      expect(proof).not_to be_passed
    end

    it 'greater than the threshold it fails' do
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

  it 'ignores different run_uuids' do
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

