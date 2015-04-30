Please make sure you have gone through [installation and setup](setup.md).

## Running tests

Use either ```rake android_bdd``` or ```rake ios_bdd```.

You can limit the set of tests to be run by using [Cucumber tags](https://github.com/cucumber/cucumber/wiki/Tags) (pass the tags using @ and NO spaces!):

```rake android_bdd[@wip]```

Please note that filtering scenarios using tags can get pretty complex, so if you need something more advanced you can call Cucumber directly but you'll need to call the the dependant rake tasks first.

You can see all tasks available by running ```rake -T```.

By default binds the mock server to your local IP address and port 9999.
