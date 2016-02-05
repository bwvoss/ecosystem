# require 'generator/generator'

# describe "Generates a JSON file" do
# it 'generates rescuetime data randomly' do
# generator = Generator.to_file('spec/fixtures/generated_data.json', {
# notes: 'data is an array of arrays (rows), column names for rows in row_headers',
# columns: ["Date", "Time Spent (seconds)", "Number of People", "Activity", "Category", "Productivity"],
# rows: Generator.generate_rescuetime_rows(5)
# })

# file_to_hash = JSON.parse(File.read('spec/fixtures/generated_data.json'))
# expect(response.fetch(:rows).count).to eq(5)
# end
# end

