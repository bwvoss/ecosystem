require 'flog_cli'

class FlogScoreContainer
  def initialize
    @from_flog = []
  end

  def puts(flog_value = nil)
    return unless flog_value

    @from_flog << flog_value
  end

  def total_per_class
    totals = @from_flog.select do |item|
      /total/.match(item)
    end

    totals.shift # remove overall total

    totals.map do |item|
      item.gsub(/\s+/, ' ').strip
    end
  end
end

class FlogScore
  def initialize(path)
    @path = path
    @flog_score_container = FlogScoreContainer.new
  end

  def per_class
    flogger = FlogCLI.new
    flogger.option[:group] = true

    flogger.flog @path

    flogger.report @flog_score_container

    @flog_score_container.total_per_class
  end
end

