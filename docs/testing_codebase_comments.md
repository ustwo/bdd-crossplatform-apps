We go here through some of the code choices that we've made after a few BDD projects under our belt. Hardly any of them are something that you can blindly apply to your project, they are trade-offs based on our needs and those of our clients.

Please don't forget to read the [technical overview](overview.md) first.

## Custom world

The custom world acts as a page object for the app itself, allowing access to high level helpers in the step definitions (see [Cucumber docs](https://github.com/cucumber/cucumber/wiki/A-Whole-New-World) for more info). This helps keeping them simple and easy to read.

## Wrap calls to the driver inside the POs

We barely have any calls to the driver (Appium in this case) outside of page objects. Specifically, there are none in the step definitions, which are all "pure" Ruby and RSpec.

This makes step definitons fairly readable, particularly since accessing UI elements can get pretty tricky/ugly. We hide all that complexity behind the POs.

Incidentaly, this also helps handling cross-platform differences and decreases the chances of vendor lock-in to a specific driver.

## Screen Factory

The screen factory is responsible for returning appropiate page object instances based on the platform under test. 

Note that this is defined in the rake task executed and passed down through the Cucumber command as an [environment variable](https://github.com/cucumber/cucumber/wiki/Environment-Variables).

## Accomodating platform differences

While Appium provides a cross-platform API there are times when platform-specific page objects are required. We implement this by having a "base" PO for each screen, extended by platform specific POs. 

Here are a few reasons for this.

### The implementation of a user behaviour is different per platform

This happens when trying to conform to platform specific interaction guidelines so an user behaviour has to be implemented differently. For example, removing an element from a list could be implemented as a swipe in one platform vs a long press in another.

### Different view hierarchy per-platform

Sometimes even if the user behaviour is the same (say pressing a button), different platforms might have a view hierarchy that's different enough to require a different way of accessing those elements.

### Different element IDs per platform

Each platform has slightly different naming conventions and while it would be theoretically possible to force all element IDs to be exactly the same, some developers might find that requirement too intrusive.

To be able to have different element IDs per platform, we maintain a map of identifiers - so the step definition can simply use a common identifier, e.g. ```map[:commitlist_list]``` and each platform specific screen is responsible for adding the actual element ID. This is not particularly convenient because of the effort required to maintain the map of keys/values. 

You can read more, including Android vs iOS differences, in [finding elements](finding_elements.md).

## Acceptance tests vs unit tests

This question comes around 100 times per project: should we write acceptance tests or unit tests? And the most common answer is that you probably need both, since they serve different purposes.

Keep a few things in mind:

* Unit tests tend to be faster.
* Unit tests test code, not user journeys.
* Unit tests are platform specific, you need to code them for each platform.
* Unit tests tend to be written by developers only, no collaboration with the rest of the team.
* Unit tests usually change more often than acceptance tests.
* Acceptance tests give visibility over the app on a per-device basis, unit tests only verify a small isolated piece of logic.
* Acceptance tests tend to be more brittle... but they exercise a deeper piece of the stack, writing more unit tests are never going to replace automated acceptance tests, only a human tapping their way through the app will.

In our experience acceptance tests fail on different platforms due to instability of the tools or flakiness of the implementation, not because of some wild difference in the app on other platforms.

Test at the level which makes the most sense, generally this is as low as possible - verifiying something like whether a date formatter works in the way you expect is a small, isolated unit of behaviour - so it makes cover this logic with unit tests.

As they say, "unit tests ensure you build the thing right, while acceptance tests ensure you build the right thing". So, plan accordingly!

## Acceptance tests are slow!

We get this a lot. 

Ok, so slow compared to *what*? Yes, they tend to be slower than unit tests, but they are much faster than manual tests.

A BDD suite for a normal size app can easily take a couple of hours to run. Is that slow? Running full regression manually will take considerably longer, putting aside how error prone and boring is to repeat the same test script manually over and over again.

You can and should use [tags](https://github.com/cucumber/cucumber/wiki/Tags) to limit the number of tests you run and leave full regressions to for example nightly builds. 

We tend to use tags as follows: 

* Tag per feature, e.g. ```@login``` so that if a new user story for login is being worked on, it's easy to check nothing has been broken by the change.
* Have a tag for scenarios that have not been automated yet, e.g. ```@not-ready``` - this can also be extended to ```@ios-not-ready``` and ```@android-not-ready``` to account for differing velocities on different platforms.
* Tag the 'happy path', which is a limited set of tests which can be run quickly, as a sanity check that some core functionality has not been broken. What this means in terms of which scenarios to run for your project will depend on the product.
* Tag tests specific to a platform, so other platforms can ignore them, e.g. adding tag ```@android-only``` means ios can run ```~@android-only``` to ignore those ones.
* Tag tests that are difficult/impossible to automate, so it's clear they need to be done manually, e.g. ```@manual-only```.

## Your BDD implementation is slow!

On Android you could use Cucumber Android/JVM + Espresso instead of the official Cucumber runner (in Ruby) + Appium.

Espresso is definitely faster and has a richer API than Appium and you would be still using feature files to write the tests so you wouldn't miss out on collaboration. What's not to like?!

If you are only doing Android, and you are 100% sure that you won't ever need to do another platorm, then this might indeed be a better choice.

But if you choose tools that are not cross-platform (like Espresso) and still need to support several platforms, you would need to code and support a codebase for each of them.

## Localised strings

We never check for literals in our tests, we access the platform localistation files and use text IDs instead. This provides more robust tests because it enables:

 * Minor wording updates without breaking the tests.
 * Testing translated apps using the same set of tests.

We have arbitrarily implemented one of the tests to check for strings to prove the point. See the implementation of the scenario where the repository has no commits.

Each platform page object implements `has_commits_error_indicator` by checking that the actual string on screen (extracted from what's on screen by the Appium API) matches the expected value (read out from the localisation file used by the app).

In the current implementation we are not bothering to choose the locale at runtime from a configuration file and we simply read each of the localisation files:

 * Android: `android/app/src/main/res/values/strings.xml`
 * iOS: `ios/AppTestingSample/Localizable.strings`
 
Page objects can access values in those files by `key` through  their instance of `@string_resource` (which is platform specific, set in `base_screen.rb`).

