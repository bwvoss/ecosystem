require 'securerandom'
require 'light-service'

module Datastore
  class DeduplicatedInsert
    extend LightService::Action
    expects :converted_rescuetime_rows, :db, :table

    executed do |ctx|
      records = ctx.converted_rescuetime_rows
      db = ctx.db
      table = ctx.table
      columns = find_columns(db, table)

      db.run(deduplicated_multi_insert_sql(records, table, db, columns))
    end

    def self.deduplicated_multi_insert_sql(records, table, db, columns)
      uuid = "#{table}_#{Time.now.strftime("%Y_%m_%d")}_#{SecureRandom.uuid.gsub('-', '')}".to_sym

      """
      BEGIN;
        CREATE TABLE #{uuid} (LIKE #{table} INCLUDING ALL);

      #{db[uuid].multi_insert_sql(columns, records.map{|r| r.values})[0].gsub('"', '')};

        INSERT INTO #{table} (#{columns.join(', ')})
        SELECT #{columns_to_select('uuid', columns)} FROM #{uuid} uuid
        WHERE NOT EXISTS (
          SELECT 1 FROM #{table} t1 WHERE #{not_exists_where('t1', 'uuid', columns)}
        );

        DROP TABLE #{uuid};
      COMMIT;
          """
    end

    def self.not_exists_where(t1, t2, columns)
      columns.map do |c|
        "#{t1}.#{c} = #{t2}.#{c}"
      end.join(' AND ')
    end

    def self.columns_to_select(table, columns)
      columns.map{|c| "#{table}.#{c}"}.join(', ')
    end

    def self.find_columns(db, table)
      c = db[table].columns
      c.delete(:id)
      c
    end
  end
end

