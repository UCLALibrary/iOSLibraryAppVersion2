# UCLA Library (iOS)
What is it?
-----------
The iOS application enables users to have access 
to essential information about the libraries across
the UCLA campus. Users are able to access this information
by selecting a Library on the homescreen of the app in a list, 
where each row links to a new view containing information about a specific library.

Importing the source code into your local system
------------------------------------------------
1.	You need a mac and the latest XCode in order to begin development
2.	Click the “Clone or Download” button in the github repository
3.	Copy the link (should look something like https://github.com/UCLALibrary/iOSLibraryAppVersion2.git)
4.	Open Terminal
5.	cd into the folder in which you desire to save the project
6.	git clone [the link you copied from the “Clone or Download” button]
7.	cd into the newly created Git repository
8.	git init (to initialize the Git repository)
9.	Run XCode
10.	Click File > Open > "UCLA Library.xcworkspace"
11.	On the Terminal, change directory (cd) into the directory that contains "UCLA Library.xcworkspace"
12. Download cocoapods with 'sudo gem install cocoapods'
13. cd into the project in terminal, then type 'pod install'
14. Type in 'pod update' to update the frameworks
15. Open the .xcworkspace file in XCode
16. Build and Run!

Getting started on working
--------------------------
1.	Open Terminal
2.	cd into the Git repository in which you saved the project
3.	git checkout –b [newBranchName]
4.	git branch (ensure that you are on newBranchName
5.	Open the project in XCode

Team
----------------
* Casey Grzecka: cgrzecka@library.ucla.edu 
* Lewis Hong: smlewishong@gmail.com
* Michael Jung: michaeljung1996@gmail.com
* Nathan Tsai: nwtsai@gmail.com
* Patrick Shih:  patrickkshih@gmail.com
* Regan Hsu: hsuregan@ucla.edu


Other Info
--------------------------
### AppDelegate.swift
Created automatically when project is made.  
Usually you have to update things here when you're interacting with third party services.

### ContactButtons.swift
Class for the phone and email buttons on every screen

### CreditsController.swift
The credits view controller (shows where the icons are from atm).

### DetailViewController.swift
The controller of the library info.  Should show number of laptops, hours during the week.  Location.  Etc

### dayOfWeekAndHoursBox.swift
The view for the hours box in the library info.

### globals.swift
Global constants

### Library.swift
The data structure for a Library. i.e Powell, YRL, etc

### LibraryListTableViewController.swift
The controller of the list of libraries.  Controls the view that appears upon launching the app.

### KDCircularProgress.swift
The view for the progress circle in the library view.

### Main.storyboard
A lot of layout is done here.  All settings added to make the app responsive is here.

### MenuController.swift
The controller for the menu view showing 'Ask A Librarian' 'My Account' etc.

### MenuButtons.swift
The class for the buttons associated with the Menu (represented by magnifying glass in upper right hand corner).

### Main.storyboard
The Storyboard.  A lot of ux and ui is done here so it is worth looking at.  Ifsome feature on the App doesn't make sense (visually) it is probably because that feature was added thru the storyboard.  The storyboard allows me to add constraints that make the app responsive.

### UCLA Library-Bridging-Header.h
Needed because google's API was originally built for Obj-C.

### info.plist
A lot of security settings that need to be changed when app is released into the store.  For instance, it will allow communication between google.com and anumat.com.

### Set Up
1. Download cocoapods with 'sudo gem install cocoapods'
2. cd into the project in terminal, then type pod install
3. Type in 'pod update' to update the frameworks
4. Open the .xcworkspace file in XCode
5. Build and Run!
6. If you have compiler errors are they are contained within the Alamofire framework, do the following:
- Open the Podfile and comment out the pod 'Alamofire', '4.x' line
- Run pod update to remove the old Alamofire framework
- Go to XCode and clean the project (cmd + shift + k)
- Uncomment the Alamofire fire line in the Podfile
- In XCode, go to Preferences -> Location -> and press the little arrow under Derived Data
- This will open a directory showing the folder. Delete the Derived Data folder
- Clean the project once more and run!