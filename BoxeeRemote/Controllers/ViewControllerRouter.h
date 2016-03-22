//
//  ViewControllerRouter.h
//  Orchestrates the application view controllers in response to events communicated by the BoxeeConnectionManager.
//
//  Created by Raul Costa Junior on 3/12/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#ifndef ViewControllerRouter_h
#define ViewControllerRouter_h

#import "BoxeeConnectionDelegate.h"

@interface ViewControllerRouter: NSObject<BoxeeConnectionDelegate>

-(UIViewController *) initialViewController;

@end

#endif /* ViewControllerRouter_h */
