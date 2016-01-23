require 'timers'

class Poll
  def initialize(seconds, &block)
    @seconds = seconds
    @timer = Timers::Group.new
    @block = block
  end

  def start
    @timer.every(@seconds) { @block.call }

    loop do
      @timer.wait
    end
  end
end

