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



Your first Frankified App
-------------------------
Here are some detailed steps on how to create your first Frankified app. Screencast coming shortly.

1. Create your app! :-)
For this tutorial, we can just use an Apple template app.

    Open Xcode
    Create a new Xcode project from the menu or "File->New Project..."
    Choose iPhoneOS Application, Navigation-based Application. Leave everything as default and press the "Choose..." button
    Save as "SampleNavApp" and press "Save"
    You should now have a simple navigation based app. Go ahead and make sure it runs using "Build->Build and Run"

2. Copy your app target and add the Frank source to it

    In the "Groups & Files", under the "Targets" in the tree view, select the SampleNavApp target
    Right click or go to the "Edit" menu and select "Duplicate". A new Target will be created called "SampleNavApp copy"
    Right click and select "Rename". Type the new name of "SampleNavApp-Frankified"
    Click on "Project->Set Active Target->SampleNavApp-Frankified" to select this as the project we'll be building and putting into the simulator. You'll see the Frankified target get a little green checkbox in the "Groups & Files" list.
    In the "Groups & Files" select the first item at the very top, which is a "SampleNavApp" with a blue icon with a white "A" in it. 
    Right click and choose "Add->New Group". Type "Frank" for the name of the group. You should now have a folder with the name of "Frank" under the first "SampleNavApp". We'll be adding references to the Frank source into this folder.
    Right click on the "Frank" group that was just created and select "Add->Existing Files...". Navigate to where you cloned Frank at. While holding the command key down, select:
          frank_static_resources.bundle
          lib folder
          src folder
    Press the "Add" button. Another dialog will pop up and you can just hit "Add" there as well. These files and folders will now be added into the Frank group in Xcode.

3. Set the build settings for the Frankified Target

    Select "Project->Edit Active Target SampleNavApp-Frankified" to open up the target info window.
    Press the "General" tab at the top center of the window. At the bottom of the window, under the Linked Libraries list, there will be a "+" button. Press the "+" button, and in the dialog that pops up select "CFNetwork.framework" (8th one down) and then press the "Add" button.
    Confirm that the CFNetwork.framework is now listed in the Linked Libraries list.
    Select the "Build" tab at the top center of the window.
    Find "Other Linker Flags" in the list of settings. Protip: enter "other" into the "Search in build settings" field to shorten the list
    Select the Other Linker Flags setting. Click once on the Value column and enter
          -ObjC
    Note: If you double click on the Value you'll get a dialog to help you enter values. You can use it too, just hit "+" and then enter -ObjC there and then press "Ok".
    Find "Other C Flags" in the list of settings. If you used the protip it should be 12th down in the list from the "Other Linker Flags"
    Edit Other C Flags setting and add
         -DFRANK
    Close down the target info window view

4. Add the code to launch Frank into main. (We'll use conditional compilation rather than duplicating the main.m)

    Open your main.m file in your project using "File->Open Quickly...", typing main.m into the field and then pressing enter. Your project's main.m will be opened in the editor section in Xcode.
    At the top of your main.m add in:
        #ifdef FRANK
        #include "FrankServer.h"
        static FrankServer *sFrankServer;
        #endif
    Before the line "int retVal = UIApplicationMain(argc, argv, nil, nil);" add the following:
        #ifdef FRANK
	sFrankServer = [[FrankServer alloc] initWithDefaultBundle];
	[sFrankServer startServer];
        #endif
    These lines of code will compile Frank support into the app if "FRANK" is defined, which we did only for the Frankified target as the last thing in the previous step.

    Your main.m should look like so:

        #import <UIKit/UIKit.h>

        #ifdef FRANK
        #include "FrankServer.h"
        static FrankServer *sFrankServer;
        #endif

        int main(int argc, char *argv[]) {
            NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
        #ifdef FRANK
            sFrankServer = [[FrankServer alloc] initWithDefaultBundle];
            [sFrankServer startServer];
        #endif
            int retVal = UIApplicationMain(argc, argv, nil, nil);
            [pool release];
            return retVal;
        }

5. Enable Accessibility Features
    In OSX, go to System Preferences, Universal Access and check "Enable access for assistive devices".
    In the simulator open the Settings, then General->Accessibility->Accessibility Inspector and switch it to "On".

6. Build and Run
    Select "Build->Build and Run" to launch the app. You will see lots of warnings as the libraries that Frank uses are compiled, these are safe to ignore.
    You will see the app launch in the simulator. You may get a "Allow incoming connections" dialog, you should select "Allow" to let network connections in to the simulator
    Confirm that everything is working by connecting to the simulator using a browser. Open http://127.0.0.1:37265/ 
    

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
