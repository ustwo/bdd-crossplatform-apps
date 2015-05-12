Please make sure you have gone through [installation and setup](setup.md).

## Running the tests

The simplest way to run the tests is "unattended", typically what a CI server would do. Tests are run sequentially, results are displayed at the end.

But unless you are a test automation wizard already, that's hardly how you start writing tests. We typically go through "interactive" sessions, please read on for more info.

### Interactive

During early stages of the development it's likely that we have an idea of what we want to test, but not sure how. Maybe we have doubts about the mock server, maybe about some interface elements of the app, maybe about the Appium APIs involved.

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

### Unattended

As mentioned before, the unnattended mode simply runs all the tests as you would expect. Typically what the CI would do, or maybe a developer running regression after implementing a new feature or fixing a bug.

Tests can be filtered out by using [Cucumber tags](https://github.com/cucumber/cucumber/wiki/Tags) (pass the tags using @ and NO spaces!):

 * ```rake android_bdd```
 * ```rake android_ios[@wip]``` <-- only runs tests tagged @wip

Please note that filtering scenarios using tags can get pretty complex, so if you need something more advanced (or use [Cucumber profiles](https://github.com/cucumber/cucumber/wiki/cucumber.yml)) you can call Cucumber directly but you'll need to call the the dependant rake tasks first.

You can see all tasks available by running ```rake -T```.

Read on about the [main concepts](overview.md) if you want to have an overview of what is going on.