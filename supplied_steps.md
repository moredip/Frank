---
layout: default
title: Included Steps
---

Frank comes with a set of predefined steps that you can use right away
to start scripting your tests. They are a good way to play around with
Frank and see if it would be a good fit for your team. They are also a
good way to automate *short lived*, tedious tasks in the app, such as
recreating a complex setup before starting some exploratoratory
testing, or documenting the exact steps that need to be taken to
recreate a defect.

If you start to build a large suite of tests using these steps *in
your feature files* approach you will quickly find that they are
trouble to maintain and can be brittle depending on how much your UI
is changing.

There used to be a similar set of steps for testing web applications
in that came along with the default cucumber install but they were
removed because they were deemed to be "harmful" and not teaching
people the right way to use cucumber. Aslak Hellesøy (the original
creator of cucumber) has [written a great
post](http://aslakhellesoy.com/post/11055981222/the-training-wheels-came-off)
on why using steps isn't a great long-term strategy, along with some
suggested improvements (including abstracting out the business logic,
having conversations around the requirements, moving the steps to ruby
where it can be refactored). We're eventually going to have more
details on this (hopefully what I'm writing here is making sense) but
for now it is just [Coming Soon](coming_soon.html).

These steps are all defined in the Frank Gem in
[Frank/gem/lib/frank-cucumber/core_frank_steps.rb](http://github.com/moredip/Frank/blob/master/gem/lib/frank-cucumber/core_frank_steps.rb)
so browse there for the latest and greatest.

**Formatting fail, cleanup in a bit**

6:Then /^I wait to see "([^\"]*)"$/ do |expected_mark|
14:Then /^I wait to not see "([^\"]*)"$/ do |expected_mark|
23:Then /^I wait to see a navigation bar titled "([^\"]*)"$/ do
|expected_mark|
33:Then /^I wait to not see a navigation bar titled "([^\"]*)"$/ do
|expected_mark|
43:Then /^I should see a "([^\"]*)" button$/ do |expected_mark|
47:Then /^I should see "([^\"]*)"$/ do |expected_mark|
51:Then /^I should not see "([^\"]*)"$/ do |expected_mark|
55:Then /I should see the following:/ do |table|
62:Then /I should not see the following:/ do |table|
69:Then /^I should see a navigation bar titled "([^\"]*)"$/ do
|expected_mark|
74:Then /^I should see an alert view titled "([^\"]*)"$/ do
|expected_mark|
80:Then /^I should not see an alert view$/ do
84:Then /^I should see an element of class "([^\"]*)" with name
"([^\"]*)" with the following labels: "([^\"]*)"$/ do |className,
classLabel, listOfLabels|
91:Then /^I should see an element of class "([^\"]*)" with name
"([^\"]*)" with a "([^\"]*)" button$/ do |className, classLabel,
buttonName|
95:Then /^I should not see a hidden button marked "([^\"]*)"$/ do
|expected_mark|
99:Then /^I should see a nonhidden button marked "([^\"]*)"$/ do
|expected_mark|
103:Then /^I should see an element of class "([^\"]*)"$/ do
|className|
107:Then /^I should not see an element of class "([^\"]*)"$/ do
|className|
116:When /^I type "([^\"]*)" into the "([^\"]*)" text field$/ do
|text_to_type, field_name|
123:When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |text_field,
text_to_type|
124:  When %Q|I type "#{text_to_type}" into the "#{text_field}" text
field|
127:When /^I fill in text fields as follows:$/ do |table|
129:    When %Q|I type "#{row['text']}" into the "#{row['field']}"
text field|
134:Given /^the device is in (a )?landscape orientation$/ do |ignored|
148:Given /^the device is in (a )?portrait orientation$/ do |ignored|
162:When /^I simulate a memory warning$/ do
166:Then /^I rotate to the "([^\"]*)"$/ do |direction|
178:When /^I touch "([^\"]*)"$/ do |mark|
188:When /^I touch "([^\"]*)" if exists$/ do |mark|
197:When /^I touch the first table cell$/ do
201:When /^I touch the table cell marked "([^\"]*)"$/ do |mark|
205:When /^I touch the (\d*)(?:st|nd|rd|th)? table cell$/ do |ordinal|
210:Then /I touch the following:/ do |table|
218:When /^I touch the button marked "([^\"]*)"$/ do |mark|
222:When /^I touch the "([^\"]*)" action sheet button$/ do |mark|
226:When /^I touch the (\d*)(?:st|nd|rd|th)? action sheet button$/ do
|ordinal|
231:When /^I touch the (\d*)(?:st|nd|rd|th)? alert view button$/ do
|ordinal|
238:When /^I flip switch "([^\"]*)" on$/ do |mark|
244:When /^I flip switch "([^\"]*)" off$/ do |mark|
250:When /^I flip switch "([^\"]*)"$/ do |mark|
254:Then /^switch "([^\"]*)" should be on$/ do |mark|
263:    Then %Q|I flip switch "#{mark}"|
267:Then /^switch "([^\"]*)" should be off$/ do |mark|
273:    Then %Q|I flip switch "#{mark}"|
282:When /^I wait for ([\d\.]+) second(?:s)?$/ do |num_seconds|
287:Then /^a pop\-over menu is displayed with the following:$/ do
|table|
294:Then /^I navigate back$/ do
298:When /^I dump the DOM$/ do
302:When /^I quit the simulator/ do
