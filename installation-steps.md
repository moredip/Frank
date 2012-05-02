---
layout: default
title: Installing Frank
---

## Step 1 - Turn on Accessibility features

You will need to turn on the accessibilty features on both your
desktop and the iPhone/iPad simulator. 

Frank uses accessibility labels to identify controls within your app.

* **Desktop** - go to System Preferences -> Universal Access
and Check “Enable access for assistive devices”.
![Universal Access Screenshot](images/screenshots/mac-universal-access.png)

* **Simulator/Device** -  launch the settings app, select General,
   select Accessibility, and then switch the Accessibility Inspector
   to On. 
![iOS Simulator Accessibility Screenshot](images/screenshots/ios-accessibility-inspector.png)

In the simulator you will now have a little Accessibility Inspector
window permanently overlayed. Annoyingly there’s nothing you can do
about this apart from drag it to one side of the screen.

## Step 2 - Install Frank
In a Terminal window, run:

{% highlight bash %}
$ gem install frank-cucumber 
{% endhighlight %}

This will download and install the [frank-cucumber gem](http://rubygems.org/gems/frank-cucumber). 

**_Depending on your ruby setup you might need to run_ **
{%highlight bash %}
$ sudo gem install frank-cucumber
{% endhighlight %}

## Step 3 - Run frank-skeleton

At this point, you should create an [XCode project for your app](https://developer.apple.com/library/ios/#referencelibrary/GettingStarted/RoadMapiOS/Introduction/Introduction.html)
(unless you already have a project setup!!)

In a Terminal window, cd to your project directory (folder where the
.xcodeproj file lives) and run frank-skeleton: 

{% highlight bash %}
$ cd /path/to/my/awesome/app
$ frank-skeleton
{% endhighlight %}

This will add a `Frank` subdirectory containing Frank's server code plus some
initial cucumber plumbing to your app (after checking with you first!).

## Step 4 - Create a Frankified target!

You need to create a seperate XCode app target for a 'Frankified'
version of your app. This Frankified target will link the
[Frank server component](frankly.html) into your app, so that it can be automated. 

In XCode, switch to the Project Navigator by hitting Command-1, and
then select your project by clicking on it. You should now see your
project settings, with one or more targets listed. 

Right-click on your main app target, and select "Duplicate". 

![Right-click on app target](./images/screenshots/xcode-duplicate-target.png)

You may be asked if you want to transition to an iPad target. 
If so, select "Duplicate Only". 
![Duplicate only](./images/screenshots/xcode-transition-ipad.png)

You should now see a new target created called `"<YourAppName> copy"`, or
similar. Rename the target to `"<YourAppName> Frankified"`
![Frankified target](./images/screenshots/xcode-app-frankified.png)

## Step 5 - 'Frankify' your app

### Add the Frank server to your Frankified target
Right-click on your project In the Project Navigator at the far left,
choose `"Add Files To <YourAppName>"`. 
![Add Files to Project](./images/screenshots/xcode-add-files-to-project.png)

Select the Frank directory which you just added to your source
directory in the previous step. 

In the "Add to targets" section at the bottom of the dialog make sure you
check only the Frankified target you just created, and uncheck any
other targets. Now you can click Add.
![Only add to Frankified Target](./images/screenshots/xcode-add-frank-to-target.png)

[Previous](installation-step4.html) | [Next](installation-step6.html) 


## Step 6 - Add dependencies

The Frank server uses the
[CFNetwork framework](https://developer.apple.com/library/mac/#documentation/Networking/Conceptual/CFNetwork/Introduction/Introduction.html). 

If you're app isn't already using it you'll need to add it as a dependency. 

In the Project Navigator, select your project again, select the
"Frankified Target" and select the "Build Phases" tab. 

Expand the "Link Binary With Libraries" section, and click the + icon. 

![XCode Build Phases Tab](./images/screenshots/xcode-build-phases-tab.png)

Select "CFNetwork.framework" from the list of frameworks, then click
Add. 
![Add CFNetwork Framework](./images/screenshots/xcode-add-cfnetwork.png)


## Step 7 - Add linker flags

In the same project settings screen (for the Frankified target),
select the "Build Settings" tab, and find the "Other Linker Flags" entry.  
![Other Linker Flags](./images/screenshots/xcode-other-linker-flags.png)

Add `-all_load` and `-ObjC` flags to the Debug flags.
![Debug flags added](./images/screenshots/xcode-debug-flags-added.png)

## Step 8 - Test 'er out!

You are almost done at this point. 

Select the Frankified target<sup><strong>1</strong></sup> from the Scheme Selector (at the top, just to the right of the Run and
Stop buttons), then hit Run. You should see your app build and launch as normal.
![Xcode Run Simulator](./images/screenshots/xcode-run-simulator.png)

If you now open up [http://localhost:37265](http://localhost:37265) in a browser
you should see your app presented to you by Symbiote, the app
inspector embedded within Frank! 

![Symbiote screenshot](./images/screenshots/symbiote-screen.png)

That means you've successfully Frankified your application. 

Congratulations! You're ready to write [Cucumber stories](user_stories.html) and automate
 your iOS testing!

**\[1\]** XCode might not show the right name in the Scheme Selector. In XCode 4.3, it shows *"YourAppName Copy"* instead
of *"YourAppName Frankified"* as it should!

## Step 9 - Running your first Cucumber feature

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
