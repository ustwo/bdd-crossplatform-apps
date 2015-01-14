Before do
  $driver.reset
end

After do

  puts "Requests to mocked backend:"

  requests = GitHubMockBackend::API.get_requests

  if !requests.nil?
    requests.each do |request|
      puts request.fullpath
    end
  else
    puts "No requests made to the mock backend"
  end
end

at_exit do
  GitHubMockBackend::Boot.exit
  $driver.driver_quit
end
