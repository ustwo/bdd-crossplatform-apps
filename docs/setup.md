## Requirements

This set up has only been tested on Unix machines, which is what we have at hand and use on a daily basis.

You'll need to install these dependencies by hand, please follow their installation and set up guidelines for your platform.

 * Ruby and RubyGems
 * Node

Once the basic dependencies are in place please run: 
 
 * ```gem install bundler```
 * ```bundle```
 * ```npm install```

### iOS

TBD

### Android

 * Android SDK v21
 * Java 7
 * Android Studio

Note: when opening the project into Android Studio be sure to choose the 'android' subdirectory or you may have problems compiling.

## Configuration

Copy to the root folder the sample iOS and/or Android YAML configuration files from the templates folder, updating the values as required.

Please note that for Android the emulator or device should be already connected or running and for iOS the combination of device and OS emulator should be available in the system already.

Once installation and configuration are done you can [run the tests](running_tests.md).




