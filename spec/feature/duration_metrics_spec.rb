require 'spec_helper'
require 'transactions/get'
require 'transactions/truncate'

describe 'Captures Duration metrics during rescuetime sync', :truncate do
  let(:run_uuid) { 'lsdkfj278' }
  def actions_measured
    Transactions::Get.call(
      identifier: 'duration',
      date: '2015-10-02'
    ).map { |m| m['action'] }
  end

  before :each do
    Transactions::Truncate.call(
      identifier: 'duration',
      date: '2015-10-02'
    )
  end

  it 'captures the duration of every action' do
    configure_rescuetime_response

    run_rescuetime

    actions = Rescuetime::SingleDaySync.actions.map(&:to_s)
    expect(actions_measured).to eq(actions)
  end
end

