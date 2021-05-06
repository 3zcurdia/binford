# frozen_string_literal: true

require "faraday"

module Binford
  class WebService
    def initialize(base_url, serializer:)
      @base_url = base_url
      @serializer = serializer
    end

    def get(path)
      response = conn.get(path)
      return unless response.success?

      serializer.call(response.body)
    end

    protected

    attr_reader :base_url, :serializer

    def conn
      @conn ||= Faraday.new(url: base_url, headers: default_headers)
    end

    def default_headers
      {}
    end
  end
end
