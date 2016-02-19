module Transactions
  class Truncate
    def self.call(context)
      identifier = context.fetch(:identifier)
      path = "spec/file_sandbox/#{identifier}/#{context.fetch(:date)}"
      File.truncate(path, 0)
      File.truncate("#{path}_read", 0)
    end
  end
end

