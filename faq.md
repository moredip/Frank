---
layout: default
title: Frequently Asked Questions
---

In an unusual twist, these are actually questions that are frequently
asked on the [frank-discuss mailing list](mailing_lists.html)!

## Can I use Frank to test an app that I haven't built myself?

No sorry. In order to test an application with Frank you need to
compile or link the Frank server into the application you are testing.

## Can I use Frank to test web-based apps?
If you want to test a pure web app (no native code at all) then Frank can't help you, but [the WebDriver project's iPhoneDriver](http://code.google.com/p/selenium/wiki/IPhoneDriver) is a good option. If you have a hybrid app (a Native app which uses web views to implement some of the UI) then Frank does have some functionality to inspect the state of a web view, and evaluate javacript, but it's fairly basic for now.

## Is there a way to stop Frank waiting so long when it can't find a UI element?

Technically there should be a way to do this by modifying UISpec, the
library Frank uses to inspect the application UI. However, due to the
idosyncratic way that UISpec is implemented it has been very
challenging to fix this. If you have a solution, please contribute a
patch!


## Can I use Frank to execute arbitrary code in my app as part of a test?

Yes. Frank exposes an app_exec command which you can use to execute
any method which your app delegate implements.

## Can I automate a physical device using Frank.

Yes, people have this working. However it is still experimental at
this point. Ask on the mailing list for more details.


## How can I automate filling out a text field using the keyboard?
There are various solutions to this, depending on how your application
is implemented. Check out the [Steps contributed by
users](user_steps.html), or ask on the mailing list for more details. 
