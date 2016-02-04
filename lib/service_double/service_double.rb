require 'httparty'
require 'json'

module ServiceDouble
  BASE_URL = 'http://localhost:9292'

  def self.set(config)
    HTTParty.put(
      "#{BASE_URL}/__config__/set_response",
      body: config.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def self.inspect(path)
    JSON.parse(
      HTTParty.get("#{BASE_URL}#{path}").body,
      symbolize_names: true
    )
  end
end

