require 'light-service'

module Rescuetime
  class BuildResponse
    extend LightService::Action
    expects :metric_collector
    executed do |ctx|
      ctx[:metrics] = ctx[:metric_collector].metrics
    end
  end
end

