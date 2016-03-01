require 'spec_helper'

describe 'Rescuetime Data Parsing' do
  it 'parses rescuetime data' do
    configure_rescuetime_response

    response = run_rescuetime

    expect(response[:rescuetime_rows].count).to eq(5)
  end
end

