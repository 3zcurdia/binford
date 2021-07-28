# frozen_string_literal: true

require_relative "github/api_client"
require_relative "github/repository"
require_relative "github/project"
require_relative "github/pull_request"
require_relative "github/review_discussion"

module Binford
  module Github
    def self.repo(owner_repo)
      Repository.new(owner_repo)
    end

    def self.project(project_id)
      Project.new(project_id)
    end
  end
end
