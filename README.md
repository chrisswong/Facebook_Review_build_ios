# Facebook_Review_build_ios
A ruby script to ease the process of building Facebook review builds

1. Build with workspace or project file
2. Select project and target 
4. default select the highest available iOS simulator version
3. build with xcodebuild 
4. zip it at the directory of the script runs
5. optional : use (git describe) to get the last tag and append it with -facebook
6. optional : xcpretty to beautify the build output
7. optional : run with ios-sim to see if the build can run and install into iOS simulator