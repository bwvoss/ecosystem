module Rescuetime
  class FetchHandler
    class << self
      def request(_data, error)
        :http_timeout if
          error.inspect == '#<Net::ReadTimeout: Net::ReadTimeout>'
      end

      def fetch_rows(data, _error)
        if data[:code] != 200
          :rescuetime_http_exception
        elsif data[:response]['error'] == '# key not found'
          :invalid_rescuetime_api_key
        end
      end
    end
  end
end
