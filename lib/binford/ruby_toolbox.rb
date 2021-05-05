class RubyToolbox
  def initialize(gem, serializer: Serializers::HTML.new)
    @gem = gem
  end

  def score
    @score ||= page.xpath("/html/body/section/div/section/div/div[1]/div[2]/div[1]/span[2]")&.text&.to_f
  end

  def description
    @description ||= page.xpath("/html/body/section/div/section/div/div[4]/div")&.text
  end

  private

  attr_reader :gem, :serializer

  def page
    @page ||= serializer.call(HTTParty.get(url))
  end

  def url
    "https://www.ruby-toolbox.com/projects/#{gem}"
  end
end
