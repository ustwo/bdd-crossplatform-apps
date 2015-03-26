include GitHubMockBackend

Before do
  API.init
end

After do |scenario|

  if scenario.is_a?(Cucumber::Ast::OutlineTable::ExampleRow)
    title = "#{scenario.scenario_outline.feature.title}: #{scenario.scenario_outline.name} #{scenario.name}"
  elsif scenario.is_a?(Cucumber::Ast::Scenario)
    title = "#{scenario.feature.title}: #{scenario.title}"
  else
    title = ""
  end

  puts title

  API.set_response body: nil, status: nil, type: nil
  requests = API.get_requests

  if !requests.nil? && requests.size > 0

    puts "Requests to mocked backend (#{requests.size}):"

    requests.each do |request|
      puts "\t >>> #{request['fullpath']}"
    end
  else
    puts "No requests made to the mock backend"
  end

  API.init
  app_close
end

at_exit do
  Boot.exit
  CustomWorld.exit
end
