---
layout: default
title: Installing Frank
---

## Turn on Accessability Features

You will need to turn on the accessibilty features on both your
desktop and the simulator. Frank uses the accessibility labels to
identify controls within your app.

* *Desktop* - go to System Preferences, select Universal Access, and
   check “Enable access for assistive devices”.
* *Simulator/Device* -  launch the settings app, select General,
   select Accessibility, and then switch the Accessibility Inspector
   to On. 

In the simulator you will now have a little Accessibility Inspector
window permanently overlayed. Annoyingly there’s nothing you can do
about this apart from drag it to one side of the screen.


## Add the Frank Server to your iOS app

There is a [Screencast](http://vimeo.com/27691115) from Pete where you
can follow along.

### Step 1: Install the frank-cucumber gem
Simply run `gem install frank-cucumber` from the command line to
download and install the gem. Depending on your ruby setup you might
need to run `sudo gem install frank-cucumber`

### Step 2: Add the Frank skeleton directory to your app source code
In the terminal cd to your app's source code directory (e.g. where the
xcode project file lives), and execute `frank-skeleton`. This will add
a `Frank` subdirectory containing Frank's server code plus some
initial cucumber plumbing, after checking with you first.

### Step 3: Create a Frankified target
You need to create a seperate XCode app target for a 'Frankified'
version of your app. This Frankified target will link the Frank server
component into your app, so that it can be automated. 

In XCode, switch to the Project Navigator by hitting Command-1, and
then select your project by clicking on it. You should now see your
project settings, with one or more targets listed. Right-click on your
main app target, and select "Duplicate". You may be asked if you want
to transition to an iPad target. If so, select "Duplicate Only". You
should now see a new target created called `"<YourAppName> copy"`, or
similar. Rename the target to `"<YourAppName> Frankified"`

### Step 4: Add the Frank server to your Frankified target
right-click on your project In the Project Navigator at the far left,
choose `"Add Files To <YourAppName>"`. Select the Frank directory which
you just added to your source directory in the previous step. In the
"Add to targets" section at the bottom of the dialog make sure you
check only the Frankified target you just created, and uncheck any
other targets. Now you can click Add.

### Step 5: Add the CFNetwork dependency to your Frankified target
The Frank server uses the CFNetwork framework. If you're app isn't
already using it you'll need to add it as a dependency. In the Project
Navigator, select your project again, and select the "Build Phases"
tab. Expand the "Link Binary With Libraries" section, and click the +
icon. Select "CFNetwork.framework" from the list of frameworks, then
click Add. 

### Step 6: Add necessary linker flags
Still in the project settings, select the "Build Settings" tab. Find
the "Other Linker Flags" entry, and add -all_load and -ObjC flags to
the Frankified target.

### Step 7: Test 'er out!
You should be good to go at this point. Select the Frankified target
from the Scheme Selector (at the top, just to the right of the Run and
Stop buttons), then hit Run. You should see your app build and launch
as normal. But, if you now open up
[http://localhost:37265](http://localhost:37265) in a browser
you should see your app presented to you by Symbiote, the app
inspector embedded within Frank. That means you've successfully
Frankified your application. *Congratulations!*

### Next Steps
Next up you will probably want to try running some simple cucumber
tests to check they work.

Check out [Configuration](configuration.html) for how to change the
simulator type (iPhone/iPad) and version.
