Frank
=====

An iPhone and iPad testing tool that uses UISpec's UIScript to
remotely drive an App. 

[Check out Frank in action!](http://sl.thepete.net/frank_ea_demo) This short screencast shows a sample iPhone app being exercised in the iPhone simulator by a set of cucumber tests.


Goals
-----

* Provide support for using Cucumber when developing an iOS app.
* Use UIScript syntax to drive the app
* Work on both the simulator and device
* Provide supporting tools and techniques for supporting BDD and
  regression testing


Features
--------

* Embedded web server allows inspection of iOS GUI to ease the
  difficulty in writing scripts
* Record Cucumber and simulator runs to see how the UI is responding


Overview
--------

![Frank Architecture Overview](http://github.com/moredip/frank/raw/master/doc/Frank%20Architecture.png)

There are also slides from a [lightning talk](http://moredip.github.com/frank_lightning_talk_slides.html)
given by moredip about Frank.


Getting Started
---------------

Getting started is easy. You just need to create a new target, add the
source, and set up cucumber. We'll go through those steps in more
detail below. 

While the details might look long and intimidating, we've tried to
make them easy to follow even for an Xcode beginner so if you are an
experienced iOS developer it will go very quickly.


Installing Frank
----------------

(see section below "Your first Frankified App" for detailed steps)

There is also a [brief screencast](http://screencast.com/t/XnW5pL8q)
showing these setup steps.

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
General->Accessibility->Accessibility Inspector and switch it to "On".


7. Build and run. You might get a warning about allowing incoming
connections depending on your firewall rules. Test out your install by
connecting to the embedded Frank server using your browser at
http://127.0.0.1:37265 . If everything has worked you'll see a simple
html page entitled "Symbiote" along with some controls to interrogate
the iOS app. The first time you compile, there will be many compiler
warnings from the included libraries. These can be safely ignored.


Writing Cucumber Steps
----------------------

* more to come - see the tutorial below for some getting started info


Tutorial - Your first Frankified App
------------------------------------

Moved - Please see the [tutorial/Tutorial.md](Frank/tree/master/tutorial/Tutorial.md) for detailed instructions.


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

* [github - dereklongmuir](http://github.com/dereklongmuir)


Please help!
------------

We are still working on improving this tool. Please fork this repo and
commit your changes. Feedback, suggestions and questions are welcome
<tell how to here>.


FAQ
---

* ** Why isn't Frank compiled as a static library?**

  Something to do with UISpec functionality not completely working
  when compiled as a static library. (Pete?)
