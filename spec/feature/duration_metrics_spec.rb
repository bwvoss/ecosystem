require 'spec_helper'

describe 'Captures Duration metrics during a rescuetime parse' do
  it 'captures the duration of every action' do
    configure_rescuetime_response

    response = run_rescuetime

    duration_metrics = response[:metrics][:duration]
    actions_measured = duration_metrics.map { |metric| metric[:action] }
    actions = Rescuetime::SingleDaySync.actions.map(&:to_s)

    expect(actions_measured).to eq(actions)
  end
end

