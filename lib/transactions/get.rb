require 'zlib'
require 'msgpack'

module Transactions
  class Get
    def self.call(context)
      identifier = context.fetch(:identifier)
      path = "spec/file_sandbox/#{identifier}/#{context.fetch(:date)}_read"
      if File.exist?(path) && !File.zero?(path)
        contents = File.open(path).read
        MessagePack.unpack(Zlib::Inflate.inflate(contents))
      else
        []
      end
    end
  end
end

