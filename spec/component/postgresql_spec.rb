require 'postgresql'
require 'spec_helper'
require 'timecop'
require 'toxiproxy'

describe Postgresql do
  let(:table) {:person}

  def db(attributes={})
    described_class.new(
      table: attributes.fetch(:table, table),
      connection_string: attributes.fetch(:connection_string, nil),
      connect_timeout: attributes.fetch(:connect_timeout, 3),
      pool_timeout: attributes.fetch(:pool_timeout, 3),
      read_timeout: attributes.fetch(:read_timeout, nil),
      max_connections: attributes.fetch(:max_connections, 2)
    ).db
  end

  describe 'resiliency states' do
    let(:connection_string) {'postgres://postgres@localhost:6543/postgres'}

    before :all do
      Toxiproxy.populate([{
        name: "postgresql",
        listen: "localhost:6543",
        upstream: "localhost:2200"
      }])
    end

    context 'times out on:' do
      it 'connecting', services: [:postgresql]do
        Toxiproxy[:postgresql].upstream(:timeout, timeout: 2100).apply do
          assert_timeout(exception: "Sequel::DatabaseConnectionError: PG::ConnectionBad: timeout expired") do
            db(connect_timeout: 2, connection_string: connection_string)
          end
        end
      end

      it 'reads', services: [:postgresql] do
        assert_timeout(exception: "Sequel::DatabaseError: PG::QueryCanceled: ERROR:  canceling statement due to statement timeout") do
          db(read_timeout: 2, connection_string: connection_string).sleep(seconds: 3)
        end
      end

      it 'retrieving a connection from the connection pool, which is also a semaphore', services: [:postgresql] do
        _db = db(max_connections: 3, pool_timeout: 2, connection_string: connection_string)

        assert_threaded_timeout(threads: 4, exception: "Sequel::PoolTimeout: timeout: 2.0") do
          _db.sleep(seconds: 3)
        end
      end
    end
  end

  it 'holds all time in UTC', services: [:postgresql] do
    connection_string = 'postgres://postgres@localhost:2200/postgres'
    table = :utc_test
    sequel = Sequel.connect(connection_string)
    sequel.create_table?(table) do
      DateTime :date
    end

    require 'time'
    time = Time.parse("2015-10-02 8:35")
    record = {date: time}
    db(table: table, connection_string: connection_string).insert(record: record)

    expect(sequel[table].first[:date]).to eq(time.utc)
  end

  describe 'deduplicated batch inserts' do
    let(:connection_string) {'postgres://postgres@localhost:2200/postgres'}

    it 'batch inserts records', services: [:postgresql] do
      sequel = Sequel.connect(connection_string)
      sequel.create_table?(table) do
        String :name
      end

      records = [{name: 'John'}, {name: 'Dave'}]
      db(connection_string: connection_string).deduplicated_multi_insert(records: records)
      expect(sequel[table].count).to eq(2)
    end

    it 'will not insert records that already exist', services: [:postgresql] do
      sequel = Sequel.connect(connection_string)
      sequel.create_table?(table) do
        primary_key :id
        String :name
      end

      records = [{name: 'John'}, {name: 'Dave'}]
      db(connection_string: connection_string).deduplicated_multi_insert(records: records)
      db(connection_string: connection_string).deduplicated_multi_insert(records: records)
      expect(sequel[table].count).to eq(2)
    end

    it 'will not insert records that already exist with multiple fields', services: [:postgresql] do
      sequel = Sequel.connect(connection_string)
      table = :test_table
      sequel.create_table?(table) do
        primary_key :id
        String :name
        Integer :age
        String :color
      end

      records = [
        {name: 'John', age: 1, color: 'green'},
        {name: 'Dave', age: 2, color: 'blue'}
      ]
      db(table: table, connection_string: connection_string).deduplicated_multi_insert(records: records)
      db(table: table, connection_string: connection_string).deduplicated_multi_insert(records: records)

      expect(sequel[table].count).to eq(2)
    end

    it 'allows the insertion of new records', services: [:postgresql] do
      sequel = Sequel.connect(connection_string)
      table = :test_table
      sequel.create_table?(table) do
        primary_key :id
        String :name
        Integer :age
        String :color
      end

      records = [
        {name: 'John', age: 1, color: 'green'},
        {name: 'Dave', age: 2, color: 'blue'}
      ]
      db(table: table, connection_string: connection_string).deduplicated_multi_insert(records: records)
      db(table: table, connection_string: connection_string).deduplicated_multi_insert(records: records)

      new_record = records << {name: 'Bill', age: 3, color: 'red'}
      new_record.reverse!

      db(table: table, connection_string: connection_string).deduplicated_multi_insert(records: new_record)

      expect(sequel[table].count).to eq(3)
    end
  end
end

