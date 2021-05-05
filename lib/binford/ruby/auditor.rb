class GemfileAuditor
  def initialize(file_path)
    @file_path = file_path
    puts "Analizing: #{@file_path}"
  end

  def audit
    parse.each do |gem, version|
      analyze(gem, version)
    end
  end

  def parse
    out = {}
    File.open(@file_path).each do |line|
      out[$1.tr(" ", "")] = $2 if line =~ /(.*)\s\(([\d\.]*)\)/
    end
    out
  end

  private

  def analyze(gem, version = nil)
    puts "\n## #{gem}"
    analyze_score(gem)
    analyze_dependencies(gem)
    analyze_version(gem, version)
  end

  def analyze_score(gem)
    toolbox = RubyToolbox.new(gem)
    puts toolbox.description
    report = "\n\t- RubyToolbox score: #{toolbox.score}"
    case toolbox.score
    when (20.0..)
      puts report.green
    when (10.0...20.0)
      puts report.blue
    when (1.0...10.0)
      puts report.yellow
    when (0.0...1.0)
      puts report.red
    else
      puts report
    end
  end

  def analyze_version(gem, version = nil)
    versions = RubyVersions.new(gem)
    puts "\t- Latest Version: #{versions.latest&.join(" - ")}"
    analyze_current_version(versions, version)
  end

  def analyze_dependencies(gem)
    dependencies = RubyDependencies.new(gem)
    return if dependencies.rails_dependencies.empty?
    puts "\t- Rails dependencies"
    dependencies.rails_dependencies.each do |rails_gem, version|
      puts "\t  * #{rails_gem} #{version}"
    end
  end

  def analyze_vulnerability(gem)
    vulnerable_gems = VulnerabilityGems.new(gem)
    return unless vulnerable_gems.vulnerable?
    puts "☢️ #{gem} is vulnerable"
  end

  private

  def analyze_current_version(versions, current)
    return unless current
    relased = versions[current]
    return unless relased
    report = "\t- Current Version : #{current} - #{relased}"
    report += "\n\t- Released #{distance_of_time_in_words(DateTime.now, DateTime.parse(relased))}"
    if current == versions.latest.first
      puts "#{report}, Updated ✅".green
    else
      puts "#{report}, Outdated ⚠️".yellow
    end
  end
end

if __FILE__ == $0
  if ARGV.length < 1
    puts "Gemfile.lock must be given"
    exit(1)
  end

  GemfileAuditor.new(ARGV[0]).audit
end
