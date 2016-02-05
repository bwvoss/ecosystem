require "flog_cli"

class TotalFlogScore
  def initialize(path)
    @path = path
  end

  def call
    flogger = FlogCLI.new
    flogger.flog @path

    flogger.total_score
  end
end

