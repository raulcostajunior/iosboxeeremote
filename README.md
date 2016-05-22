# iOSBoxeeRemote #

An iOS based remote control application for the [Boxee Box](https://en.wikipedia.org/wiki/Boxee_Box). 

iOSBoxeeRemote implements the Boxee device discovery on a local network and virtual keys that match the keys on the non-keyboard face of the standard Boxee Box physical remote control (shown below).

![Boxee Box and Remote](http://cdn.slashgear.com/wp-content/uploads/2010/01/D-Link_Boxee_box_and_qwerty_remote.jpg)

The application is localized for English and Portuguese (Brazil). 

### Application Screenshots ###

![Initial Screen - No connection set](https://www.dropbox.com/s/6e2o9sfvxvo2rl0/InitialScreen.png?dl=0)

![Boxee found on local network](https://www.dropbox.com/s/bta7uxj8u0vt0fo/BoxeeScanResult.png?dl=0)

![Remote keypad](https://www.dropbox.com/s/6u112777r4loh2m/RemoteKeyPad.png?dl=0)

## Requirements ##

iOSBoxeeRemote supports iOS version 6 or newer (it has been tested successfully on devices running iOS 6.x, 7.x and 9.x). iOSBoxeeRemote is targeted at iPhones and iPods Touch. It runs on iPads, but its UI hasn't been polished for the bigger iPad screens (I really don't see a point in using an iPad as a remote control :))

iOSBoxeeRemote depends on the following CocoaPods:

>  `pod 'Toast', '3.0'`
>  `pod 'SSKeychain', '1.4.0'`
>  `pod 'CocoaAsyncSocket', '7.4.3'`
>  `pod 'KissXML', '5.0.3'`

## Motivation and Status ##

I wrote iOSBoxeeRemote for my own consumption (I own a Boxee since 2011 and its original remote is broken). There are similar apps available on the AppStore, but I really wanted to hack my own and let people have full access to its source once it reached minimum usability status.

The application has reached what I consider to be the minimal usable Boxee remote app status. There are other features that were on my initial original plan that haven't been implemented - such as detecting when the Boxee UI is waiting for a text entry and present the virtual keyboard on the iOS device. 

Unfortunately, my free time for hobby projects is almost zero now. I don't think I'll be able to revisit the project and implement the additional features any time soon. Some of those features are described or hinted at as TODOs comments in the middle of the code.

Please let me know if you extend iOSBoxeeRemote feature set. I'd be glad to merge new features into this codebase.