require 'app'
require 'httparty'
require 'sequel'
require 'metric/receivers/rds'
require 'proof/action_duration'
require 'proof/full_run_duration'
require 'spec_helper'
require 'time'
require 'securerandom'

class SlowAction
  extend LightService::Action
  executed do
    sleep(0.02)
  end
end

class FastAction
  extend LightService::Action
  executed do
    sleep(0.01)
  end
end

describe 'System proofs' do
  let(:five_minutes_ago_utc) { Time.now.utc - (5 * 60) }
  let(:run_uuid) { SecureRandom.uuid }
  let(:db) do
    c = Sequel.connect('postgres://postgres@localhost:2200/postgres')
    Sequel.database_timezone = :utc
    c
  end

  context 'proofing action duration' do
    it 'fails if an action takes longer than 1 second', services: [:rds] do
      App.sync_rescuetime(
        db: db,
        actions: [SlowAction],
        run_uuid: run_uuid,
        metric_receiver: Metric::Receivers::Rds.new(db))

      proof = Proof::ActionDuration.new(
        db[:duration_metric],
        0.01,
        five_minutes_ago_utc)

      proof.check!

      expect(proof).not_to be_passed
    end

    it 'passes when every action is under a second', services: [:rds] do
      App.sync_rescuetime(
        db: db,
        run_uuid: run_uuid,
        actions: [FastAction],
        metric_receiver: Metric::Receivers::Rds.new(db))

      proof = Proof::ActionDuration.new(
        db[:duration_metric],
        0.02,
        five_minutes_ago_utc)

      proof.check!

      expect(proof).to be_passed
    end

    it 'does not care about metrics outside of time range', services: [:rds] do
      App.sync_rescuetime(
        db: db,
        run_uuid: run_uuid,
        actions: [SlowAction],
        metric_receiver: Metric::Receivers::Rds.new(db))

      proof = Proof::ActionDuration.new(
        db[:duration_metric],
        0.01,
        Time.now.utc)

      proof.check!

      expect(proof).to be_passed
    end
  end

  context 'proofing run duration' do
    it 'passes when less than the threshold', services: [:rds] do
      App.sync_rescuetime(
        db: db,
        run_uuid: run_uuid,
        actions: [SlowAction, FastAction, FastAction],
        metric_receiver: Metric::Receivers::Rds.new(db))

      proof = Proof::FullRunDuration.new(
        db[:duration_metric],
        1,
        run_uuid)

      proof.check!

      expect(proof).to be_passed
    end

    it 'fails when longer than the threshold', services: [:rds] do
      App.sync_rescuetime(
        db: db,
        run_uuid: run_uuid,
        actions: [SlowAction, FastAction, FastAction],
        metric_receiver: Metric::Receivers::Rds.new(db))

      proof = Proof::FullRunDuration.new(
        db[:duration_metric],
        0.03,
        run_uuid)

      proof.check!

      expect(proof).not_to be_passed
    end
  end
end

