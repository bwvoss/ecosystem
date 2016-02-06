require 'sequel'

Sequel.migration do
  change do
    create_table(:system_metric) do
      primary_key :id
      DateTime :time
      String :host
      Float :cpu_percentage_used
    end
  end
end

