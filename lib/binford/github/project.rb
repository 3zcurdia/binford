# frozen_string_literal: true

module Binford
  module Github
    class Project
      STORY_POINTS_REGEX = /SP:\s*(\d+\.*\d*)/.freeze

      attr_reader :api, :id

      def initialize(id, api_client: nil)
        @id = id
        @api = api_client || ApiClient.new
      end

      def columns
        api.get("/projects/#{id}/columns")
      end

      def cards(column_id)
        api.get("/projects/columns/#{column_id}/cards")&.map do |data|
          content_path = api.url_to_path(data[:content_url])
          data[:note] ||= api.get(content_path)[:body]
          data[:points] = data[:note].scan(STORY_POINTS_REGEX).flatten.first.to_f
          data
        end
      end
    end
  end
end
