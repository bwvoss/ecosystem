require 'sequel'

Sequel.migration do
  change do
    create_table(:run_result_metric) do
      primary_key :id
      DateTime :time
      String :host
      String :run_uuid
      String :action
      String :status
      String :error
    end
  end
end

