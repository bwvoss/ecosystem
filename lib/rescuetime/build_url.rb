module Rescuetime
  class BuildUrl
    def self.execute(ctx)
      formatted_date = ctx.fetch(:datetime).strftime('%Y-%m-%d')

      ctx[:formatted_date] = formatted_date
      ctx[:get_url] =
        "#{ctx.fetch(:api_domain)}?"\
        "key=#{ctx.fetch(:api_key)}&"\
        "restrict_begin=#{formatted_date}&"\
        "restrict_end=#{formatted_date}&"\
        'perspective=interval&'\
        'resolution_time=minute&'\
        'format=json'

      ctx
    end
  end
end

