module Metric
  class Receiver
    attr_reader :metrics

    def initialize
      @metrics = {}
    end

    def <<(metric)
      type = metric.delete(:type)

      metric[:host] = metric.fetch(:host, Socket.gethostname)
      metric[:time] = metric.fetch(:time, Time.now.utc.to_s)

      @metrics[type] ||= []
      @metrics[type] << metric
    end
  end
end

