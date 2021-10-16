# frozen_string_literal: true

module Binford
  class GemfileStats
    def initialize(file_path)
      @file_path = file_path
      @lock_file = file_path.end_with?("Gemfile.lock")
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

    attr_reader :file_path, :lock_file

    def parse_gems
      File.open(file_path).each_with_object(acc) do |line, acc|
        next unless line.match?(parser_regex)

        gem = Regexp.last_match(1).tr(" ", "")
        version = Regexp.last_match(2)
        acc[gem] = version
      end
    end

    def parser_regex
      @parser_regex ||= if lock_file
                          /(.*)\s\(([\d.]*)\)/
                        else
                          /gem\s+['"]([[:word:]\-_]*)['"](\s*,\s*['"][\s~>=]*[\d.]*['"])?/
                        end
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
