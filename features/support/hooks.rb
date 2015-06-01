include GitHubMockBackend

Before do
  API.init
end

After do |scenario|

  puts "\n\t#{scenario.name}"

  API.set_response body: nil, status: nil, type: nil
  requests = API.get_requests

  if !requests.nil? && requests.size > 0
    puts "\t#{requests.size} requests made to the mock backend"

    requests.each_with_index do |request, index|
      puts "\t\t##{index} #{request['fullpath']}"
    end
  else
    puts "\tNo requests made to the mock backend"
  end

  API.init
  app_close
end

at_exit do
  Boot.exit
  CustomWorld.exit
end
