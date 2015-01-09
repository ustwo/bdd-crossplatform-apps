# Before { $driver.start_driver }
# After { $driver.driver_quit }

at_exit do
  GitHubMockBackend::Boot.exit
end
