# frozen_string_literal: true

require "json"

module Binford
  module Serializers
    class Json
      def call(content)
        JSON.parse(content, symbolize_names: true)
      rescue JSON::ParserError
        nil
      end
    end
  end
end
