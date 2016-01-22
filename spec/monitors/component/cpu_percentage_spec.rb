require 'monitors/cpu_percentage'
require 'spec_helper'

describe Monitors::CpuPercentage do
  let(:five_minutes_ago_utc) { Time.now.utc - (5 * 60) }
  let(:now) { Time.now.utc }
  let(:table) { :system_metric }

  def add_metrics(metrics)
    DB[table].multi_insert(metrics)
  end

  def build_proof(metric_count_threshold = 1)
    described_class.new(
      DB[table],
      80,
      metric_count_threshold,
      five_minutes_ago_utc
    )
  end

  it 'passes when no metrics exist', services: [:rds] do
    proof = build_proof(1)

    proof.check!

    expect(proof).to be_passed
  end

  context 'percentage and count threshold' do
    it 'passes when not enough metrics pass the threshold', services: [:rds] do
      add_metrics([
        { time: now, cpu_percentage_used: 85 },
        { time: now, cpu_percentage_used: 86 },
        { time: now, cpu_percentage_used: 87 },
        { time: now, cpu_percentage_used: 88 }
      ])

      proof = build_proof(5)

      proof.check!

      expect(proof).to be_passed
    end

    it 'passes if no metrics pass the threshold', services: [:rds] do
      add_metrics([
        { time: now, cpu_percentage_used: 15 },
        { time: now, cpu_percentage_used: 26 },
        { time: now, cpu_percentage_used: 79 }
      ])

      proof = build_proof(3)

      proof.check!

      expect(proof).to be_passed
    end

    it 'fails when equal to the count threshold', services: [:rds] do
      add_metrics([
        { time: now, cpu_percentage_used: 15 },
        { time: now, cpu_percentage_used: 80 },
        { time: now, cpu_percentage_used: 81 }
      ])

      proof = build_proof(2)

      proof.check!

      expect(proof).not_to be_passed
    end

    it 'fails when bad metrics are greater than the count', services: [:rds] do
      add_metrics([
        { time: now, cpu_percentage_used: 15 },
        { time: now, cpu_percentage_used: 80 },
        { time: now, cpu_percentage_used: 81 },
        { time: now, cpu_percentage_used: 90 }
      ])

      proof = build_proof(2)

      proof.check!

      expect(proof).not_to be_passed
    end
  end

  context 'time range' do
    it 'uses metrics exactly on the time', services: [:rds] do
      add_metrics([
        { time: now, cpu_percentage_used: 15 },
        { time: five_minutes_ago_utc, cpu_percentage_used: 80 },
        { time: five_minutes_ago_utc, cpu_percentage_used: 81 },
        { time: five_minutes_ago_utc, cpu_percentage_used: 90 }
      ])

      proof = build_proof(2)

      proof.check!

      expect(proof).not_to be_passed
    end

    it 'ignores metrics older than the time', services: [:rds] do
      six_minutes_ago_utc = Time.now.utc - (6 * 60)
      add_metrics([
        { time: now, cpu_percentage_used: 15 },
        { time: six_minutes_ago_utc, cpu_percentage_used: 80 },
        { time: six_minutes_ago_utc, cpu_percentage_used: 81 },
        { time: six_minutes_ago_utc, cpu_percentage_used: 90 }
      ])

      proof = build_proof(2)

      proof.check!

      expect(proof).to be_passed
    end
  end
end

