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

## Installation

For all platforms:

 * ```bundle```
 * ```npm install```

### iOS

TBD

### Android

TBD

## Running tests

Use either ```rake android_bdd``` or ```rake ios_bdd```. 

You can limit the set of tests to be run by using [Cucumber tags](https://github.com/cucumber/cucumber/wiki/Tags) (pass the tags using @ and NO spaces!): 

```rake android_bdd[@wip]```

Please note that filtering scenarios using tags can get pretty complex, so if you need something more advanced you can call Cucumber directly but you'll need to call the the dependant rake tasks first.   

You can see all tasks available by running ```rake -T```.


## Mock backend

Can be run standalone:

```shotgun features/support/mock_backend/config.ru```

By default binds [http://localhost:9393](http://localhost:9393), use ```-o``` and ```-p``` to change the host or port.
