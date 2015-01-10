Before { $driver.reset }

at_exit do
  GitHubMockBackend::Boot.exit
  $driver.driver_quit
end
