# Step 1
Cut a hole in a box.

# Step 2
Woah! Just kidding!

# Step 1, for realz
Add a 'MyApp - Frankified' target to your app by **duplicating your main target**

# Step 2
In Xcode add a Frank group to your project. Within the frank group add the frank src directory, the frank lib directory, and the frank_static_resources.bundle directory. These only need to be added to your new 'Frankified' target

# Step 3
Add CFNetwork framework

# Step 4
Create a custom version of main.m for your Frankified target. Do this by:
* copy the main.m.sample file from the Frank distribution into your application source tree somewhere, renaming it to main.m (or some other name with a .m file extension)
* In Xcode add that file to just the Frankified target
* finding the original standard main.m for your app, and make sure it *is not* being included in your Frankified target

# Step 5
Build that sucka, fire it up in the simulator, and then point your browser at http://localhost:37265 and check you have the Frank symbiote at your command. Trying clicking 'Dump current DOM' to check that Frank is alive and kicking.
