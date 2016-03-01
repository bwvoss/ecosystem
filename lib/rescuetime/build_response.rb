module Rescuetime
  class BuildResponse
    def self.execute(ctx)
      ctx[:metrics] = ctx[:metric_collector].metrics

      ctx
    end
  end
end

