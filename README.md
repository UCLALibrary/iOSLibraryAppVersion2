# Official iOS App for the UCLA Library System

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

