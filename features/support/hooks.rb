Before do
  GitHubMockBackend::API.init
end

After do |scenario|
  if scenario.is_a?(Cucumber::Ast::OutlineTable::ExampleRow)
    title = "#{scenario.scenario_outline.feature.title}: #{scenario.scenario_outline.name} #{scenario.name}"
  elsif scenario.is_a?(Cucumber::Ast::Scenario)
    title = "#{scenario.feature.title}: #{scenario.title}"
  else
    title = ""
  end
  $stdout.puts "\n\t#{title}"

  GitHubMockBackend::API.set_response body: nil, status: nil, type: nil
  requests = GitHubMockBackend::API.get_requests
  if !requests.nil? && requests.size > 0
    $stdout.puts "\t#{requests.size} requests made to the mock backend"

    requests.each_with_index do |request, index|
      $stdout.puts "\t\t##{index} #{request['fullpath']}"
    end
  else
    $stdout.puts "\tNo requests made to the mock backend"
  end

  GitHubMockBackend::API.init
  app_close
end

at_exit do
  GitHubMockBackend::Boot.exit
  CustomWorld.exit
end
