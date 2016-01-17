require 'light-service'
require 'rescuetime/build_url'
require 'rescuetime/parse_rows'
require 'rescuetime/parse_date_to_utc'
require 'http/get'
require 'datastore/deduplicated_insert'
# require 'datastore/build_deduplicated_insert_context'
# require 'datastore/build_deduplicated_insert_sql'
# require 'datastore/execute'

module Rescuetime
  class SingleDaySync
    extend LightService::Organizer
    def self.call(configuration)
      with(configuration).reduce(actions)
    end

    def self.actions
      [
        Rescuetime::BuildUrl,
        Http::Get,
        Rescuetime::ParseRows,
        Rescuetime::ParseDateToUtc,
        Datastore::DeduplicatedInsert
        # Datastore::BuildDeduplicatedInsertContext,
        # Datastore::BuildDeduplicatedInsertSql,
        # Datastore::Execute
      ]
    end
  end
end

