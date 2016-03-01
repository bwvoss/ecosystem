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

  xit 'captures the error and returns specific failure identifier' do
    set_invalid_api_key_response

    result = run_rescuetime

    expect(result.fetch(:failed_context_identifier)).to eq(
      'invalid_rescuetime_api_key'
    )

    result_record = result.fetch(:metrics).fetch(:run_result).first

    expect(result_record['status']).to eq('failure')
    expect(result_record['error']).to eq('Rescuetime::InvalidApiKeyError')
  end
end

