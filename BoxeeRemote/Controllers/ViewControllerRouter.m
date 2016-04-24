//
//  ViewControllerRouter.m
//  Orchestrates the application view controllers in response to events communicated by the BoxeeConnectionManager.
//
//  Created by Raul Costa Junior on 3/12/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppBaseViewController.h"
#import "BoxeeState.h"
#import "BoxeeConnection.h"
#import "ConnectionSettingsViewController.h"
#import "StandardModeViewController.h"
#import "ViewControllerRouter.h"



@implementation ViewControllerRouter

-(AppBaseViewController *) initialViewController {
    
    ConnectionSettingsViewController *initialVc = [[ConnectionSettingsViewController alloc] init];
    return initialVc;
    
}


#pragma mark - BoxeeConnectionDelegate methods


-(void) connectingToBoxee:(BoxeeConnection *)connectingBoxee {
    
    AppBaseViewController *currentViewController = (AppBaseViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    if ([currentViewController isKindOfClass:[ConnectionSettingsViewController class]]) {
        [((ConnectionSettingsViewController *)currentViewController) connectingToBoxee];
    }
    else {
        NSLog(@"Current view controller should be an instance of 'ConnectionSettingsViewController'. Please check application logic.");
    }
    
}



-(void) connectedToBoxee:(BoxeeConnection *)connectedBoxee withState:(BoxeeState *)connectedBoxeeState {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    StandardModeViewController *standardVC = [[StandardModeViewController alloc] init];
    keyWindow.rootViewController = standardVC;
    
}



-(void) cancelledConnectingToBoxee:(BoxeeConnection *)cancelledConnection {
    
    AppBaseViewController *currentViewController = (AppBaseViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    if ([currentViewController isKindOfClass:[ConnectionSettingsViewController class]]) {
        [((ConnectionSettingsViewController *)currentViewController) cancelledConnectionToBoxee];
    }
    else {
        NSLog(@"Current view controller should be an instance of 'ConnectionSettingsViewController'. Please check application logic.");
    }
    
}




-(void) failedConnectingToBoxee:(BoxeeConnection *)failedConnection withError:(NSError *)error {
    
    AppBaseViewController *currentViewController = (AppBaseViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    if ([currentViewController isKindOfClass:[ConnectionSettingsViewController class]]) {
        [((ConnectionSettingsViewController *)currentViewController) displayFailedToConnectError:error];
    }
    else {
        NSLog(@"Current view controller should be an instance of 'ConnectionSettingsViewController'. Please check application logic.");
    }
    
}



-(void) lostConnectionToBoxee:(BoxeeConnection *)lostConnection {
    
    AppBaseViewController *currentViewController = (AppBaseViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    if (![currentViewController isKindOfClass:[ConnectionSettingsViewController class]]) {
        // The current view is not the ConnectionSettingsView; instantiate one and make it the current view.
        ConnectionSettingsViewController *conSettingsVC = [[ConnectionSettingsViewController alloc] init];
        [[UIApplication sharedApplication] keyWindow].rootViewController = conSettingsVC;
        currentViewController = conSettingsVC;
    }
    [((ConnectionSettingsViewController *)currentViewController) displayLostConnectionError];

}



-(void) connectedBoxeeStateChanged:(BoxeeState *)currentState fromPreviousState:(BoxeeState *)previousState{
    
    // TODO: change the current view depending on whether there's a video or sound being played (media playing view) or there's a text prompt (text entry view).
    
}



-(void) disconnectedFromBoxee:(BoxeeConnection *)disconnectedBoxee {
    
    AppBaseViewController *currentViewController = (AppBaseViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    if (![currentViewController isKindOfClass:[ConnectionSettingsViewController class]]) {
        // The current view is not the ConnectionSettingsView; instantiate one and make it the current view.
        ConnectionSettingsViewController *conSettingsVC = [[ConnectionSettingsViewController alloc] init];
        [[UIApplication sharedApplication] keyWindow].rootViewController = conSettingsVC;
    }
    
}


@end