We go in here through some of the choices we've made after a few BDD projects under our belt. Hardly any of them are something that you can blindly apply to your project. They are trade-offs based on our needs and those of our clients.

## Custom world

The custom world allows to have high level helpers in the step definitions, see the [Cucumber docs](https://github.com/cucumber/cucumber/wiki/A-Whole-New-World) for more info.

It's also a bit of a PO for the app itself.

## All calls to the driver wrapped up in POs

Please note that there are barely any calls to the driver (Appium in this case) outside of Page Objects. Specifically, there are none in the step definitions, which are all "pure" Ruby and RSpec.

This makes step definitons fairly readable, particularly since accessing UI elements can get pretty tricky/ugly, but all that complexity is behind the POs.

## Screen Factory

### Accomodating platform differences

## BDD vs TDD

This question comes around 100 times per project: should we BDD or TDD? Keep a few things in mind to make that call:

* Unit tests tends to be faster (more below).
* Unit tests test code, not user journeys.
* Because of the above, unit tests will hardly fail in different devices or OS versions, hence they give no visibility over the state of the app on a per-device, per-OS basis. BDD tests do.
* Unit tests are platform specific, you need to code them once per platform.
* Unit tests tend to be written by developers only, hardly any collaboration with the rest of the team.
* BDD tests tend to be more brittle... but they exercise a deeper piece of the stack.

As they say, "TDD helps coding the thing right, BDD helps coding the right thing", so plan accordingly!

## BDD tests are slow!

We get this a lot. Slow compared to *what*? Yes, they tend to be slower than unit tests, but in our experience they are much faster than manual tests.

A BDD suite for a normal size app can easily take a couple of hours to run. Is that slow? Again, compared to what? Running 500 tests manually will take considerably longer (putting aside how boring is to repeat the same test script manually over and over again).

You can and should use [tags](https://github.com/cucumber/cucumber/wiki/Tags) to limit the number of tests you run and leave full regressions to for example nightly builds. 

## Your BDD implementation is slow!

On Android you could use Cucumber Android + Espresso instead of the official Cucumber runner (in Ruby) + Appium.

Espresso is definitely faster and has a richer API than Appium, you would be still using feature files to write the tests so you wouldn't miss out on collaboration, so what's not to like?!

If you are only doing Android, and you are 100% sure that you won't ever need to do another platorm, then this might indeed be a better choice.

But if you choose tools that are not cross-platform (like Espresso) and still need to support several platforms, you would need to code and support a testing code base for each of them.
