require 'spec_helper'

describe 'Captures Duration metrics during rescuetime sync', :truncate do
  let(:run_uuid) { 'lsdkfj278' }
  def actions_measured
    duration_metrics = DB[:duration_metric].where(run_uuid: run_uuid)

    duration_metrics.map do |metric|
      metric[:action]
    end
  end

  it 'captures the duration of every action' do
    configure_rescuetime_response

    run_rescuetime

    actions = Rescuetime::SingleDaySync.actions.map(&:to_s)
    expect(actions_measured).to eq(actions)
  end
end

