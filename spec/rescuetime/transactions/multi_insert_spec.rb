require 'rescuetime/transactions/multi_insert'
require 'transactions/get'
require 'transactions/truncate'

describe Rescuetime::Transactions::MultiInsert do
  it 'persists the records' do
    records = [{ 'a' => '12' }]
    date = '2015-10-02'

    described_class.execute(
      formatted_date: date,
      converted_rescuetime_rows: records
    )

    retrieved_records = Transactions::Get.call(
      identifier: 'rescuetime',
      date: date
    )

    expect(retrieved_records).to eq(records)

    Transactions::Truncate.call(
      identifier: 'rescuetime',
      date: date
    )
  end
end

