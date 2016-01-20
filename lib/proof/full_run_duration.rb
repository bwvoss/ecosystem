module Proof
  class FullRunDuration
    def initialize(db, duration_threshold, run_uuid)
      @db = db
      @duration_threshold = duration_threshold
      @run_uuid = run_uuid
    end

    def check!
      @check_result = @db.where(run_uuid: @run_uuid)
                      .sum(:duration) < @duration_threshold
    end

    def passed?
      @check_result
    end
  end
end

