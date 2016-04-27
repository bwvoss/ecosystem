require 'spec_helper'

describe 'Rescuetime Data Parsing' do
  it 'parses rescuetime data' do
    configure_rescuetime_response

    response, error = run_rescuetime

    expect(response.count).to eq(5)
    expect(error).to be_nil
  end
end

