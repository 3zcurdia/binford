# frozen_string_literal: true

module Binford
  class RubyGems < WebService
    attr_reader :gem

    def initialize(gem)
      super("https://rubygems.org/", serializer: Serializers::HTML.new)
      @gem = gem
    end

    def data
      {
        name: gem,
        versions: versions,
        dependencies: dependencies,
        rails_dependencies: rails_dependencies
      }
    end

    def current(version)
      {
        version: version,
        released_at: (versions ? versions[version] : nil)
      }
    end

    def versions
      @versions ||= versions_document&.css(".t-list__items")&.css("li.gem__version-wrap")&.map do |node|
        parse_node_version(node)
      end&.to_h
    end

    def dependencies
      @dependencies ||= document&.css(".dependencies")&.css(".t-list__items")&.map do |node|
        parse_node_dependency(node)
      end
    end

    def rails_dependencies
      dependencies&.select { |dependency, _| rails_gems.include?(dependency) }
    end

    private

    def parse_node_version(node)
      version = node.css(".t-list__item")&.text
      date = node.css("small.gem__version__date")&.text&.sub("- ", "")
      [version, date]
    end

    def parse_node_dependency(node)
      item = node.css(".t-list__item")
      dependency = item&.css("strong")&.text
      version = item&.text&.sub(dependency.to_s, "")
      [dependency.strip, version.strip.gsub("\n", "")]
    end

    def document
      @document ||= get("gems/#{gem}")
    end

    def versions_document
      @versions_document ||= get("gems/#{gem}/versions")
    end

    def rails_gems
      @rails_gems ||= %w[actionpack actionview actioncable actionmailer activerecord
        active_model_serializers activejob activesupport activemodel activestorage activeadmin]
    end
  end
end
