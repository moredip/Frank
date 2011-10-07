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
your feature files* you will quickly find that they are trouble to
maintain and can be brittle depending on how much your UI is changing.

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

**Note: The initial adverb doesn't matter, you can use Given, When and Then
  interchangeably **

## Performing Actions
{% highlight gherkin %}When I type "([^\"]*)" into the "([^\"]*)" text field
When I fill in "([^\"]*)" with "([^\"]*)"
When %Q|I type "#{text_to_type}" into the "#{text_field}"
When I fill in text fields as follows:
When I type "#{row['text']}" into the "#{row['field']}"
Given the device is in (a )?landscape orientation
Given the device is in (a )?portrait orientation
When I simulate a memory warning
Then I rotate to the "([^\"]*)" - left right
When I touch "([^\"]*)" 
When I touch "([^\"]*)" if exists
When I touch the first table cell
When I touch the table cell marked "([^\"]*)"
When I touch the (\d*)(?:st|nd|rd|th)? table cell
Then I touch the following:
When I touch the button marked "([^\"]*)"
When I touch the "([^\"]*)" action sheet button
When I touch the (\d*)(?:st|nd|rd|th)? action sheet button
When I touch the (\d*)(?:st|nd|rd|th)? alert view button
When I flip switch "([^\"]*)" on
When I flip switch "([^\"]*)" off
When I flip switch "([^\"]*)"
Then switch "([^\"]*)" should be on
Then %Q|I flip switch "#{mark}"
Then switch "([^\"]*)" should be off 
Then %Q|I flip switch "#{mark}"|
Then I navigate back
When I quit the simulator
{% endhighlight %}

## Verifying What is on the view
{% highlight gherkin %}

Then I wait to see "([^\"]*)"
Then I wait to not see "([^\"]*)"
Then I wait to see a navigation bar titled "([^\"]*)"
Then I wait to not see a navigation bar titled "([^\"]*)"
Then I should see a "([^\"]*)" button
Then I should see "([^\"]*)"
Then I should not see "([^\"]*)"
Then I should see the following:
Then I should not see the following:
Then I should see a navigation bar titled "([^\"]*)"
Then I should see an alert view titled "([^\"]*)"
Then I should not see an alert view
Then I should see an element of class "([^\"]*)" with name "([^\"]*)" with the following labels: "([^\"]*)"
Then I should see an element of class "([^\"]*)" with name "([^\"]*)" with a "([^\"]*)" button
Then I should not see a hidden button marked "([^\"]*)"
Then I should see a nonhidden button marked "([^\"]*)"
Then I should see an element of class "([^\"]*)"
Then I should not see an element of class "([^\"]*)"
Then a pop\-over menu is displayed with the following:
{% endhighlight %}

## Debug or Miscellaneous
{% highlight gherkin %}

When I wait for ([\d\.]+) second(?:s)
When I dump the DOM
{% endhighlight %}

