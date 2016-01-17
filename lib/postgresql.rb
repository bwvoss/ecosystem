require 'sequel'
require 'securerandom'

class Postgresql
  def initialize(table:, connection_string:, connect_timeout:, read_timeout:, pool_timeout:, max_connections:)
    @table = table
    @read_timeout = read_timeout
    @db = Sequel.connect(connection_string, connect_timeout: connect_timeout, pool_timeout: pool_timeout, max_connections: max_connections)
    Sequel.database_timezone = :utc
  end

  def db
    if @read_timeout
      @db.execute("set statement_timeout to #{read_timeout_in_milliseconds}")
    else
      @db.test_connection
    end

    self
  end

  def sleep(seconds:)
    @db.execute("SELECT pg_sleep(#{seconds})")
  end

  def insert(record:)
    @db[@table].insert(record)
  end

  def deduplicated_multi_insert(records:)
    @db.run(deduplicated_multi_insert_sql(records: records))
  end

  def deduplicated_multi_insert_sql(records:)
    uuid = "#{@table}_#{Time.now.strftime("%Y_%m_%d")}_#{SecureRandom.uuid.gsub('-', '')}".to_sym

    """
      BEGIN;
        CREATE TABLE #{uuid} (LIKE #{@table} INCLUDING ALL);

        #{@db[uuid].multi_insert_sql(columns, records.map{|r| r.values})[0].gsub('"', '')};

        INSERT INTO #{@table} (#{columns.join(', ')})
        SELECT #{columns_to_select(table: 'uuid')} FROM #{uuid} uuid
        WHERE NOT EXISTS (
          SELECT 1 FROM #{@table} t1 WHERE #{not_exists_where(t1: 't1', t2: 'uuid')}
        );

        DROP TABLE #{uuid};
      COMMIT;
    """
  end

  private

  def not_exists_where(t1:, t2:)
    columns.map do |c|
      "#{t1}.#{c} = #{t2}.#{c}"
    end.join(' AND ')
  end

  def columns_to_select(table:)
    columns.map{|c| "#{table}.#{c}"}.join(', ')
  end

  def columns
    c = @db[@table].columns
    c.delete(:id)
    c
  end

  def read_timeout_in_milliseconds
    @read_timeout * 1000
  end
end

