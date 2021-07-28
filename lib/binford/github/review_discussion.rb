# frozen_string_literal: true

module Binford
  module Github
    class ReviewDiscussion
      include ::Binford::Utils

      attr_reader :conversation

      def initialize(commits, review_comments)
        @changes = commits.map { |commit| commit_info(commit) }
        @comments = review_comments.map { |comment| comment_info(comment) }
        @conversation = (@changes + @comments).sort { |a, b| a[:timestamp] <=> b[:timestamp] }
      end

      def author
        @author ||= changes.first[:author]
      end

      def reviewers
        @reviewers || comments.map { |comment| comment[:author] }.uniq - [author]
      end

      private

      attr_reader :changes, :comments

      def commit_info(commit)
        date_str = commit.dig(:commit, :author, :date) || commit.dig(:commit, :committer, :date)
        {
          type: :change,
          author: commit.dig(:author, :login),
          content: commit.dig(:commit, :message),
          timestamp: safe_parse_time(date_str)
        }
      end

      def comment_info(comment)
        {
          type: :comment,
          author: comment.dig(:user, :login),
          content: comment[:body],
          timestamp: safe_parse_time(comment[:created_at])
        }
      end
    end
  end
end
