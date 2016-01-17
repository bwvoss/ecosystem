require 'sequel'

Sequel.migration do
  change do
    create_table(:duration_metric) do
      primary_key :id
      DateTime :time
      String :host
      String :action
      String :service
      Float :duration
    end
  end
end

