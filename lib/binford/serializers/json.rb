# frozen_string_literal: true

require "json"

module Binford
  module Serializers
    class Json
      def call(response)
        JSON.parse(response.body)
      rescue JSON::ParserError
        nil
      end
    end
  end
end
