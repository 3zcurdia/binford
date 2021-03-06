# frozen_string_literal: true

require_relative "binford/version"
require_relative "binford/configuration"
require_relative "binford/serializers/json"
require_relative "binford/serializers/html"
require_relative "binford/utils"
require_relative "binford/web_service"
require_relative "binford/github"
require_relative "binford/ruby_toolbox"
require_relative "binford/ruby_gems"
require_relative "binford/gemfile_stats"
require_relative "binford/trends"

module Binford
  class Error < StandardError; end
end
