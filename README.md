What is Frank?
----

Frank is 'Selenium for native iOS apps'. It allows you to write automated acceptance tests which verify the functionality of your native iOS app.

Learn More
----

[The Frank website](http://www.testingwithfrank.com) is your best resource. You'll find documentation, screencasts, video recordings of presentations, and links to further resources.


Getting Started
----

Getting started is easy, start by installing the `frank-cucumber` gem:

```bash
$ gem install frank-cucumber
```

Now you need to setup your project to use Frank, before you do this consider using a `.frankrc` configuration file (documented below) to customize your setup. You don't need a configuration file though, the command to run inside the root directory of your project is:

```bash
$ frank setup
```

You can now build a frankfied version of your app:

```bash
$ frank build
```

Test your frankified app by launching it in the simulator and opening the Symbiote inspector:

```bash
$ frank launch
$ frank inspect
```

If setup was successful you should see the Symbiote inspector in your browser.

`frank setup` created an example feature for you, you can run this now using cucumber (the path to your features directory may differ if you have a custom `.frankrc`), running cucumber you should see output like this:

```bash
$ cucumber Frank/features/
Feature: 
  As an iOS developer
  I want to have a sample feature file
  So I can see what my next step is in the wonderful world of Frank/Cucumber testing

  Scenario:                                             # Frank/features/my_first.feature:6
      Rotating the simulator for demonstration purposes
    Given I launch the app                              # Frank/features/step_definitions/launch_steps.rb:5
    Given the device is in landscape orientation        # /gems/frank-cucumber/core_frank_steps.rb:151
    Given the device is in portrait orientation         # /gems/frank-cucumber/core_frank_steps.rb:151
    Given the device is in landscape orientation        # /gems/frank-cucumber/core_frank_steps.rb:151
    Given the device is in portrait orientation         # /gems/frank-cucumber/core_frank_steps.rb:151

1 scenario (1 passed)
5 steps (5 passed)
0m15.410s
```

If you are having trouble go to [The Frank website](http://www.testingwithfrank.com) for further support. Otherwse you can now start writing your real cucumber tests!

Configuration via `.frankrc`
----

The `frank` command line interface supports a configuration file with the name `.frankrc` placed in the root directory of your project. If this file is present you can run `frank` from any sub-directory of the project and it will behave as if you ran it from the project's root directory.

This configuration file is in [YAML](http://www.yaml.org/) format and there are a number of settings you can control with this file.

_NOTE: For settings that define a path, a relative path will be treated as relative to the directory of the `.frankrc` file._

### `locations`
During `setup` and `update` Frank will copy in some initial files for your cucumber features and files required to build the frankified version of the target. You can control the paths these are copied to, and you can also define the output path for a `build` (defaults shown):

```yaml
locations:
  features: Frank/features
  build_files: Frank
  build_output: Frank/frankified_build
```

### `copy_build_files`
During `setup` and `update` Frank can copy three sets of files into the `build_files` directory within your project. Instead of being copied, all of these can be kept in the frank-cucumber gem and if you specify that no files should be copied then the `build_files` directory will not be created at all. By default all files are copied:

```yaml
copy_build_files: 
  # A frank_static_resources.bundle containing files used by 
  # the Symbiote inspector embedded in the frankified target:
  bundle: YES
  # The compiled library files linked into the frankfied target 
  # - `libFrank.a`, `libShelley.a` and `libCocoaHTTPServer.a`:
  libraries: YES
  # A `frankify.xcconfig` file with build settings specific to 
  # the frankified target:
  xcconfig: YES
```

### `xcode`
During a `build` Frank will try to find the correct Xcode project file and target, but it cannot do this successfully for all projects. You can provide this information to Frank rather than rely on automatic detection. Some projects will need additional build settings and these can be specified as a multiline string that will be included inside the `frankify.xcconfig` for the target:

```yaml
xcode:
  # Control the build configuration - i.e. you may want to test a Release build:
  configuration: Debug
  # build_settings is a string that will be included inside of frankify.xcconfig, 
  # place additional build settings in here as you would inside a xcconfig file
  build_settings:
  # project path and target name are automatically detected by default, if possible:
  project: 
  target: 
  # workspace path and scheme name are not used by default:
  workspace:
  scheme:
  # If without_cocoa_http_server is YES then libCocoaHTTPServer.a will not be
  # copied to the project or linked against the target:
  without_cocoa_http_server: NO
```

### Example `.frankrc`:
The following example is from a project that includes CocoaPods so it must be built with the workspace (and scheme) specified, it also has an additional build setting and does not copy any build files into the project. `configuration` and `without_cocoa_http_server` are sufficient at their default values so these are not included. A custom `features` location has been specified as a matter of preference and the `build_output` location has been defined as a path under `/tmp` as we don't want the build being placed in our project directory:

```yaml
---
copy_build_files:
  bundle: NO
  libraries: NO
  xcconfig: NO
locations:
  features: Tests/Features
  build_output: /tmp/frankified_build
xcode:
  build_settings: | 
    ONLY_ACTIVE_ARCH = NO
  project: Example.xcodeproj
  target: Example
  workspace: Example.xcworkspace 
  scheme: Example
```

Building from source
----
After cloning the repo on github, run `git submodule update --init --recursive` to pull in the 3rd party submodules Frank uses, and then run `rake` to build the Frank library. You can also build the library using XCode.


Contributions welcome!
----

We're always happy to accept documentation improvements, bug fixes and new features. Please fork this repo and
send a pull request. Feedback, suggestions and questions are always most welcome on the [mailing list](http://groups.google.com/group/frank-discuss).
