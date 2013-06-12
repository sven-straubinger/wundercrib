wundercrib
==========

This iOS application is the response to the Wundertest by 6Wunderkinder. 

Features:
- Universal App
- Plain and simple single-page app wrapped in an UINavigationController
- Core Data manages the user input and server data
- NSFetchedResultsController keeps track of data changes
- Create and rearrange new tasks/items in a table view
- Swipe items off the screen to delete it from Core Data
- Smooth Splashscreen Animation
- ARC for eased Memory Management

Notes:
The Xcode project contains three main parts (iPhone/iPad/Shared), containing device specific (e.g. Views) or shared (e.g. APIController or common View Controller functionality) code and objects. 
The Core Data Controller is seperated from the AppDelegate to extend the functionality and to beware the AppDelegate from bloating.
