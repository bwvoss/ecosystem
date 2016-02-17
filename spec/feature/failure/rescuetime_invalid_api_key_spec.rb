require 'spec_helper'

describe 'Capturing errors from an invalid API key', :truncate do
  def set_invalid_api_key_response
    # Yes, rescuetime responds with a 200
    configure_rescuetime_response(
      response: {
        error: '# key not found',
        messages: 'key not found'
      }
    )
  end

  let(:result_record) do
    DB[:run_result_metric].first
  end

  it 'captures the error and returns specific failure identifier' do
    set_invalid_api_key_response

    run_return = run_rescuetime
    expect(run_return.success?).to be_falsey
    expect(run_return.message).to eq(
      'invalid_rescuetime_api_key'
    )

    expect(result_record[:status]).to eq('failure')
    expect(result_record[:error]).to eq('Rescuetime::InvalidApiKeyError')
  end
end

