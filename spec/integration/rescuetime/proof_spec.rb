require 'app'
require 'httparty'
require 'sequel'
require 'metrics/receivers/rds'
require 'proof/action_performance'
require 'spec_helper'
require 'time'

class SlowAction
  extend LightService::Action
  executed do
    sleep(0.2)
  end
end

class FastAction
  extend LightService::Action
  executed do
    sleep(0.1)
  end
end

describe 'System proofs' do
  let(:five_minutes_ago_utc) { Time.now.utc - (5 * 60) }
  let(:db) do
    c = Sequel.connect('postgres://postgres@localhost:2200/postgres')
    Sequel.database_timezone = :utc
    c
  end

  context 'performance proofs' do
    it 'fails if an action takes longer than 1 second', services: [:rds] do
      App.sync_rescuetime(
        db: db,
        actions: [SlowAction],
        metric_receiver: Metrics::Receivers::Rds.new(db)
      )

      proof = Proof::ActionPerformance.new(db[:duration_metric], 0.1, five_minutes_ago_utc)

      proof.check!

      expect(proof).not_to be_passed
    end

    it 'passes when every action is under a second', services: [:rds] do
      App.sync_rescuetime(
        db: db,
        actions: [FastAction],
        metric_receiver: Metrics::Receivers::Rds.new(db)
      )

      proof = Proof::ActionPerformance.new(db[:duration_metric], 0.2, five_minutes_ago_utc)

      proof.check!

      expect(proof).to be_passed
    end

    it 'does not care about metrics outside of time range', services: [:rds] do
      App.sync_rescuetime(
        db: db,
        actions: [SlowAction],
        metric_receiver: Metrics::Receivers::Rds.new(db)
      )

      proof = Proof::ActionPerformance.new(db[:duration_metric], 0.1, Time.now.utc)

      proof.check!

      expect(proof).to be_passed
    end
  end
end

