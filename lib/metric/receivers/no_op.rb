module Metric
  module Receivers
    class NoOp
      def <<(_event)
      end
    end
  end
end

