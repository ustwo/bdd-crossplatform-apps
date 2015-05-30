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

This happens when trying to conform to platform specific interaction guidelines so an user behaviour has to be implemented differently. For example, removing an element from a list could be implemented as a swipe in one platform vs. a long press in another.

### Different view hierarchy per-platform

Sometimes even if the user behaviour is the same (say pressing a button), different platforms might have a view hierarchy that's different enough to require a different way of accessing those elements.

### Different element IDs per platform

Each platform has slightly different naming conventions and while it would be theoretically possible to force all element IDs to be exactly the same, some developers might find that requirement too intrusive.

## BDD vs TDD

This question comes around 100 times per project: should we BDD or TDD? And the most common answer is that you probably need both, since they serve different purposes.

Keep a few things in mind to make that call:

* Unit tests tend to be faster (more below).
* Unit tests test code, not user journeys.
* Because of the above, unit tests will hardly fail on different devices or OS versions, hence they give no visibility over the state of the app on a per-device, per-OS basis. BDD tests do.
* Unit tests are platform specific, you need to code them once per platform.
* Unit tests tend to be written by developers only, no collaboration with the rest of the team.
* BDD tests tend to be more brittle... but they exercise a deeper piece of the stack.

As they say, "unit tests ensure you build the thing right, while acceptance tests ensure you build the right thing". So yeah, plan accordingly!

## BDD tests are slow!

We get this a lot. 

Ok, so slow compared to *what*? Yes, they tend to be slower than unit tests, but they are much faster than manual tests.

A BDD suite for a normal size app can easily take a couple of hours to run. Is that slow? Running full regression manually will take considerably longer, putting aside how error prone and boring is to repeat the same test script manually over and over again.

You can and should use [tags](https://github.com/cucumber/cucumber/wiki/Tags) to limit the number of tests you run and leave full regressions to for example nightly builds. 

## Your BDD implementation is slow!

On Android you could use Cucumber Android + Espresso instead of the official Cucumber runner (in Ruby) + Appium.

Espresso is definitely faster and has a richer API than Appium and you would be still using feature files to write the tests so you wouldn't miss out on collaboration. What's not to like?!

If you are only doing Android, and you are 100% sure that you won't ever need to do another platorm, then this might indeed be a better choice.

But if you choose tools that are not cross-platform (like Espresso) and still need to support several platforms, you would need to code and support a testing code base for each of them.
