module Metrics
  module Receivers
    class NoOp
      def push(event)
      end
    end
  end
end

