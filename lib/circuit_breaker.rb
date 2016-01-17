require 'simple_circuit_breaker'
class CircuitBreakerOpenError < StandardError
end

class CircuitBreaker
  attr_reader :__circuit__, :__resource__

  def initialize(resource:, failure_threshold:, retry_timeout:)
    @__resource__ = resource
    @__circuit__  = SimpleCircuitBreaker.new(failure_threshold, retry_timeout)
  end

  def method_missing(method_sym, *arguments, &block)
    begin
      @__circuit__.handle do
        @__resource__.__send__ method_sym, *arguments, &block
      end
    rescue SimpleCircuitBreaker::CircuitOpenError => e
      raise CircuitBreakerOpenError
    end
  end
end

