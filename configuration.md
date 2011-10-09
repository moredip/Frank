---
layout: default
title: Configuration
---

## Setting the Simulator Type (iPhone/iPad) and version

This definitely needs some work, but as things are right now
you need to change the ruby in `Frank/features/step_definitions/launch_steps.rb`

Locate the following code: (around line 38)
{% highlight ruby %}
  if( ENV['USE_SIM_LAUNCHER_SERVER'] )
    simulator = SimLauncher::Client.for_iphone_app( app_path )
  else
    simulator = SimLauncher::DirectClient.for_iphone_app( app_path )
  end
{% endhighlight %}

If you want to run the iPad simulator, you'll need to change
`for_iphone_app` to `for_ipad_app`

If you want to run a specific version of the simulator, you'll add
another parameter to the method call with the version as a string.

So to have the tests launch the iPad simulator running v4.2 you would
change the method calls to be:

`.for_ipad_app( app_path, "4.2" )`

[Issue 43](http://github.com/moredip/Frank/issues/43) has been opened to
track making this better.

## Sim-Launcher

[Sim-Launcher](https://rubygems.org/gems/sim_launcher) is a tool that
is used to launch the simulator. The Gem for it was automatically
installed as part of the frank-cucumber install. It is used in the
predefined steps that are installed with `frank-skeleton` in
`Frank/features/step_definitions/launch_steps.rb`

Sim-Launcher has two modes - a *Direct* mode that is used most of the
time where some ruby methods are used and the simulator starts with
your app, and a *Server* mode where it listens for commands to launch
iOS apps via HTTP.

When you are running your tests from the command line you can use the
default, which is Direct mode.


### On your CI server (Hudson, Jenkins, Go, CruiseControl)

For your CI builds you will want to use the Server mode.

Start the Sim-Launcher server to listen for commands by running `sim_launcher`
on the command line. This will launch the server and it will be ready
to receive commands to start the simulator and launch apps.

Specify the environment variable `USE_SIM_LAUNCHER_SERVER`, to tell
the Frank steps to use the Sim-Launcher server to restart your app e.g. `export
USE_SIM_LAUNCHER_SERVER=TRUE`. 

