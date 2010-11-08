Frank
=====

An iPhone and iPad testing tool that uses UISpec's UIScript to
remotely drive an App. 


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

6. Build and run. You might get a warning about allowing incoming
connections depending on your firewall rules. Test out your install by
connecting to the embedded Frank server using your browser at
http://127.0.0.1:37265 . If everything has worked you'll see a simple
html page entitled "Symbiote" along with some controls to interrogate
the iOS app. The first time you compile, there will be many compiler
warnings from the included libraries. These can be safely ignored.


Writing Cucumber Steps
----------------------



Your first Frankified App
-------------------------
Here are some detailed steps on how to create your first Frankified app.

1. Create your app! :-)
For this tutorial, we can just use an Apple template app.



Anything else?
--------------

See the <ruby> file for additional functions that may be helpful in
your Cucumber scripts.


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






--- old doc from here down, document refactoring in progress


About
-----

Frank is an iPhone/iPad UI testing tool. It combines UISpec with an
embedded HTTP server. This means it can be driven externally by
cucumber for example.

[Check out Frank in action!](http://sl.thepete.net/frank_ea_demo) This short screencast shows a sample iPhone app being exercised in the iPhone simulator by a set of cucumber tests.

Architecture
----
![Frank Architecture Overview](http://github.com/moredip/frank/raw/master/doc/Frank%20Architecture.png)

Getting Started
-----
Check out the [Getting Started with Frank](https://github.com/moredip/Frank/wiki/Getting-started-with-Frank) page on the github wiki!
