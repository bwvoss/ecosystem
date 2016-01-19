module Proof
  class ActionPerformance
    def initialize(db, threshold, time_range_utc)
      @db = db
      @threshold = threshold
      @time_range_utc = time_range_utc
    end

    def check!
      @passed = @db
        .where("duration >= #{@threshold}")
        .filter('time > ?', @time_range_utc)
        .count == 0
    end

    def passed?
      @passed
    end
  end
end

