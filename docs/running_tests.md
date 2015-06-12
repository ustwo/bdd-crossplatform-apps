Please make sure you have gone through [installation and setup](setup.md).

## Running the tests

Tests are run sequentially, results are displayed at the end.

Use the following commands:
```rake android_bdd[~@manual-only]``` or ```rake ios_bdd[~@manual-only]```

### Running specific tests using tags

Tests can be filtered out by using [Cucumber tags](https://github.com/cucumber/cucumber/wiki/Tags) (pass the tags using @ and NO spaces!):

 * ```rake android_bdd``` <-- run everything (not commonly used seeing as we have some manual tests)
 * ```rake android_bdd[@wip]``` <-- only runs tests tagged @wip
 * ```rake android_bdd[~@manual-only]``` <-- run all tests that do not have the @manual-only tag

Please note that filtering scenarios using tags can get pretty complex, so if you need something more advanced (or use [Cucumber profiles](https://github.com/cucumber/cucumber/wiki/cucumber.yml)) you can call Cucumber directly but you'll need to call the the dependant rake tasks first.

You can see all tasks available by running ```rake -T```.

Read on about the [main concepts](overview.md) if you want to have an overview of what is going on.

## Writing new tests

It can be difficult to write a new test just by running the scenario over and over - we typically go through "interactive" sessions.

During early stages of the development it's likely that we have an idea of what we want to test, but we're not sure how. Maybe we have doubts about the mock server, maybe about some interface elements of the app, maybe about the Appium APIs involved.

An interactive session facilitates this "discovery" by preparing the whole system for a session in which we can poke around with the data coming from the mock server or the elements of the application. For example run:

```bash
rake ios_interactive
```

This in turn:

 * Prepares and compiles the app pointing it to the local mock server.
 * Boots up the mock server, if required.
 * Boots up a local Appium server, if required.

Once all is up and running you can open up a new terminal, start IRB or PRY, and try something like this:

```ruby
require 'appium_lib'
caps = Appium.load_appium_txt file: 'appium.txt', verbose: true
driver = Appium::Driver.new({caps: caps})
driver.start_driver
```

[Note that for Android this requires the device connected or the emulator running already.]

Appium will install and start the app and when done you can begin the session by getting a dump of what is on screen:

```ruby
driver.page
```

Use ```CTRL+C``` on the main tab to finish off the interactive session.  