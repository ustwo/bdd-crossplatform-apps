# Full cycle testing for data driven client side applications

## Introduction

At ustwo we define, design, build and test digital products, for our clients and for ourselves.

Most of those are native mobile apps, but also incresingly web apps.

We think collaboration is key to putting together amazing products and we have found in BDD the perfect trojan horse to make that collaboration happen.

The setup we describe below is what underpins the process from a technical point of view. We don't claim it's perfect or the only way of doing it, it's simply how *we* do it. One of the expected outcomes of making it public is gathering feedback and improving it. So yeah, we are all ears.

### What this is about

A reference or guide for a project setup that enables:

 * Collaboration, particularly with non-technical people.
 * Visibility over the development process.
 * Robust client-side applications.
 * Faster and cheaper testing of cross-platform applications.
 * Faster, cheaper integration with backend.

### What this is not about

 * Not a tutorial about BDD or Cucumber.
 * Not about testing server-side applications.
 * Not about showing off iOS or Android skills. We've deliberately kept things as simple as possible to minimise the risk of distracting from the bigger picture.
 * Not an end to end testing setup.
 * Not a project template that you can clone, modify a few values on a configuration file and get your project up and running quickly.

## Main actors

 * Mobile app (iOS/Android) as the application under test.
 * [Grape](http://intridea.github.io/grape/)/[Sinatra](http://www.sinatrarb.com/) as our local mock server.
 * [Cucumber](http://cukes.info/) as the BDD tool of choice.
 * [Appium](http://appium.io/) as the functional automation framework.
 
### The application under test

Needs little code or modification for the purposes of testing.

We asume that the app solves the same business problems in all platforms. This will naturally lead to a very similar interface, which in turn helps sharing the testing codebase.

Please note that there's still room for each app to follow the interaction guidelines of its platform and platform specific test if required. See the Cucumber section below.

### Mock backend

Most client side applications are driven by data, typically coming from several sources. What happens on the client is mostly dictated by the data the server feeds it.

So if we are going to thoroughly test how our client side application behaves, particularly in non-ideal scenarios, then we need full control of what data the server is giving to it.

Other ways of achieving a similar outcome are using services like [Apiary](http://apiary.io/), staging servers or local development servers, but we think a *dumb* mock server offers advantages over those methods: simpler, lightweight, more flexible.

For example, imagine we want to test how our application behaves when the server returns a 500 error for an API call. Forcing this on an instance of the real server, even if it's running locally, is not straightforward. Let alone that sometimes fronted teams can't possibly run local versions of the backend (complicated dev environments, belongs to a 3rd party).

This is where a local mock backend excels. It's very easy from a Cucumber step definition to force the mock backend to return a 500 error for a given API call, then assert in another step that the application is handling the error as expected (displaying an appropriate error message, for example).

The downside of the mock server is mostly the manual effort required to keep it in sync with the real API. 

We always try to avoid implementing business logic in the mock backend and limit it to returning static resources (JSON, images). 
 
### Cucumber

We consider Cucumber to be an esential part of the workflow. The benefits it brings in terms of collaboration far exceed the complexities it adds from a technical point of view over other lower level, platform specific options.

Cucumber scenarios are written in plain text enabling tests written in a language that is very close to the domain problem ([DSLs](http://martinfowler.com/bliki/BusinessReadableDSL.html)). This highly increases the chances of engaging non-technical people, which is crucial to collaboration.

Declarative tests and page objects so the codebase is highly reusable across platforms. 

Step definitions are kept free of UI and automation framework specifics, making them easier to read and less brittle. The complexities of extracting information or interacting with the interface are kept inside the page objects. We always aim for "clean steps and dirty POs".

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

```ruby
require 'appium_lib'
caps = Appium.load_appium_txt file: 'appium.txt', verbose: true
driver = Appium::Driver.new({caps: caps})
driver.start_driver
```

At that point Appium will install and start the app. You can beging the session by getting a dump of what is on screen:

```ruby
driver.page
```

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
