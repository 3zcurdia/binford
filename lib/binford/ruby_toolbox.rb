# frozen_string_literal: true

module Binford
  class RubyToolbox < WebService
    attr_reader :gem

    def initialize(gem)
      super("https://www.ruby-toolbox.com/", serializer: Serializers::HTML.new)
      @gem = gem
    end

    def data
      {
        name: gem,
        score: score,
        description: description,
        category: category
      }
    end

    def score
      @score ||= document&.xpath("/html/body/section/div/section/div/div[1]/div[2]/div[1]/span[2]")&.text&.to_f
    end

    def description
      @description ||= document&.xpath("/html/body/section/div/section/div/div[4]/div")&.text
    end

    def category
      @category ||= document&.xpath("/html/body/section/div/section/div/div[1]/div[2]/div[2]/div/a/p[2]")&.text
    end

    def document
      @document ||= get("/projects/#{gem}")
    end
  end
end
