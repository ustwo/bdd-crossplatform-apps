require_relative 'blocking_command'

class CucumberCommand < BlockingCommand
  def initialize(platform, tags, appium_server_url)
    @cmd = "cucumber -c PLATFORM=#{platform} APPIUM_SERVER_URL=#{appium_server_url}"

    return unless !tags.nil? && tags.size > 0

    # NOTE (JD): Cucumber tags can get pretty complex, choosing
    # the simplest option here for now. Haven't been able to find
    # a decent way of getting Cucumber and Rake to get on well because
    # of how rake tasks get parameters. I'm all ears.
    # More info:
    #   * https://github.com/cucumber/cucumber/wiki/Tags
    @cmd = @cmd + ' --tags ' + tags.join(',')
  end
end
