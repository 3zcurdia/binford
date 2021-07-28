# frozen_string_literal: true

module Binford
  module Github
    class PullRequest
      include ::Binford::Utils
      attr_reader :id, :data

      def initialize(data)
        @data = data
      end

      def churn
        @churn ||= data[:review_comments].to_i + data[:commits].to_i
      end

      def elapsed_time
        case data[:state]
        when "open"
          Time.now - created_at
        when "closed"
          (merged_at || closed_at) - created_at
        end
      end

      def created_at
        @created_at ||= safe_parse_time(data[:created_at])
      end

      def closed_at
        @closed_at ||= safe_parse_time(data[:closed_at])
      end

      def merged_at
        @merged_at ||= safe_parse_time(data[:merged_at])
      end
    end
  end
end
