require 'json'
require 'zlib'
require 'msgpack'
require 'light-service'

module Rescuetime
  module Transactions
    class MultiInsert
      extend LightService::Action

      executed do |context|
        encoded = context.fetch(:converted_rescuetime_rows).to_msgpack
        compressed = Zlib::Deflate.deflate(encoded)

        path = "#{context.fetch(:transaction_dir)}/#{context.fetch(:formatted_date)}"
        File.open(path, 'w') do |f|
          f.write(compressed)
        end
      end
    end
  end
end

