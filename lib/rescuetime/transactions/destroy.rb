module Rescuetime
  module Transactions
    class Destroy
      def self.execute(context)
        path = "spec/file_sandbox/#{context.fetch(:date)}"
        File.truncate(path, 0)
      end
    end
  end
end

