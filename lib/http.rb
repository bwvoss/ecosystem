require 'httparty'

class Http
  def initialize(timeout:)
    @timeout = timeout
  end

  def get(url:)
    HTTParty.get(url, timeout: @timeout)
  end
end

