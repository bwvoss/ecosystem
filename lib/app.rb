require 'rescuetime/single_day_sync'

module App
  def self.sync_rescuetime(configuration)
    Rescuetime::SingleDaySync.call(configuration)
  end
end

