require 'spec_helper'

describe 'Capturing non 200 errors from rescuetime' do
  let(:error_message) { '500 blow up' }

  it 'captures the error and returns specific failure identifier' do
    configure_rescuetime_response(
      code: 500,
      response: error_message
    )

    _, error = run_rescuetime

    expect(error).to eq(
      :rescuetime_http_exception
    )
  end
end

