require 'json'
require 'zlib'
require 'msgpack'

module Rescuetime
  module Transactions
    class Get
      def self.execute(context)
        path = "spec/file_sandbox/#{context.fetch(:date)}_read"
        if File.exist?(path) && !File.zero?(path)
          contents = File.open(path).read
          MessagePack.unpack(Zlib::Inflate.inflate(contents))
        else
          []
        end
      end
    end
  end
end

