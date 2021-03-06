# frozen_string_literal: true

require "nokogiri"

module Binford
  module Serializers
    class HTML
      def call(content)
        Nokogiri::HTML(content)
      end
    end
  end
end
