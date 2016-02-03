#describe "Generates a JSON file" do
  #it 'with fake data' do
    #generator = Generator.new('spec/fixtures/generated_data.json', {
      #:client_id => 2,
      #:connector_id => 3,
      #:asset => {
        #Generators.for(:asset),
        #:vulnerabilities => Generators.vulnerabilities(count: 7)
      #}
    #})

    #generator.generate!

    #file_to_hash = JSON.parse(File.read('spec/fixtures/generated_data.json'))
    #asset = file_to_hash.fetch(:asset)

    #expect(file_to_hash.fetch(:client_id)).to eq(2)
    #expect(file_to_hash.fetch(:connector_id)).to eq(3)
    #expect(asset).not_to be_nil
    #expect(asset.fetch(:vulnerabilities).count).to eq(7)
  #end
#end

