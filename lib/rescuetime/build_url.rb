module Rescuetime
  class BuildUrl
    def self.execute(ctx)
      formatted_date = ctx.fetch(:datetime).strftime('%Y-%m-%d')

      ctx[:formatted_date] = formatted_date
      ctx[:get_url] =
        "#{ENV['RESCUETIME_API_URL']}?"\
        "key=#{ENV['RESCUETIME_API_KEY']}&"\
        "restrict_begin=#{formatted_date}&"\
        "restrict_end=#{formatted_date}&"\
        'perspective=interval&'\
        'resolution_time=minute&'\
        'format=json'

      ctx
    end
  end
end

