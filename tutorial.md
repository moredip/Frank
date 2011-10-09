---
layout: default
title: Tutorial
---

# **I need to run through this one time to verify**

***Everything should be working or close to working, I've just
moved it over from the old documentation and cleaned it up where I saw
problems***

## Create a blank app to play with
    
For this tutorial, we can just use an Apple template app.

* Open Xcode
* Create a new Xcode project from the menu or "File->New Project..."
* Choose iPhoneOS Application, Navigation-based Application. Leave
  everything as default and press the "Choose..." button
* Save as "SampleNavApp" and press "Save"

You should now have a simple navigation based app. Go ahead and make
sure it runs using "Build->Build and Run"

## Go through the Frank installation steps

Add the Frank lib to the SampleNavApp using [these instructions](installing.html)

## Make sure Cucumber is working correctly

Run the cucumber command from your project directory. You should see
cucumber attempt to run the initial cucumber feature that
frank-skeleton installed. It will fail because you haven't yet defined
what the "Given I launch the app" step should do.

## Write your first step

There will be a subdirectory inside of features called
step_definitions. This is where your custom step definitions will
live.

When you ran cucumber if should have given you a sample step
definition in yellow text. Copy the step definition that it shows,
starting with "Given".

In your editor, create a new file in your step_definitons directory
called tutorial_steps.rb and paste in Given step definition

Delete the line that says "pending" and replace it with the following:

	launch_app_in_simulator
	wait_for_frank_to_come_up

So your whole step_definitions file should look like so:

	Given /^the app is launched$/ do
	  launch_app_in_simulator
	  wait_for_frank_to_come_up
	end 

Run `cucumber tutorial.feature` now and the simulator should launch
and everything will run green

You'll also see the words "FRANK!" get spelled out in the output as
the cucumber script connects to the frank server running in the
simulator

## Write a second step to touch the plus button

Switch back to the tutorial.feature file and add a "When" line to
specify the action being taken like so:

	When I touch the Plus button

Run cucumber and copy the step snippet starting with "When /^I touch
the Plus button$/ do" into your tutorial_steps.rb file

Now we need to figure out the UIScript that we need to send to
actually touch the plus button. First we need to find out what we can
about the button.

* Start up a browser and navigate to "http://localhost:37265"
* In the Selector entry field that comes up, type "navigationButton"
  (no quotes) and press * the "Flash matching elements link". You
  should see the + and the Edit button outlines flash briefly.
* Click on "Dump current DOM"
* Search for "NavigationButton", you should find a line with "class: UINavigationButton"

Looking at the DOM for this navigation button, we can see a few lines
up that the accessibilityLabel has a value of "Edit", so this is the
first button

Go to the next "NavigationButton" in the search and you can see that
the next one has an accessibilityLabel of "Add"

Lets make sure we've got the right button. Go back to the "Selector"
entry field and type "navigationButton marked:'Add'" and then click
the "Flash matching elements" link. You will see the "+" button
outline flash.

Note: UISpec is sensitive about spaces and even leaving a space
between the colon and the 'Add' will cause it to crash. No problem,
just restart the Simulator.

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

At this point you could do a little refactoring to make the "Plus" a
parameter


## Write a third step to validate the results

Add a line to the scenario in the tutorial.feature file:

	Then I should see a table containing a timestamp
		
Run cucumber to get the step snippet and add it to the tutorial_steps.rb file

Switch to the browser and in the Selector field, type: "tableView" and
click the "Flash matching elements" link. You will see the whole table
flash

Now try entering "tableView tableViewCell first" (right out of the
UISpec tutorial at
http://code.google.com/p/uispec/wiki/Documentation#UIScript). You will
see the first cell flash

Switch back to your tutorial_steps.rb and put in the following line:

	cell_label = frankly_map( "tableView tableViewCell first", "text" );

This sends the selector to Frank for the first cell and then asks
Frank to return its "text" attribute. In this case we get back the
complete timestamp

You would write more ruby here to validate the timestamp

