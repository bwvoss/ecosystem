require 'spec_helper'

describe 'Capturing errors from an invalid API key' do
  def set_invalid_api_key_response
    # Yes, rescuetime responds with a 200
    configure_rescuetime_response(
      response: {
        error: '# key not found',
        messages: 'key not found'
      }
    )
  end

  it 'captures the error and returns specific failure identifier' do
    set_invalid_api_key_response

    _, error = run_rescuetime

    expect(error).to eq(
      :invalid_rescuetime_api_key
    )
  end
end

