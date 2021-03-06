# cucumber-appium-ruby-example

This is an example framework to run automated BDD tests for Android and iOS.

## Prerequisites

* Mac
* Android SDK
* Xcode installed
* Ruby 2.1.1
* Appium

### Install appium and dependecies
This will install the command line version of appium.

    brew install node
    npm install -g appium@1.4.0
    npm install wd

Clone the framework

    git clone git@github.com:haroon-sheikh/cucumber-appium-ruby-example.git`

Navigate to the framework directoy

    cd cucumber-appium-ruby-example`

Install bundler and the gems the framework is dependent on

    gem install bundler
    bundle install

## Running tests

* The Appium server should be running, either from terminal or GUI.

    appium

Use Cucumber to run the tests.

    bundle exec cucumber -r features -p {CUCUMBER_PROFILE_HERE}

Cucumber profiles are listed in `cucumber.yml`.

### Android-specific features
In order to utilise the android specific features (logcat, screenrecording upon failure) you must give the test the Device Serial Number or UDID. This should be done with `udid={DEVICE_SERIAL}`.

Example:

    bundle exec cucumber -r features -p android_ci udid=HT293479

### Reruns
When running the tests on Jenkins we found that sometimes the tests would fail, either due to Appium instability or device not responding to touches etc.

To cater for this, we can use reruns. Each rerun will only run the failed tests from the previous run. If there are no failed tests from the initial run, the reruns will execute but not run any tests and pass.

Example usage where two (maximum) reruns are executed:

    bundle exec cucumber -r features -p android_ci
    bundle exec cucumber -r features -p android_ci_rerun @rerun.txt
    bundle exec cucumber -r features -p android_ci_rerun2 @rerun2.txt

### Starting Appium Server from within the framework

* Command line version of appium must be installed.

This may come in useful for running the tests from a CI Server, if you don't want to have to start and stop the appium server as a separate task.

When starting the tests, give the parameter `START_APPIUM=true` and you can also pass in any paremters for the appium server too.

Example:

    bundle exec cucumber -r features -p android_ci START_APPIUM=true APPIUM_PARAMETERS="--log-level debug"

### Custom APK and Package
Usually the app package is set in `env.rb` and the path to the application is set in `props.yml`. You can however, if required, specify these as parameters when starting the tests.

Example:

    bundle exec cucumber -r features -p android_ci apk=http://localhost:8080/jobs/app/lastsuccessfulbuild/build.apk package=com.app.package

* For iOS package isn't required, just path to the ipa itself can be given as a parameter.
