# frozen_string_literal: true

module Binford
  module Github
    class Repository
      attr_reader :api, :base_path

      def initialize(owner_repo, api_client: nil)
        @base_path = "/repos/#{owner_repo}"
        @api = api_client || ApiClient.new
      end

      def pulls(state: "all", page: "1")
        api.get("#{base_path}/pulls?state=#{state}&per_page=100&page=#{page}")
      end

      def pull(id)
        api.get("#{base_path}/pulls/#{id}")
      end

      def pull_discussion(id)
        commits = Thread.new { pull_commits(id) }
        comments = Thread.new { pull_reviews(id) }
        ReviewDiscussion.new(commits.value, comments.value)
      end

      def pull_reviews(id)
        api.get("#{base_path}/pulls/#{id}/comments?per_page=100")
      end

      def pull_commits(id)
        api.get("#{base_path}/pulls/#{id}/commits?per_page=100")
      end

      def issues
        api.get("#{base_path}/issues")
      end

      def issue(id)
        api.get("#{base_path}/issues/#{id}")
      end

      def projects
        api.get("#{base_path}/projects")
      end
    end
  end
end
