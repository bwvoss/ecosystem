require 'light-service'

module Rescuetime
  class BuildUrl
    extend LightService::Action
    expects :api_domain, :api_key, :datetime
    promises :get_url

    executed do |ctx|
      formatted_date = ctx.datetime.strftime('%Y-%m-%d')

      ctx.get_url =
        "#{ctx.api_domain}?"\
        "key=#{ctx.api_key}&"\
        "restrict_begin=#{formatted_date}&"\
        "restrict_end=#{formatted_date}&"\
        'perspective=interval&'\
        'resolution_time=minute&'\
        'format=json'
    end
  end
end

