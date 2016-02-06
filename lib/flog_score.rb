require 'flog_cli'

class FlogScoreContainer
  def initialize
    @from_flog = []
  end

  def puts(flog_value = nil)
    return unless flog_value

    @from_flog << flog_value
  end

  def scores
    @from_flog
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

    scores = @flog_score_container.scores

    totals = select_totals(scores)
    cleaned = remove_whitespace(totals)

    cleaned.map do |item|
      {
        score: /\d+\.\d+/.match(item).to_s.to_f,
        klass: /(?<=: ).\S+/.match(item).to_s
      }
    end
  end

  def select_totals(values)
    values.shift # remove overall total
    values.select do |item|
      /total/.match(item)
    end
  end

  def remove_whitespace(values)
    values.map do |item|
      item.gsub(/\s+/, ' ').strip
    end
  end
end

