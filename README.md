# iOSBoxeeRemote #

An iOS based remote control application for the [Boxee Box](https://en.wikipedia.org/wiki/Boxee_Box). 

iOSBoxeeRemote implements the Boxee device discovery on a local network and virtual keys that match the keys on the non-keyboard face of the standard Boxee Box physical remote control (shown below).

![Boxee Box and Remote](http://cdn.slashgear.com/wp-content/uploads/2010/01/D-Link_Boxee_box_and_qwerty_remote.jpg)

The application is localized for English and Portuguese (Brazil). 

### Application Screenshots ###

![Initial Screen - No connection set](https://dl.dropboxusercontent.com/u/3752865/iOSBoxeeRemote/InitialScreen.png)
> Initial screen with no connection parameter set.  
  

![Boxee found on local network](https://dl.dropboxusercontent.com/u/3752865/iOSBoxeeRemote/BoxeeScanResult.png)
> Boxee found after a local network search.   
  

![Remote keypad](https://dl.dropboxusercontent.com/u/3752865/iOSBoxeeRemote/RemoteKeyPad.png)
>The Boxee remote keypad (displayed once connected to a Boxee and while the connection is "healthy").  

## Requirements ##

iOSBoxeeRemote supports iOS version 6 or newer (it has been tested successfully on devices running iOS 6.x, 7.x and 9.x). iOSBoxeeRemote is targeted at iPhones and iPods Touch. It runs on iPads, but its UI hasn't been polished for the bigger iPad screens.

iOSBoxeeRemote depends on the following CocoaPods:

>  `pod 'Toast', '3.0'`
>  `pod 'SSKeychain', '1.4.0'`
>  `pod 'CocoaAsyncSocket', '7.4.3'`
>  `pod 'KissXML', '5.0.3'`

## Motivation and Status ##

I wrote iOSBoxeeRemote for my own use (I have a Boxee Box since 2011 and its original remote is broken). There are similar apps available on the AppStore, but I was really curious about their internal workings and decided to write one and make its source code public.

The application has reached the state of what I consider to be a minimally usable Boxee remote app. There are other features that were on the  initial plan that haven't yet been implemented - such as detecting when the Boxee UI is waiting for a text entry and present the virtual keyboard on the iOS device or detecting when the Boxee starts playing media and present the appropriate controls in the remote control UI.

As of October, 2016, the application is being published in the AppStore. 

If iOSBoxeeRemote turns out to generate a certain level of interest around it, I intend to continue its development and complete its initially planned feature set.








