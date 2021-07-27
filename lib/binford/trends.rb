# frozen_string_literal: true

module Binford
  class Trends
    attr_reader :min, :max, :sum, :count, :histogram

    def initialize
      @count = 0
      @sum = 0
      @histogram = Hash.new { 0 }
    end

    def add(val)
      @min = val if @min.nil? || val < @min
      @max = val if @max.nil? || val > @max
      @count += 1
      @sum += val
      @histogram[val] += 1
    end

    def mean
      return 0 if count.zero?

      sum.to_f / count
    end

    def mode
      mode, _val = histogram.max_by { |_key, val| val }
      mode
    end
  end
end
