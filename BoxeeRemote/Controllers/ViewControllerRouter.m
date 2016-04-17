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
#import "ViewControllerRouter.h"



@implementation ViewControllerRouter

-(AppBaseViewController *) initialViewController {
    
    ConnectionSettingsViewController *initialVc = [[ConnectionSettingsViewController alloc] init];
    return initialVc;
    
}


#pragma mark - BoxeeConnectionDelegate methods


-(void) connectingToBoxee:(BoxeeConnection *)connectingBoxee {
    
    
}



-(void) connectedToBoxee:(BoxeeConnection *)connectedBoxee withState:(BoxeeState *)connectedBoxeeState {
    
    
}



-(void) cancelledConnectingToBoxee:(BoxeeConnection *)cancelledConnection {
    
    
}




-(void) failedConnectingToBoxee:(BoxeeConnection *)failedConnection withError:(NSError *)error {
    
    
}



-(void) lostConnectionToBoxee:(BoxeeConnection *)lostConnection {
    
    
}



-(void) connectedBoxeeStateChanged:(BoxeeState *)currentState fromPreviousState:(BoxeeState *)previousState{
    
    
}



-(void) disconnectedFromBoxee:(BoxeeConnection *)disconnectedBoxee {
    
    
}


@end