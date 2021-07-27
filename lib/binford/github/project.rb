# frozen_string_literal: true

module Binford
  module Github
    class Project
      STORY_POINTS_REGEX = /SP:\s*(\d+\.*\d*)/.freeze

      attr_reader :id, :client

      def initialize(id, client:)
        @id = id
        @client = client
      end

      def columns
        client.get("/projects/#{id}/columns")
      end

      def cards(column_id)
        client.get("/projects/columns/#{column_id}/cards")&.map do |data|
          content_path = client.url_to_path(data[:content_url])
          data[:note] ||= client.get(content_path)[:body]
          data[:points] = data[:note].scan(STORY_POINTS_REGEX).flatten.first.to_f
          data
        end
      end
    end
  end
end
