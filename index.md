---
layout: default
title: Painless iOS Testing With Cucumber
---

**Frank** allows you to write structured text test/acceptance
tests/requirements (using [Cucumber](http://www.cukes.info)) and have
them execute against your iOS application.

An example acceptance test:
{% highlight gherkin %}
Feature: Login to the app
Scenario: Successful login
  Given I launch the app
  When I log in with a valid userid and password
  Then I am on the start view
{% endhighlight %}

Frank also includes a powerful "app inspector" (called
[Symbiote](symbiote.html)) that you can use to get detailed
information on your running app.

## Features

* [**Easy Setup**](installing.html) - If you already have a working
  Ruby and Cucumber setup you can have Frank setup within your iOS app
  in minutes!
* **Record Video** - record video of your test runs to show the app in action
* **Run everywhere** - Run your tests on both the Simulator and Device
* **Integrates with CI** - Run your tests on every checkin
* [**Great Community**](mailing_lists.html) - A strong community of helpful people
