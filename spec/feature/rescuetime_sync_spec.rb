require 'spec_helper'
require 'rescuetime/transactions/get'
require 'rescuetime/transactions/truncate'

describe 'Rescuetime Data Sync' do
  def rescuetime_record_count
    Rescuetime::Transactions::Get.execute(date: '2015-10-02').count
  end

  before :all do
    configure_rescuetime_response
  end

  before :each do
    Rescuetime::Transactions::Truncate.execute(date: '2015-10-02')
  end

  def assert_all_records_saved
    expect(rescuetime_record_count).to eq(5)
  end

  it 'for a day' do
    expect(rescuetime_record_count).to eq(0)

    run_rescuetime

    assert_all_records_saved
  end

  it 'does not copy data' do
    expect(rescuetime_record_count).to eq(0)

    run_rescuetime

    assert_all_records_saved

    expect do
      run_rescuetime
    end.not_to change { rescuetime_record_count }
  end

  def assert_only_new_records_saved
    expect(rescuetime_record_count).to eq(8)
  end

  def add_deduplicated_records
    new_rows = [
      ['2015-10-02T09:50:00', 70, 1, 'shophex.com', 'Uncategorized', 0],
      ['2015-10-02T09:50:00', 43, 1, 'kk.org', 'News & Opinion', -2],
      ['2015-10-02T09:50:00', 14, 1, 'google.com', 'Search', 0]
    ]

    config = rescuetime_config
    config[:response][:rows] = config[:response][:rows] + new_rows
    configure_rescuetime_response(config)
  end

  it 'saves only new data from rescuetime' do
    expect(rescuetime_record_count).to eq(0)

    run_rescuetime

    assert_all_records_saved

    add_deduplicated_records

    run_rescuetime

    assert_only_new_records_saved
  end
end

