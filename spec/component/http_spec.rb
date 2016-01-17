require 'http'
require 'spec_helper'
require 'toxiproxy'

describe Http do
  it 'times out on reads', required_services: [:service_proxy] do
    http_client = described_class.new(timeout: 2)

    assert_timeout(exception: "Net::ReadTimeout") do
      http_client.get(url: "http://localhost:5000/hang?seconds=3")
    end
  end
end

