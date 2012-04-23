---
layout: default
title: Step 2 - Install Frank
---
[Previous](installation-step1.html) | [Next](installation-step3.html) 

In a Terminal window, run:

{% highlight bash %}
$ gem install frank-cucumber 
{% endhighlight %}

 This will download and install the [Frank Rubygem](http://rubygems.org/gems/frank-cucumber). 

 **_Depending on your ruby setup you might need to run_ **
 {%highlight bash %} $ sudo gem install frank-cucumber {% endhighlight %}

At this point, you should create an [XCode project for your app](https://developer.apple.com/library/ios/#referencelibrary/GettingStarted/RoadMapiOS/Introduction/Introduction.html)
(unless you already have a project setup!!)

In a Terminal window: 

{% highlight bash %}
$ cd /path/to/my/awesome/apps/source 
$ frank-skeleton
{% endhighlight %}

This will add a `Frank` subdirectory containing Frank's server code plus some
initial cucumber plumbing to your app (after checking with you first!).

[Previous](installation-step1.html) | [Next](installation-step3.html) 
