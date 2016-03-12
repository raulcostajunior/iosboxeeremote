//
//  ViewControllerRouter.h
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 3/12/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#ifndef ViewControllerRouter_h
#define ViewControllerRouter_h

@class BoxeeState;

typedef NS_ENUM(NSInteger, BoxeeConnectionEvent) {
    
    ConnectionEventConnecting,
    ConnectionEventConnected,
    ConnectionEventConnectFailed,
    ConnectionEventLostConnection,
    ConnectionEventStateChanged
};


@interface ViewControllerRouter: NSObject

+(void) routeToViewControllerForEvent:(BoxeeConnectionEvent)event andState:(BoxeeState *)state;

@end

#endif /* ViewControllerRouter_h */
