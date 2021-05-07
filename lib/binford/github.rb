# frozen_string_literal: true

require "faraday"

module Binford
  class Github < WebService
    def initialize(token:)
      super("https://api.github.com", serializer: Serializers::Json.new)
      @token = token
    end

    def projects(owner, repo)
      get("/repos/#{owner}/#{repo}/projects")
    end

    def project_columns(project_id)
      get("/projects/#{project_id}/columns")
    end

    def project_cards(column_id)
      regex = /SP:\s*(\d+\.*\d*)/
      get("/projects/columns/#{column_id}/cards")&.map do |data|
        data[:note] ||= get(data[:content_url].sub(base_url, ""))[:body]
        data[:points] = data[:note].scan(regex).flatten.first
      end
    end

    private

    attr_reader :token

    def default_headers
      {
        "Content-Type" => "application/json",
        "Accept" => "application/vnd.github.inertia-preview+json",
        "Authorization" => "token #{token}"
      }
    end
  end
end
