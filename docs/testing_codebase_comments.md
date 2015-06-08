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

#### Android

There are two ways to reference elements on the screen, ids and accessibility labels.

For example, we have given the list that contains all the commits an android id of `com.ustwo.sample:id/commit_list_listview_commits` (we use the convention <screen name>_<type>_<purpose>) - but we could also set an accessibility label using the attribute 'contentDescription'. This attribute is used by screen readers and will be read aloud to users, so it must be kept understandable to a non developer and translated. 

To be able to have different element IDs per platform, we maintain a map of identifiers - so the step definition can simply use a common identifier, e.g. `map[:commitlist_list]` and each platform specific screen is responsible for adding the actual element ID. This is not ideal, because it's a bit of an overhead to maintain the map of keys/values, but it also makes it not product flavour or refactor friendly as the package name is contained with in the id - changing the overall package name will break the tests. It's also harder to copy/paste things in to tools like arc or pry because the id is defined in a different place to the usage.

To minimise any potential refactoring pain, the package name should be defined in one place and appended at runtime. The complication to this, is that system UI uses the 'android' package name, for example an alert dialog button's id is `android:id/button1`.

A significant benefit of using content descriptions is that they can be changed at runtime, allowing greater flexibility for testing things like images or custom UI elements which don't expose text. In this sample, we set a locked/unlocked padlock for private/public repositories and set a human readable content description, read from the strings.xml resources file. To test using a localised version of the app, we would just load the resource file from the relevant language's subdirectory, e.g. `values-fr/strings.xml`.


##### iOS

Elements can have an accessibility identifier, and an accessibility label - the latter of these will be read out by a screen reader, so using the identifier is preferable.

## Acceptance tests vs unit tests

This question comes around 100 times per project: should we write acceptance tests or unit tests? And the most common answer is that you probably need both, since they serve different purposes.

Keep a few things in mind to make that call:

* Unit tests tend to be faster.
* Unit tests test code, not user journeys.
* Because of the above, unit tests will hardly fail on different devices or OS versions, hence they give no visibility over the state of the app on a per-device, per-OS basis. Acceptance tests do.
* Unit tests are platform specific, you need to code them once per platform.
* Unit tests tend to be written by developers only, no collaboration with the rest of the team.
* Acceptance tests tend to be more brittle... but they exercise a deeper piece of the stack, writing more unit tests are never going to replace automated acceptance tests, only a human tapping their way through the app will.

Test at the level which makes the most sense, generally as high as possible - verifiying something like whether a date formatter works in the way you expect is small and isolated and would be easy to test at the unit level. As they say, "unit tests ensure you build the thing right, while acceptance tests ensure you build the right thing". So, plan accordingly!

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
