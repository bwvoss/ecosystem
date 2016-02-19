require 'json'
require 'zlib'
require 'msgpack'
require 'light-service'

module Rescuetime
  module Transactions
    class MultiInsert
      extend LightService::Action
      expects :converted_rescuetime_rows, :formatted_date

      executed do |context|
        encoded = context.fetch(:converted_rescuetime_rows).to_msgpack
        compressed = Zlib::Deflate.deflate(encoded)

        path = "spec/file_sandbox/#{context.fetch(:formatted_date)}"
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

