---
layout: default
title: Step 9 - Running your first Cucumber feature
---
[Previous](installation-step8.html) 

So, you have your app all Frankified and ready to be tested!
Lets run our first Cucumber feature!

From the Frank skeleton directory within your app, run cucumber

{% highlight bash %}
cd /path/to/your/app/Frank
cucumber
{% endhighlight %}

Cucumber will attempt to run the feature that has
been pre-defined (when you ran the `frank-cucumber` command) in `features/my_first.feature` 

It is likely that Cucumber will not run on the first attempt since it
requires a variable named `APP_BUNDLE_PATH` to be defined.

`APP_BUNDLE_PATH` must contain the complete path to where the
Frankified app bundle lives (e.g /path/to/HelloWorld Frankified.app)


To set `APP_BUNDLE_PATH`, you can edit the file
`features/support/env.rb` and set
`APP_BUNDLE_PATH=/path/to/your-frankified-app-name.app` 

Rerun the `cucumber` command and you should see the iOS simulator gets
fired up and put through the steps defined in the sample feature! 

To help you get started, Frank comes with a bunch of
[predefined steps](supplied_steps.html) such as:
{% highlight gherkin %}
When I touch "([^\"]*)"
When I type "([^\"]*)" into the "([^\"]*)" text field
{% endhighlight %}

Browse around this site to get more info. Happy testing :)

[Previous](installation-step8.html)
