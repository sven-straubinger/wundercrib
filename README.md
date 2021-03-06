wundercrib
==========

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
The Xcode project contains three main parts (iPhone/iPad/Shared), covering device specific code (e.g. Views) or shared code and objects (e.g. APIController or common View Controller functionality). 

- CoreDataController (Singleton):
The Core Data Controller is seperated from the AppDelegate to extend the functionality and to beware the AppDelegate from bloating.

- NSFetchedResultsController:
The NSFetchedResultsController keeps track of every data change. As soon as the context saves persitent data, the changes are forwarded to the table view.

- APIController (Singleton):
The APIController is responsible for the communication with the server and to synchronize the data stored with the Core Data Framework. It is not fully implemented. One challenge is to handle data arriving from multiple network requests. The APIController can execute this requests and handle (read, parse, store) the responses in background threads (Keyword: Grand Central Dispatch) and in several NSManagedObject Contextes, which can be merged. By using the NSFetchedResultsController, every change in the dataset will be forwarded to the table view.

For serialization, the class "Item" should implement the protocol NSCoding (encodeWithCoder and initWithCoder). This way we can serialize all items and send to the server (for pseudocode see APIController).
