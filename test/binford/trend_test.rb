# frozen_string_literal: true

require "test_helper"

module Binford
  class TrendsTest < Minitest::Test
    def trend
      @trend ||= Trends.new
    end

    def setup
      [0, 1, 1, 2, 3, 5, 8, 13, 21].shuffle.each do |val|
        trend.add(val)
      end
    end

    def test_trend_min
      assert_equal 0, trend.min
    end

    def test_trend_max
      assert_equal 21, trend.max
    end

    def test_trend_mean
      assert_equal 6.0, trend.mean
    end

    def test_trend_mode
      assert_equal 1, trend.mode
    end
  end
end
