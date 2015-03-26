# Full cycle testing for data driven client side applications

## Introduction

At ustwo we define, design, build and test digital products, for our clients and for ourselves.

We think collaboration is key to putting together amazing products and we have found in BDD the perfect excuse to make that collaboration happen.

The setup we describe below is what underpins the process from a technical point of view. We don't claim it's perfect or the only way of doing it, it's simply how *we* do it. One of the expected outcomes of making it public is gathering feedback and improving it. So yeah, we are all ears.

### What this is about

A reference for a project setup that enables:

 * Collaboration, particularly with non-technical people.
 * Visibility over the development process.
 * Robust client-side applications.
 * Faster and cheaper testing of cross-platform applications.
 * Faster, cheaper integration with backend.

### What this is not about

 * Not a tutorial about BDD or Cucumber.
 * Not about testing backend applications.
 * Not about showing off iOS or Android skills. We've deliberately kept things as simple as possible to minimise the risk of distracting from the bigger picture.
 * Not an end-to-end testing setup.
 * Not a project template that you can clone, modify a few values on a configuration file and get your project up and running quickly.

## Main actors

 * Mobile app (iOS/Android) as the application under test.
 * [Sinatra](http://www.sinatrarb.com/) as our local mock server.
 * [Cucumber](http://cukes.info/) as the BDD tool of choice.
 * [Appium](http://appium.io/) as the functional automation framework.

### The application under test

Needs little code or modification for the purposes of testing.

We asume that the application solves the same business problems in all platforms which will naturally lead to a similar interface. However, the setup still leaves room for some platform specific differences, see the Cucumber section below.

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

Cucumber scenarios are written in plain text enabling tests written in a language that is very close to the domain problem ([DSLs](http://martinfowler.com/bliki/BusinessReadableDSL.html)). This increases the chances of engaging non-technical people and reduces the chances of misunderstandings.

We favour [declarative vs imperative](http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html) tests and use [page objects](http://developer.xamarin.com/guides/testcloud/calabash/xplat-best-practices/) (POs) so the testing codebase is highly reusable across platforms. This combination also enables platform specific implementation of behaviours. For example, selecting an item on a list could be implemented as a swipe on iOS and as a long press on Android.

Step definitions are kept free of UI and automation framework specifics, making them easier to read and less brittle. The complexities of extracting information or interacting with the interface are kept inside the page objects. We aim for "*clean steps and dirty POs*".

### Appium

Cross-platform test automation framework that builds on top the [JSON Wire Protocol](https://code.google.com/p/selenium/wiki/JsonWireProtocol).

## How it works

 * It starts a local Appium server.
 * It starts a local mock server which is binded to the local IP address of the machine running the tests (developer's machine, CI server). Note that it can't use ```localhost``` since **when on a device ```localhost``` would resolve to the device itself**.
 * It sets the base URL for the API/backend to the local IP address the previous step binded the mock server to.
 * It compiles the app.
 * It starts Cucumber.

At this point is Cucumber business as usual, for example:

 * Define which data is going to be given to the app : ```Given there are no commits in the repo```.
 * Launch the app, take it to the point we want to test: ```And we are on the commit list screen```.
 * Assert the expected behaviour: ```Then we should see the no commits indicator```.

## Expected usage


### Interactive sessions

During early stages of the development it's likely that we have an idea of what we want to test, but not sure how.

An interactive session facilitates this by preparing the whole system for a session in which we can poke around with the data coming from the mock server or the elements of the application. Run:

```ruby
rake ios_interactive
```

This in turn:

 * Prepares and compiles the app pointing it to the mock server
 * Boots up the mock server, if required
 * Boots up a local Appium server, if required

Once all is up and running you can open up a new terminal and try something like (note that for Android this requires a device connected or the emulator running already):

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

This is when the CI (or a developer's machine) runs the tests or a subset of them.

This is done by running something like:

 * ```rake android_bdd```
 * ```rake android_ios[@wip]```

## Tips and tricks

Keep instances of the mock backend and the local Appium server running on their own tabs so consecutive test runs are faster and there is less noise on the terminal.

## Limitations, considerations

### Appium limitations

### Not end to end testing

Automated functional testing of the client side application does not guarantee that there won't be integration issues with the backend.

However, the risk can be reduced by using a subset of the BDD tests for end-to-end tests, using the real application server and the real application under test.

### Always put time aside for exploratory testing

Even assuming that you could achieve 100% automation coverage, is always important to do some exploratory testing.  

## Links

Appium uses [UIAutomator](http://developer.android.com/tools/help/uiautomator/index.html) (Android) and [UIAutomation](https://developer.apple.com/library/ios/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/UsingtheAutomationInstrument/UsingtheAutomationInstrument.html) (iOS).

[Appium concepts](https://github.com/appium/appium/blob/master/docs/en/about-appium/intro.md).

[Finding elements](https://github.com/appium/appium/blob/master/docs/en/writing-running-appium/finding-elements.md).

https://github.com/appium/ruby_lib/tree/master/docs

Appium docs:
https://github.com/appium/appium/tree/master/docs/en
