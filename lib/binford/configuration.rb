# frozen_string_literal: true

module Binford
  class Configuration
    attr_accessor :github_token
  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
