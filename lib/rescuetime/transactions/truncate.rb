module Rescuetime
  module Transactions
    class Truncate
      def self.execute(context)
        path = "spec/file_sandbox/#{context.fetch(:date)}"
        File.truncate(path, 0)
        File.truncate("#{path}_read", 0)
      end
    end
  end
end

