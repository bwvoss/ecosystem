require 'csv'

module Metric
  module Collectors
    class CollectdCsv
      def initialize(metrics, path)
        @metrics = metrics
        @path = path
      end

      def call
        csv_arrays = CSV.read(@path)

        # remove the epoch and percentage keywords
        csv_arrays.shift

        parsed_values = parse(csv_arrays)

        @metrics.multi_insert(parsed_values)
      end

      def parse(csv_arrays)
        csv_arrays.map do |array|
          {
            time: Time.at(array[0].to_i).utc,
            cpu_percentage_used: array[1]
          }
        end
      end
    end
  end
end

#
