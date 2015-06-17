Please make sure you have gone through [installation and setup](setup.md).

## Running the tests

Use either ```rake android_bdd``` or ```rake ios_bdd```

With this command we run all of the tests for a particular platform (Android or iOS) that are not tagged as `@manual-only`, since that's what is defined as the default Cucumber profile in `cucumber.yml`. You can read more about why we write scenarios that we know we won't be able to automate in the [codebase comments](testing_codebase_comments.md). 

We consider everything to be working as expected when a run excluding all the manual tests passes. Test are run sequentially and the results displayed at the end:

![A successful run](success.png)

### Running specific tests using profiles or tags

Tests can be filtered out by using Cucumber [tags](https://github.com/cucumber/cucumber/wiki/Tags) and [profiles](https://github.com/cucumber/cucumber/wiki/cucumber.yml):

 * ```rake android_bdd``` <-- runs everything but manual tests
 * ```rake android_bdd[wip]``` <-- only runs tests tagged @wip (as defined in the wip profile)

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