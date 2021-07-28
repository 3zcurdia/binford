# frozen_string_literal: true

module Binford
  module Utils
    def safe_parse_time(str)
      return if str.nil? || str.empty?

      DateTime.parse(str).to_time.utc
    rescue TypeError
      nil
    end
  end
end
