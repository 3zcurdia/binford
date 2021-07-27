# frozen_string_literal: true

module Binford
  module Github
    class Service < WebService
      def initialize(token:)
        super("https://api.github.com", serializer: Serializers::Json.new)
        @token = token
      end

      def url_to_path(url)
        url.sub(base_url, "")
      end

      private

      def default_headers
        {
          "Content-Type" => "application/json",
          "Accept" => "application/vnd.github.inertia-preview+json",
          "Authorization" => "token #{@token}"
        }
      end
    end
  end
end
