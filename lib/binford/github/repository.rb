# frozen_string_literal: true

module Binford
  module Github
    class Repository
      attr_reader :client, :owner_repo

      def initialize(owner_repo, client:)
        @client = client
        @owner_repo = owner_repo
      end

      def pulls
        client.get("/repos/#{owner_repo}/pulls")
      end

      def pull(id)
        client.get("/repos/#{owner_repo}/pulls/#{id}")
      end

      def pull_reviews(id)
        client.get("/repos/#{owner_repo}/pulls/#{id}/comments?per_page=100")
      end

      def pull_commits(id)
        client.get("/repos/#{owner_repo}/pulls/#{id}/commits?per_page=100")
      end

      def issues
        client.get("/repos/#{owner_repo}/issues")
      end

      def issue(id)
        client.get("/repos/#{owner_repo}/issues/#{id}")
      end

      def projects
        client.get("/repos/#{owner_repo}/projects")
      end
    end
  end
end
