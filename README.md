What is Frank?
=====

An iPhone and iPad testing tool that uses UISpec's UIScript to
remotely drive an App. 

[Check out Frank in action!](http://sl.thepete.net/frank_ea_demo) This short screencast shows a sample iPhone app being exercised in the iPhone simulator by a set of cucumber tests.

Where can I ask questions?
-----
Please ask away in the [Frank google group](http://groups.google.com/group/frank-discuss).


Goals
-----

* Provide support for automating functional testing of an iOS app.
* Support Cucumber primarily, but create an architecture which allows other tools such as JBehave or Fitnesse to also drive iOS tests. 
* Work on both the simulator and device.
* Provide tools and techniques to support BDD and automated regression testing.


Features
--------

* Embedded web app allows inspection of live iOS GUI as it is running, to ease the difficulty in writing scripts.
* Record Frank test runs as movies to see how the UI is responding throughout your script. We've found this very useful when included as a CI build artifact. 
* Leverage UISpec's UIQuery syntax to easily select specific GUI elements within your app.


Overview
--------

![Frank Architecture Overview](http://github.com/moredip/frank/raw/master/doc/Frank%20Architecture.png)

There are also slides from a [lightning talk](http://moredip.github.com/frank_lightning_talk_slides.html)
given by Pete about Frank.


Getting Started
---------------

Getting started is easy. You just need to create a new target, add the
source, and set up cucumber. We'll go through those steps in more
detail below. 

While the details might seem a little intimidating, we've tried to
make them easy to follow even for an Xcode beginner. If you are an
experienced iOS developer it should be a breeze.


Installing Frank
----------------

(see section below "Your first Frankified App" for detailed steps)

1. Duplicate your app target, creating a new "Frankified" target

2. Create a Frank group in your project to hold the Frank source
you'll be adding. Add the lib, src and frank_static_resources bundle
to your Frankified target

3. Add the CFNetwork.framework linked library to your Frankified target

4. Add -ObjC flag to your "Other Linker Flags" settings, again in your
Frankified target

5. Add the code to launch Frank to the Frankified app. You can do this
either by creating a whole new main.m just for testing with Frank or
by using conditional compilation.
To create a whole new main.m, duplicate your main.m file and add the
Frank launching code to it. See the sample provided in
Frank/main.m.sample. Be sure to use your new main.m in the Frankified
target and continue to use your original main.m in your original
target.

6. Enable accessibility features. In OSX, go to System Preferences,
Universal Access and check "Enable access for assistive devices". In
the simulator open the Settings, then
General->Accessibility->Accessibility Inspector and switch it to "On". This [brief screencast](http://screencast.com/t/XnW5pL8q) demonstrates how to do that.


7. Build and run. You might get a warning about allowing incoming
connections depending on your firewall rules. Test out your install by
connecting to the embedded Frank server using your browser at
http://localhost:37265 . If everything has worked you'll see a simple
html page entitled "Symbiote" along with some controls to interrogate
the iOS app. The first time you compile, there will be many compiler
warnings from the included libraries. These can be safely ignored.


Writing Cucumber Steps
----------------------

* more to come - see the tutorial below for some basic info

Also see "cucmber/frankly_steps.rb" for some predefined steps

Tutorial - Your first Frankified App
------------------------------------

Please see the [tutorial/Tutorial.md](Frank/tree/master/tutorial/Tutorial.md) for detailed instructions on how to get started testing *your* iPhone or iPad application with Frank today!


Anything else?
--------------

There are a couple of files to get you started writing your cucumber and gherkin.

* See **cucumber/frankly_steps.rb** for steps that can be used in your cucumber scenarios.
* See **cucumber/frank_helper.rb** for more low level ruby calls that can be used in writing steps.


Who?
----

Pete Hodgson

* [github - moredip](http://github.com/moredip)
* [blog - being agile](http://blog.thepete.net/)
* [twitter - @beingagile](http://twitter.com/beingagile)

Derek Longmuir

* [github - dlongmuir](http://github.com/dlongmuir)


Please help!
------------

We are still working on improving this tool. Please fork this repo and
commit your changes. Feedback, suggestions and questions are most welcome.

FAQ
---

* ** Why isn't Frank compiled as a static library?**

	Some of the functionality provided by UISpec does not appear to work when compiled in as a static library. If anyone has a way to make Frank work as a static library we'd love to hear about it!
