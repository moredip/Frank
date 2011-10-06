---
layout: default
title: Step Definitions
---

## What's this?
This page is intended to act as a place for useful Frank step
definitions which aren't quite standard enough to add to the core
frank steps. Please feel free to contribute your own useful codez.

## Counting specific items displayed on the App
This works for Waseem:

{% highlight ruby %}
Then /^I should see (.*) apples$/ do |count|
  apples = frankly_map( "label marked:'red apples'", 'tag' )
  apples.count.should == count.to_i
end
{% endhighlight %}

## Editing a text field using the keyboard
(see [this
thread](http://groups.google.com/group/frank-discuss/browse_frm/thread/49fcf81971d7dd42)
for details)

This works for Pete's team:

{% highlight ruby %}
    When /^I use the keyboard to fill in the textfield marked
    "([^\\"]*)" with "([^\\"]*)"$/ do |text_field_mark, text_to_type|
      text_field_selector =  "view marked:'#{text_field_mark}'"
      check_element_exists( text_field_selector )
      touch( text_field_selector )
      frankly_map( text_field_selector, 'setText:', text_to_type )
      frankly_map( text_field_selector, 'endEditing:', true )
    end
{% endhighlight %}

This works for Martin:

{% highlight ruby %}
    When /^I use the keyboard to fill in the textfield marked
    "([^\\"]*)" with "([^\\"]*)"$/ do |text_field_mark, text_to_type| 
     text_field_selector =  "view marked:'#{text_field_mark}'" 
     check_element_exists( text_field_selector ) 
     frankly_map( text_field_selector, 'becomeFirstResponder' ) 
     frankly_map( text_field_selector, 'setText:', text_to_type ) 
     frankly_map( text_field_selector, 'endEditing:', true ) 
    end 
{% endhighlight %}


## Simulating sending text and hitting return on the keyboard
This can be a useful workaround when dealing with the iOS
    keyboard. Thanks to [Hezi
    Cohen](http://groups.google.com/group/frank-discuss/msg/55f46cb1934584be)
    and James Moore for this one!

{% highlight ruby %}
def send_command ( command )
  %x{osascript<<APPLESCRIPT
tell application "System Events"
  tell application "iPhone Simulator" to activate
  keystroke "#{command}"
  delay 1
  key code 36
end tell
APPLESCRIPT}
end

When /^I send the command "([^\\"]*)"$/ do |cmd|
  send_command(cmd)
end

When /^I send the command "([^"]*)" (\d+) times$/ do |cmd, times|
  i = 0
  while i < times.to_i
    send_command(cmd)
    i += 1
  end
end

When /^I send the following commands:$/ do |table|
  table.hashes.each do |row|
    steps "When I send the command \\"#{row['command']}\\"
  #{row['times']} times"
    send_command(row['command'])
  end
end
{% endhighlight %}




## Resetting the app to first launch state

{% highlight ruby %}
Given /^I reset the (iphone|ipad) app$/ do |device|
  steps "When I quit the simulator"
  SDK    = "4.3"
  APPLICATIONS_DIR = "/Users/#{ENV['USER']}/Library/Application
  Support/iPhone Simulator/#{SDK}/Applications"
  USERDEFAULTS_PLIST =
  "Library/Preferences/com.yourcompany.#{APPNAME}.dist.plist"
  Dir.foreach(APPLICATIONS_DIR) do |item|
    next if item == '.' or item == '..'
    if File::exists?(
    "#{APPLICATIONS_DIR}/#{item}/#{USERDEFAULTS_PLIST}")
      FileUtils.rm "#{APPLICATIONS_DIR}/#{item}/#{USERDEFAULTS_PLIST}" 
    end
  end
  steps "Given I launch the #{device} app"
end
{% endhighlight %}

## Taking a screenshot of the app

{% highlight ruby %}
Then /^I save a screenshot with prefix (\w+)$/ do |prefix|
 filename = prefix + Time.now.to_i.to_s
 %x[screencapture #{filename}.png]
end
{% endhighlight %}


## Deleting a table view cell
(see [this
thread](http://groups.google.com/group/frank-discuss/browse_frm/thread/6e136a836ac4fd07)
for details)

{% highlight ruby %}
When /^I delete the table view cell marked "([^"]*)"$/ do |mark|
  raise "no table view cell marked '#{mark}' could be found to delete"
  unless element_exists("tableViewCell label marked:'#{mark}'")
  frankly_map( "tableViewCell label marked:'#{mark}' parent
  tableViewCell delete", "tag" ) 
end
{% endhighlight %}

## Selecting from a UIPickerView
From
http://groups.google.com/group/frank-discuss/browse_thread/thread/419a5f08d7ebb422

{% highlight ruby %}
When /^I select (\d*)(?:st|nd|rd|th)? row in picker "([^\"]*)"$/ do | 
row_ordinal, theview| 
  selector = "view:'UIPickerView' marked:'#{theview}'" 
  row_index = row_ordinal.to_i - 1
  views_switched = frankly_map( selector,
  'selectRow:inComponent:animated:', row_index, 0, false ) 
  raise "could not find anything matching [#{row_ordinal}] to switch"
  if views_switched.empty? 
end 
{% endhighlight %}

## Recording Video of your cucumber run

Put this into somewhere where it will be loaded by cucumber (e.g
create a file like `Frank/features/support/recording.rb`), then you can
use @record tag to record a specific scenario.

{% highlight ruby %}
Around( '@record' ) do | scenario, block |
  start_recording
  block.call
  stop_recording
end
{% endhighlight %}


Add this to the top of `Frank/features/support/env.rb` to record
everything in the whole cucumber run:

{% highlight ruby %}
include Frank::Cucumber::FrankHelper
start_recording
at_exit do
  stop_recording
end
{% endhighlight %}

We record the screen with a terminal showing the cucumber steps right
beside the open simulator.

Two more tools you will probably want to use if you're recording your
whole test suite run:

 * [Timestamped
   Scenarios](http://github.com/moredip/timestamped-scenarios) - show
   the timestamp in the cucumber output of when a scenario ran
   starting with the start of the test run. So if a scenario fails at
   9:02 into your test run, then you know where to start watching the video.
 * [Slow Hand Cuke](http://github.com/moredip/SlowHandCuke) - a
   cucumber formatter to display the currently running step (by
   default cucumber displays steps after they have run, so you don't
   see the currently running step)
