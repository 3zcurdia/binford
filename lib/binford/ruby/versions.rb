class RubyVersions < Analyzer
  def url
    "https://rubygems.org/gems/#{gem}/versions"
  end

  def latest
    list.first
  end

  def [](version)
    hash[version]
  end

  def list
    @list ||= page.css(".t-list__items").css("li.gem__version-wrap").map do |node|
      version = node.css(".t-list__item")&.text
      date = node.css("small.gem__version__date")&.text&.sub("- ","")
      [version, date]
    end
  end

  def hash
    list.to_h
  end

  def dependencies
    @dependencies ||= pages.css(".dependencies").css(".t-list__items").map do |node|
      item =  node.css(".t-list__item")
      gem = item&.css("strong")&.text
      version = item&.text.sub(gem.to_s, '')
      [gem, version]
    end
  end

  def rails_dependencies
    dependencies
  end
end
