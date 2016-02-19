require 'json'
require 'zlib'
require 'msgpack'
require 'light-service'

module Metric
  module Transactions
    class Send
      extend LightService::Action
      expects :metrics, :formatted_date

      executed do |context|
        metrics = context.fetch(:metrics).metrics
        metrics.each do |metric_type, timeseries|
          encoded = timeseries.to_msgpack
          compressed = Zlib::Deflate.deflate(encoded)
          path =
            "spec/file_sandbox/#{metric_type}/#{context.fetch(:formatted_date)}"

          File.open(path, 'w') do |f|
            f.write(compressed)
          end

          File.open("#{path}_read", 'w') do |f|
            f.write(compressed)
          end
        end
      end
    end
  end
end

