Please remember to read [different IDs per platform](testing_codebase_comments.md#different-element-ids-per-platform).

## Android

There are two ways to reference elements on the screen, IDs and accessibility labels.

For example, we have given the list that contains all the commits an Android ID of ```com.ustwo.sample.local:id/commit_list_listview_commits``` (we use the convention \<screen name\>_\<type\>_\<purpose\>) - but we could also set an accessibility label using the attribute 'contentDescription'. This attribute is used by screen readers and will be read aloud to users, so it must be kept understandable to a non developer and translated. 

A specific Android disadvantage of using a map of identifiers (see above) is that it is not product flavor or refactor friendly as the package name is contained with in the ID; changing the overall package name will break the tests.

To minimise any potential refactoring pain the package name should be defined in one place and appended at runtime. In this example, this logic can be found in ```base_screen.rb```. To test with multiple flavors - free, paid etc, we could pass the package name in as a parameter.

A complication is that the system UI uses the 'android' package name, e.g. a default progress dialog's ID is ```android:id/progress```. To get around this, the android map contains both the view ID and a boolean specifying whether the ID is already fully qualified or not. We assume the default value is false, as most of the IDs will be from our app and will need the package name to be appended.

```ruby
	def ids
	{
		commit_detail_root: {id: 'commit_detail_linearlayout_root'},
		commit_detail_loading_indicator: {id: 'android:id/progress', is_fully_qualified: true}
	}
	end
```

A significant benefit of using content descriptions is that they can be changed at runtime, allowing greater flexibility for testing things like images or custom UI elements which don't expose text. In this sample, we set a locked/unlocked padlock for private/public repositories and set a human readable content description, read from the ```strings.xml``` resources file. To test using a localised version of the app, we would just load the resource file from the relevant language's subdirectory, e.g. ```values-fr/strings.xml```.

We set the content description on the privacy view as follows:

```java
privacyStateView.setImageResource(repositoryInfo.isPrivate ? R.drawable.ic_private : R.drawable.ic_public);
```

Then in the test, we verify that the localised string 'Private repository' is on screen:

```ruby
has_element(get_string_resource('commit_list_repo_private'))
```

Translating accessibility strings on top of other strings in the app comes at an additional cost, but also a win that by setting those content descriptions, the app is now accessible for users who have visual impairments. 

Neither of these options is perfect - it's always preferable to lookup something by an unique ID rather than just some text, but we have found that we often need the flexibility of changing the accessibility labels at runtime. 

There could be an argument that we should be black box testing this and therefore using resource IDs would not be an option. Only content descriptions for where they are needed (image views, custom views) and everywhere else look for String literals.

It's a balance - if your app is only ever going to be in one language, or automating the testing in one language is an option, then it might be a better choice. On the other hand, if you have little or no custom UI components, then looking items up by ID could be all you need.

## iOS

Elements can have an accessibility identifier and an accessibility label - only the latter will be read out by a screen reader, if it's not empty, so using the identifier is the recommended way to go.
