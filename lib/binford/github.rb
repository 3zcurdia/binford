# frozen_string_literal: true

require "faraday"

module Binford
  class Github
    def initialize(token:, serializer: Serializers::Json.new)
      headers = {
        "Content-Type" => "application/json",
        "Accept" => "application/vnd.github.inertia-preview+json",
        "Authorization" => "token #{token}"
      }
      @conn = Faraday.new(url: "https://api.github.com", headers: headers)
      @serializer = serializer
    end

    def projects(owner, repo)
      fetch("repos/#{owner}/#{repo}/projects")
    end

    def project_columns(project_id)
      fetch("/projects/#{project_id}/columns")
    end

    def project_cards(column_id)
      fetch("/projects/columns/#{column_id}/cards")
    end

    private

    attr_reader :conn, :serializer

    def fetch(path)
      response = conn.get(path)
      return unless response.success?

      serializer.call(response.body)
    end
  end
end
