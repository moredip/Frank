About
-----

Frank is an iPhone/iPad UI testing tool. It combines UISpec with an embedded HTTP server. This means it can be driven externally by cucumber for example. 

Architecture
----
![Frank Architecture Overview](https://github.com/skizz/frank/raw/master/doc/Frank%20Architecture.png)

Usage
-----

At this point all you need to do to add Frank to an iPhad app is:

 * create a Frankified target by duplicating your normal target
 * add the Frank.a static library to that Frankified target
 * add a -ObjC flag to the linker settings (Other Linker Flags) for the Frankified target (see http://developer.apple.com/mac/library/qa/qa2006/qa1490.html for details)
 * add a dependency on apple's CFNetwork Framework
 * add the the static frank bundle to the project somewhere. Frank uses these files to provide the interactive Symbiote web app while your iPhone app is running
 * add a custom main.m file (a sample of which is included in the Frank repo) which boots the Frank server during iPhone app startup.
