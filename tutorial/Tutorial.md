Tutorial - Your first Frankified App
-------------------------
Here are some detailed steps on how to create your first Frankified app. Screencast coming shortly. 

**Please don't be intimidated by the length of this tutorial, it is also to help complete Xcode beginners**


Step 1. Create your app! :-)
============================
    
For this tutorial, we can just use an Apple template app.

* Open Xcode
* Create a new Xcode project from the menu or "File->New Project..."
* Choose iPhoneOS Application, Navigation-based Application. Leave everything as default and press the "Choose..." button
* Save as "SampleNavApp" and press "Save"

You should now have a simple navigation based app. Go ahead and make sure it runs using "Build->Build and Run"


Step 2. Copy your app target and add the Frank source to it
============================

Create a new Frank target as a copy of the main app target:

* In the "Groups & Files", under the "Targets" in the tree view, select the SampleNavApp target
* Right click or go to the "Edit" menu and select "Duplicate". A new Target will be created called "SampleNavApp copy"
* Right click and select "Rename". Type the new name of "SampleNavApp-Frankified"
* Click on "Project->Set Active Target->SampleNavApp-Frankified" to select this as the project we'll be building and putting into the simulator. You'll see the Frankified target get a little green checkbox in the "Groups & Files" list.

Add a Group for the Frank files

* In the "Groups & Files" select the first item at the very top, which is a "SampleNavApp" with a blue icon with a white "A" in it. 
* Right click and choose "Add->New Group". Type "Frank" for the name of the group. You should now have a folder with the name of "Frank" under the first "SampleNavApp". We'll be adding references to the Frank source into this folder.

Add Frank files to the new Group

* Right click on the "Frank" group that was just created and select "Add->Existing Files...". Navigate to where you cloned Frank at. While holding the command key down, select:
* frank_static_resources.bundle
* lib folder
* src folder

Press the "Add" button. Another dialog will pop up and you can just hit "Add" there as well. These files and folders will now be added into the Frank group in Xcode.

Step 3. Set the build settings for the Frankified Target
============================

Add the "CFNetwork.framework" to the list of linked libraries

* Select "Project->Edit Active Target SampleNavApp-Frankified" to open up the target info window.
* Press the "General" tab at the top center of the window. At the bottom of the window, under the Linked Libraries list, there will be a "+" button. Press the "+" button, and in the dialog that pops up select "CFNetwork.framework" (8th one down) and then press the "Add" button.
* Confirm that the CFNetwork.framework is now listed in the Linked Libraries list.
* Select the "Build" tab at the top center of the window.

Add "-ObjC" to the "Other Linker Flags" setting 

* Find "Other Linker Flags" in the list of settings. Protip: enter "other" into the "Search in build settings" field to shorten the list
* Select the Other Linker Flags setting. Click once on the Value column and enter
* * -ObjC
* Note: If you double click on the Value you'll get a dialog to help you enter values. You can use it too, just hit "+" and then enter -ObjC there and then press "Ok".

Add "-DFRANK" to the "Other C Flags" setting 

* Find "Other C Flags" in the list of settings. If you used the protip it should be 12th down in the list from the "Other Linker Flags"
* Edit Other C Flags setting and add -DFRANK
* Close down the target info window view

Step 4. Add the code to launch Frank into main. 
============================

We'll use conditional compilation rather than duplicating the main.m

* Open your main.m file in your project using "File->Open Quickly...", typing main.m into the field and then pressing enter. Your project's main.m will be opened in the editor section in Xcode.

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

* Your main.m should look like so:

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


Step 5. Enable Accessibility Features
============================

In OSX, go to System Preferences, Universal Access and check "Enable access for assistive devices".

In the simulator open the Settings, then General->Accessibility->Accessibility Inspector and switch it to "On".

Step 6. Build and Run
============================

Select "Build->Build and Run" to launch the app. You will see lots of warnings as the libraries that Frank uses are compiled, these are safe to ignore.

You will see the app launch in the simulator. You may get a "Allow incoming connections" dialog, you should select "Allow" to let network connections in to the simulator

Confirm that everything is working by connecting to the simulator using a browser. Open http://localhost:37265/ 

    
Step 7. Get Cucumber fired up
============================


Install Cucumber[http://cukes.info] if you don't have it installed already

Install the frank-cucumber gem:
    sudo gem install frank-cucumber

Create a skeletal cucumber directory structure inside your project directory by running the frank-skeleton command that was installed when you installed the frank-cucumber gem.

Run the cucumber command from your project directory. You should see cucumber attempt to run the initial cucumber feature that frank-skeleton installed. It will fail because you haven't yet defined what the "Given I launch the app" step should do.

Step 8. Write your first step
============================

First create a subdirectory inside of features called step_definitions. This is where your custom step definitions will live.

When you ran cucumber if should have given you a sample step definition in yellow text. Copy the step definition that it shows, starting with "Given".

In your editor, create a new file in your step_definitons directory called tutorial_steps.rb and paste in Given step definition

Delete the line that says "pending" and replace it with the following:

		launch_app_in_simulator
		wait_for_frank_to_come_up

So your whole step_definitions file should look like so:

		Given /^the app is launched$/ do
		  launch_app_in_simulator
		  wait_for_frank_to_come_up
		end 

Run "cucumber tutorial.feature" now and the simulator should launch and everything will run green

You'll see the words "FRANK!" get spelled out too in the output as the cucumber script connects to the frank server running in the simulator

Step 9. Write a second step to touch the plus button
============================


Switch back to the tutorial.feature file and add a "When" line to specify the action being taken like so:

		When I touch the Plus button

Run cucumber and copy the step snippet starting with "When /^I touch the Plus button$/ do" into your tutorial_steps.rb file

Now we need to figure out the UIScript that we need to send to actually touch the plus button. First we need to find out what we can about the button.

* Start up a browser and navigate to "http://localhost:37265"
* In the Selector entry field that comes up, type "navigationButton" (no quotes) and press * the "Flash matching elements link". You should see the + and the Edit button outlines flash briefly.
* Click on "Dump current DOM"
* Search for "NavigationButton", you should find a line with "class: UINavigationButton"

Looking at the DOM for this navigation button, we can see a few lines up that the accessibilityLabel has a value of "Edit", so this is the first button

Go to the next "NavigationButton" in the search and you can see that the next one has an accessibilityLabel of "Add"

Lets make sure we've got the right button. Go back to the "Selector" entry field and type "navigationButton marked:'Add'" and then click the "Flash matching elements" link. You will see the "+" button outline flash.

Note: UISpec is sensitive about spaces and even leaving a space between the colon and the 'Add' will cause it to crash. No problem, just restart the Simulator.

Switch back to your tutorial_steps.rb file and change the pending line to be:

		touch( "navigationButton marked:'Add'" )

Run cucumber and you should see a timestamp get added!

Your tutorial.feature file so far:

		Feature: Drive our SampleNavApp using Cucumber

		Scenario: Plus button adds timestamp
		  Given the app is launched
		  When I touch the Plus button

Your tutorial_steps.rb file so far:

		Given /^the app is launched$/ do
		  launch_app_in_simulator
		  wait_for_frank_to_come_up
		end

		When /^I touch the Plus button$/ do
		  touch( "navigationButton marked:'Add'" )
		end

At this point you could do a little refactoring to make the "Plus" a parameter


Step 10. Write a third step to validate the results
============================

Add a line to the scenario in the tutorial.feature file:

		Then I should see a table containing a timestamp
		
Run cucumber to get the step snippet and add it to the tutorial_steps.rb file

Switch to the browser and in the Selector field, type: "tableView" and click the "Flash matching elements" link. You will see the whole table flash

Now try entering "tableView tableViewCell first" (right out of the UISpec tutorial at http://code.google.com/p/uispec/wiki/Documentation#UIScript). You will see the first cell flash

Switch back to your tutorial_steps.rb and put in the following line:

		cell_label = frankly_map( "tableView tableViewCell first", "text" );

This sends the selector to Frank for the first cell and then asks Frank to return its "text" attribute. In this case we get back the complete timestamp

You would write more ruby here to validate the timestamp

Step 11. Final files
============================

The files for this tutorial are in the Frank/tutorial directory
