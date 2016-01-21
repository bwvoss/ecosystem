require 'sequel'

Sequel.migration do
  change do
    create_table(:system_metric) do
      primary_key :id
      DateTime :time
      String :host
      String :cpu_percentage_used
      String :top_cpu_processes
    end
  end
end

