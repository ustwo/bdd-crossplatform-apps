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

To be able to have different element IDs per platform, we maintain a map of identifiers - so the step definition can simply use a common identifier, e.g. ```map[:commitlist_list]``` and each platform specific screen is responsible for adding the actual element ID. This is not ideal because of the effort required to maintain the map of keys/values. 

#### Android

There are two ways to reference elements on the screen, ids and accessibility labels.

For example, we have given the list that contains all the commits an android id of ```com.ustwo.sample.local:id/commit_list_listview_commits``` (we use the convention <screen name>_<type>_<purpose>) - but we could also set an accessibility label using the attribute 'contentDescription'. This attribute is used by screen readers and will be read aloud to users, so it must be kept understandable to a non developer and translated. 

A specific Android disadvantage of using a map of identifiers (see above) is that it is not product flavor or refactor friendly as the package name is contained with in the id; changing the overall package name will break the tests.

To minimise any potential refactoring pain the package name should be defined in one place and appended at runtime. In this example, this logic can be found in the ```base_screen.rb```. To test with multiple flavors - free, paid etc, we could pass the package name in as a parameter.

A complication is that the system UI uses the 'android' package name, e.g. a default progress dialog's id is ```android:id/progress```. To get around this, the android map contains both the view id and a boolean specifying whether the id is already fully qualified or not. We assume the default value is false, as most of the ids will be from our app and will need the package name to be appended.

```ruby
	def ids
	{
		commit_detail_root: {id: 'commit_detail_linearlayout_root'},
		commit_detail_loading_indicator: {id: 'android:id/progress', is_fully_qualified: true}
	}
	end
```

A significant benefit of using content descriptions is that they can be changed at runtime, allowing greater flexibility for testing things like images or custom UI elements which don't expose text. In this sample, we set a locked/unlocked padlock for private/public repositories and set a human readable content description, read from the strings.xml resources file. To test using a localised version of the app, we would just load the resource file from the relevant language's subdirectory, e.g. ```values-fr/strings.xml```.

We set the content description on the privacy view as follows
```java
privacyStateView.setImageResource(repositoryInfo.isPrivate ? R.drawable.ic_private : R.drawable.ic_public);
```

Then in the test, we verify that the localised string 'Private repository' is on screen:
```ruby
has_element(get_string_resource('commit_list_repo_private'))
```

Translating accessibility strings on top of other strings in the app comes at an additional cost, but also a win that by setting those content descriptions, the app is now accessible for users who have visual impairments. 

Neither of these options is perfect - it's always preferable to lookup something by an unique id rather than just some text, but we have found that we often need the flexibility of changing the accessibility labels at runtime. 

There could be an argument that we should be black box testing this and therefore using resource ids would not be an option. Only content descriptions for where they are needed (image views, custom views) and everywhere else look for String literals.

It's a balance - if your app is only ever going to be in one language, or automating the testing in one language is an option, then it might be a better choice. On the other hand, if you have little or no custom UI components, then looking items up by id could be all you need.

##### iOS

Elements can have an accessibility identifier, and an accessibility label - only the latter of these will be read out by a screen reader, if it's not empty, so using the identifier is the recommended way to go.

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
