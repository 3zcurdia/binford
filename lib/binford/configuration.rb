# frozen_string_literal: true

module Binford
  class Configuration
    attr_accessor :github_token
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end
  end

  def self.configure
    yield(configuration)
  end
end
