# iOSBoxeeRemote #

An iOS based remote control application for the [Boxee Box](https://en.wikipedia.org/wiki/Boxee_Box). 

iOSBoxeeRemote implements the Boxee device discovery on a local network and virtual keys that match the keys on the non-keyboard face of the standard Boxee Box physical remote control (shown below).

The application is localized for English and Portuguese (Brazil). 

## UPDATE (jun/2019) ##

Work on a new version of iOSBoxeeRemote has been interrupted (and won't be resumed) due to the reasons described below.

As of June, 2019, some Boxee servers that were in charge of managing and authenticating Boxee accounts are no longer available. Boxee Boxes can no longer authenticate users and report they have no Internet Connection even when they are connected to a network that has access to the Internet. Further details about the issue can be seen 
[here](https://www.reddit.com/r/boxee/comments/bzb2wn/boxee_can_not_connect_to_the_internet_nor_wifi_or/). 

My Boxee Box is currently unusable and, infering from what has been written on the discussion above, mine is not an exception. As all candidate fixes are too hacky for most users (including myself), I decided to let my beloved Boxee Box go and stop investing time and energy on both the [boxee-simulator](https://github.com/raulcostajunior/boxee-simulator) and a new version of [iOSBoxeeRemote](https://github.com/raulcostajunior/iosboxeeremote) that I had already started and would finish after concluding the first version of the simulator. 

R.I.P Boxee Box :(

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








