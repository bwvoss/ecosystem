require 'rescuetime/transactions/multi_insert'
require 'rescuetime/transactions/get'
require 'rescuetime/transactions/truncate'

describe Rescuetime::Transactions::MultiInsert do
  it 'persists the records' do
    records = [{ 'a' => '12' }]
    date = '10-20-2015'

    described_class.execute(
      formatted_date: date,
      converted_rescuetime_rows: records
    )

    retrieved_records = Rescuetime::Transactions::Get.execute(date: date)

    expect(retrieved_records).to eq(records)
    expect(File.exist?("spec/file_sandbox/#{date}")).to be_truthy

    Rescuetime::Transactions::Truncate.execute(date: date)
  end
end

