require 'metric/checkers/action_duration'
require 'spec_helper'

describe Metric::Checkers::ActionDuration do
  let(:five_minutes_ago_utc) { Time.now.utc - (5 * 60) }
  let(:now) { Time.now.utc }

  def add_metrics(metrics)
    DB[:duration_metric].multi_insert(metrics)
  end

  def build_proof(from_time)
    described_class.new(
      DB[:duration_metric],
      1,
      from_time
    )
  end

  it 'passes when no metrics exist', services: [:rds] do
    proof = build_proof(five_minutes_ago_utc)

    proof.check!

    expect(proof).to be_passed
  end

  context 'based on the duration, the proof will:' do
    it 'fail if an action takes longer than 1 second', services: [:rds] do
      add_metrics([
        {
          time: now,
          action: 'TestAction',
          duration: 1.1
        }
      ])

      proof = build_proof(five_minutes_ago_utc)

      proof.check!

      expect(proof).not_to be_passed
    end

    it 'passe when every action is under a second', services: [:rds] do
      add_metrics([
        { time: now, action: 'TestAction', duration: 0.8 },
        { time: now, action: 'AnotherTestAction', duration: 0.4 }
      ])

      proof = build_proof(five_minutes_ago_utc)

      proof.check!

      expect(proof).to be_passed
    end

    it 'fails when 1 second exactly', services: [:rds] do
      add_metrics([
        { time: now, action: 'TestAction', duration: 1 },
        { time: now, action: 'AnotherTestAction', duration: 0.4 }
      ])

      proof = build_proof(five_minutes_ago_utc)

      proof.check!

      expect(proof).not_to be_passed
    end
  end

  context 'based on the time range, the proof will:' do
    it 'uses metrics where the start time is the same', services: [:rds] do
      add_metrics([
        { time: five_minutes_ago_utc, action: 'TestAction', duration: 2.2 },
        { time: now, action: 'AnotherTestAction', duration: 0.8 }
      ])

      proof = build_proof(five_minutes_ago_utc)

      proof.check!

      expect(proof).not_to be_passed
    end

    it 'ignore metrics outside of time range', services: [:rds] do
      six_minutes_ago_utc = Time.now.utc - (6 * 60)
      add_metrics([
        { time: six_minutes_ago_utc, action: 'TestAction', duration: 2.2 },
        { time: now, action: 'AnotherTestAction', duration: 0.8 }
      ])

      proof = build_proof(five_minutes_ago_utc)

      proof.check!

      expect(proof).to be_passed
    end
  end
end

