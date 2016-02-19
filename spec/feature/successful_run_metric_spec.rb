require 'spec_helper'
require 'transactions/get'
require 'transactions/truncate'

describe 'Recording success at the end of the run', :truncate do
  let(:result_records) do
    Transactions::Get.call(
      identifier: 'run_result',
      date: '2015-10-02'
    )
  end

  before :each do
    Transactions::Truncate.call(
      identifier: 'run_result',
      date: '2015-10-02'
    )
  end

  it 'captures the run_uuid and time' do
    configure_rescuetime_response

    run_rescuetime

    expect(result_records.count).to eq(1)
    expect(result_records.first['status']).to eq('success')
  end
end

