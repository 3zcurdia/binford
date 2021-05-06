# frozen_string_literal: true

module Binford
  class GemfileStats
    def initialize(file_path)
      @file_path = file_path
    end

    def stats
      gems.map do |gem, version|
        Thread.new { analyze(gem, version) }
      end.map(&:value)
    end

    def gems
      @gems ||= parse_gems
    end

    private

    attr_reader :file_path

    def parse_gems
      out = {}
      File.open(file_path).each do |line|
        out[Regexp.last_match(1).tr(" ", "")] = Regexp.last_match(2) if line =~ /(.*)\s\(([\d.]*)\)/
      end
      out
    end

    def analyze(gem, version)
      fibers = []
      fibers << Fiber.new { ruby_toolbox_data(gem) }
      fibers << Fiber.new { rubygems_data(gem, version) }
      fibers.map(&:resume).inject({}, &:merge!)
    end

    def ruby_toolbox_data(gem)
      RubyToolbox.new(gem).data
    end

    def rubygems_data(gem, version)
      rubygems = RubyGems.new(gem)
      rubygems.data.merge(current: rubygems.current(version))
    end
  end
end
