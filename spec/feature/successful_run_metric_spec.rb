require 'spec_helper'

describe 'Recording success at the end of the run' do
  it 'captures the run_uuid and time' do
    configure_rescuetime_response

    response = run_rescuetime

    result_records = response.fetch(:metrics).fetch(:run_result)

    expect(result_records.count).to eq(1)
    expect(result_records.first[:status]).to eq('success')
  end
end

