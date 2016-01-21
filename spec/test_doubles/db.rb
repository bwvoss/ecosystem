module TestDoubles
  class Db
    attr_reader :count
    def initialize(values)
      @count = values.fetch(:count, 0)
      @sum = values.fetch(:sum, 0)
    end

    def where(_query)
      self
    end

    def filter(_query, _data)
      self
    end

    def sum(_column)
      @sum
    end
  end
end
