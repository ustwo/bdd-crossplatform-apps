# Full cycle application testing

## Requirements

 * Ruby and RubyGems
 * Bundler (```gem install bundler```)
 * Node

### iOS

TBD

### Android

 * Android SDK v21
 * Java 7

 Note: when opening the project in to Android Studio, be sure to choose the 'android' subdirectory or you may have problems compiling.

## Installation

For all platforms:

 * ```bundle```
 * ```npm install```

### iOS

TBD

### Android

TBD

## Running tests

Copy to the root folder the sample iOS and/or Android configuration files from the templates folder, updating the values as required. Please note that for Android the emulator or device should be already connected or running and for iOS the combination of device and OS emulator should be available in the system already.

Use either ```rake android_bdd``` or ```rake ios_bdd```.

You can limit the set of tests to be run by using [Cucumber tags](https://github.com/cucumber/cucumber/wiki/Tags) (pass the tags using @ and NO spaces!):

```rake android_bdd[@wip]```

Please note that filtering scenarios using tags can get pretty complex, so if you need something more advanced you can call Cucumber directly but you'll need to call the the dependant rake tasks first.

You can see all tasks available by running ```rake -T```.

## Mock backend

Can be run standalone:

```bash
rake boot_mock
```

By default binds the mock server to your local IP address and port 9999.
