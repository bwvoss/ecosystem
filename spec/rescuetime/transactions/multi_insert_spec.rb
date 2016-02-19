require 'rescuetime/transactions/multi_insert'
require 'rescuetime/transactions/get'

describe Rescuetime::Transactions::MultiInsert do
  it 'persists the records' do
    transaction_dir = 'spec/file_sandbox'
    records = [{'a' => '12'}]
    date = '10-20-2015'

    described_class.execute(
      transaction_dir: transaction_dir,
      formatted_date: date,
      converted_rescuetime_rows: records
    )

    retrieved_records = Rescuetime::Transactions::Get.execute(
      transaction_dir: transaction_dir,
      date: date
    )

    expect(retrieved_records).to eq(records)

    File.delete("#{transaction_dir}/#{date}")
  end
end

