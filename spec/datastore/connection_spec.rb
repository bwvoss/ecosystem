require 'yaml'
require 'datastore/connection'

describe Datastore::Connection do
  it 'returns a connection object', services: [:rds] do
    config = YAML.load_file('configuration.yml')['test']
    connection = described_class.new(config['db_connection_string'])

    expect(connection.call).not_to be_nil
  end
end

