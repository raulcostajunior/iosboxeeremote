//
//  ViewControllerRouter.h
//  Orchestrates the application view controllers in response to events communicated by the BoxeeConnectionManager.
//
//  Created by Raul Costa Junior on 3/12/16.
//

#ifndef ViewControllerRouter_h
#define ViewControllerRouter_h

#import "BoxeeConnectionDelegate.h"

@class AppBaseViewController;


@interface ViewControllerRouter: NSObject<BoxeeConnectionDelegate>

-(AppBaseViewController *) initialViewController;

@end


#endif /* ViewControllerRouter_h */
