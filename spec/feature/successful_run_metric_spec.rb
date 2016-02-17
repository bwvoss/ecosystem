require 'spec_helper'

describe 'Recording success at the end of the run', :truncate do
  let(:result_record) do
    DB[:run_result_metric].first
  end

  it 'captures the run_uuid and time' do
    configure_rescuetime_response

    run_rescuetime

    expect(result_record[:status]).to eq('success')
  end
end

