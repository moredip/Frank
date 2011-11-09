What is Frank?
----

Frank is 'Selenium for native iOS apps'. It allows you to write automated acceptance tests which verify the functionality of your native iOS app.

[Check out Frank in action!](http://sl.thepete.net/frank_ea_demo) This short screencast shows a sample iPhone app being exercised in the iPhone simulator by a set of cucumber tests.

<iframe src="http://player.vimeo.com/video/21860134" width="400" height="300" frameborder="0"></iframe>

[Watch a short presentation on Frank](http://bit.ly/fyUfJE) This is a recording of a 30 minute presentation Pete Hodgson did at the San Francisco Selenium meetup.

[Watch another presentation on Frank](http://www.melbournecocoaheads.com/testing-ios-apps-with-frank-slides-and-videos/) Stew Gleadow also did a Frank presentation, this one for the Melbourne Cocoaheads group.


Getting Started
---------------

Getting started is easy. You just need to install a ruby gem, create a new target for your app in XCode, and start writing cucumber tests. For detailed instructions check out tutorial/Tutorial.md.


Where can I ask questions?
-----
Please ask away in the [Frank google group](http://groups.google.com/group/frank-discuss). There's also an [FAQ page on the wiki](https://github.com/moredip/Frank/wiki/FAQs).

Goals
-----

* Provide support for automating functional testing of an iOS app.
* Support Cucumber primarily, but create an architecture which allows other tools such as JBehave or Fitnesse to also drive iOS tests. 
* Work on both the simulator and device.
* Provide tools and techniques to support BDD and automated regression testing.


Features
--------

* Embedded web app called Symbiote which allows inspection of live iOS UI as it is running, to ease the difficulty in writing complex selectors. [Here's a screencast demonstrating Symbiote](http://vimeo.com/22644221).
* Record Frank test runs as movies to see how the UI is responding throughout your script. We've found this very useful when included as a CI build artifact. 
* Leverage UISpec's UIQuery syntax to easily select specific GUI elements within your app.


Overview
--------

![Frank Architecture Overview](https://github.com/moredip/frank/raw/master/doc/Frank%20Architecture.png)

There are also slides from a [lightning talk](http://moredip.github.com/frank_lightning_talk_slides.html)
given by Pete about Frank.


Who?
----

Pete Hodgson

* [github - moredip](http://github.com/moredip)
* [blog - being agile](http://blog.thepete.net/)
* [twitter - @beingagile](http://twitter.com/beingagile)

Derek Longmuir

* [github - dlongmuir](http://github.com/dlongmuir)


Contributions welcome!
------------

We're always happy to accept documentation improvements, bug fixes and new features. Please fork this repo and
send a pull request. Feedback, suggestions and questions are always most welcome on the [mailing list](http://groups.google.com/group/frank-discuss).
