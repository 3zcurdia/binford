# frozen_string_literal: true

require_relative "github/service"
require_relative "github/repository"
require_relative "github/project"

module Binford
  module Github
    def self.repo(owner_repo, token:)
      Repository.new(owner_repo, client: Service.new(token: token))
    end

    def self.project(project_id, token:)
      Project.new(project_id, client: Service.new(token: token))
    end
  end
end
