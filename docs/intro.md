# Full cycle testing for data driven client side applications

## Introduction

At ustwo we help clients define, design, build and test products. We also do it for ourselves.

Most of those are native mobile apps, but also incresingly web apps.

We think collaboration is key to put together amazing products and we have found in BDD the perfect trojan horse to make that collaboration happen.

The set up we describe below is what underpins the process from a technical point of view. We don't claim it's perfect or the only way of doing it, it's simply how we do it. One of the expected outcomes of publishing it is gathering feedback and improveing it. So yeah, we are all ears.


### What this is about

A reference for a project setup that enables:

 * Collaboration
 * Visibility over the development process
 * Robust client-side applications
 * Faster and cheaper testing of cross-platform applications

### What is not about

Not a tutorial about BDD or Cucumber.

Not about testing server-side applications.

Not an end to end testing set up.

Not about showing off iOS or Android skills. We've deliberately kept things as simple as possible to minimise the risk of beig distracted from the bigger picture.

Not a project template that you can clone, modify a few values on a configuration file and get your project up and running quickly.

## Main actors

 * Mobile app (iOS/Android) as the application under test
 * [Grape](http://intridea.github.io/grape/)/[Sinatra](http://www.sinatrarb.com/) as our local mock server
 * [Cucumber](http://cukes.info/) as the BDD tool of choice 
 * [Appium](http://appium.io/) as the test automation framework
 

### The application under test

Needs little code or modification for the purposes of testing.

We asume that the app solves the same business problems in all platforms. This will naturally lead to a very similar interface, which in turn helps sharing the testing codebase.

Please note that there's still room for each app to follow the interaction guidelines of its platform. See the Cucumber section below.

### Mock backend

Most client side applications are driven by data, typically coming from several sources. What happens on the client is dictated by the data the server feeds it.

So if we are going to thoroughly test how our client side application behaves then we need full control of what data the server is giving to it.

Other ways of achieving a similar outcome is using staging servers or local development servers. We think a dumb mock server offers advantages over those methods: simple, lightweight, flexible.

The downside is mostly (most likely manual) effort of keeping it sync with the real API. Its API must be a mirror of the production server API. 

Avoid implementing business logic.

 
### Cucumber

We consider Cucumber to be an esential part of the workflow. The benefits it brings in terms of collaboration far exceed the complexities it adds from a technical point of view.

Non-technical people disconnect as soon as anything resembling code shows up in the screen.

Declarative tests and page objects so the codebase is highly reusable across platforms. 

Dirty POs, clean steps.

### Appium

Cross-platform test automation framework that builds on top the JSON Wire Protocol, making it easier for QA engineers to move in between different platforms.

## How it works

 * We start the mock server in our local machine. 
 * App needs to have at least 2 modes: test and production
 * When in production, the app will be hardcoded to use the production server API (https://api.github.com) in our example.
 * When in test mode we point the app to the mock server running in our machine.
 * From a Cucumber scenario we define which data is going to be given to the app : ```Given there are no commits in the repo```.
 * Launch the app, take it to the point we want to test: ```And we are on the commit list screen```.
 * Assert the expected behaviour: ```Then we should see the no commits indicator```.
 
  
 
 
## Expected usage


### Interactive sessions

During early stages of the development it's likely that we have an idea of what we want to test and how we want to test it, but might want to have a go at it first before committing to it.

An interactive session allows just that by preparing the whole system for a testing session in which we can poke around with the data coming from the mock server or the elements of the application. Run:

```rake ios_interactive```

This in turn:

 * Prepares and compiles the app pointing it to the mock server
 * Boots up the mock server
 * Boots up a local Appium server 
 
Once that is up and running you can open up a new terminal and try something like (note that for Android this requires a device or emulator running already):

```require 'appium_lib'
caps = Appium.load_appium_txt file: 'appium.txt', verbose: true
driver = Appium::Driver.new({caps: caps})
driver.start_driver```

At that point Appium will install and start the app. You can beging the session by getting a dump of what is on screen:

```driver.page```

Use ```CTRL+C``` on the main tab to finish off the interactive session.  

### CI run through

This is where the CI (or a developer's machine) runs a subset of tests (using [Cucumber tags](https://github.com/cucumber/cucumber/wiki/Tags)) or full regression.

This is done by running something like:

 * ```rake android_bdd```
 * ```rake android_ios[@wip]```
 
## Limitations, considerations

### Not end to end testing

## Future

### How to abuse the tools to guarantee client apps conform to the API contract with the server  

## Links

Appium uses [UIAutomator](http://developer.android.com/tools/help/uiautomator/index.html) (Android) and [UIAutomation](https://developer.apple.com/library/ios/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/UsingtheAutomationInstrument/UsingtheAutomationInstrument.html) (iOS). Might be able to use Espresso as well.

[Appium concepts](https://github.com/appium/appium/blob/master/docs/en/about-appium/intro.md).

[Finding elements](https://github.com/appium/appium/blob/master/docs/en/writing-running-appium/finding-elements.md).

https://github.com/appium/ruby_lib/tree/master/docs

Appium docs:
https://github.com/appium/appium/tree/master/docs/en
