MultiPhotoScreen
================

This project was developed as part of the iOS App: [My Things - Where Are They?] [link]  
Provides a clean interface to capture multiple photos (up to 8) from user. Allows Add / Delete / Rearrange (Drag & Drop) Photos.
[link]: http://itunes.apple.com/us/app/my-things-where-are-they/id529353551?ls=1&mt=8

##Screenshot

[Screenshot] [ss]
[ss]: https://github.com/dhanushram/MultiPhotoScreen/blob/master/Screenshots/screenshot.png

##Instruction
1) You could use this screen in your app by assigning a Delegate object that conforms to MultiPhotoDelegate Protocol.  
2) Provide your own mechanism  (like adding "Done" UIBarButton) to pop the multiphoto screen  
3) Before popping, call the method 'returnFinalPicArray' which would return an NSArray of UIImage of the photos through the Delegate



##License
Copyright (c) 2012 Dhanush Balachandran  
Licensed under the MIT license.

