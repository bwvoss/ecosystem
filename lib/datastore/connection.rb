require 'sequel'

module Datastore
  class Connection
    def initialize(connection_string)
      @connection_string = connection_string
    end

    def call
      Sequel.default_timezone = :utc
      Sequel.connect(@connection_string)
    end
  end
end

