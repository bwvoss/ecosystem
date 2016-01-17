require 'sequel'

Sequel.migration do
  change do
    create_table(:rescuetime_interval) do
      primary_key :id
      DateTime :date
      Integer :time_spent_in_seconds
      Integer :number_of_people
      String :activity
      String :category
      Integer :productivity
      unique [:date, :time_spent_in_seconds, :number_of_people, :activity, :category, :productivity]
    end
  end
end

