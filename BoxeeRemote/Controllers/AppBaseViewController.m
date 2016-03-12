//
//  AppBaseViewController.m
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 1/17/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import "AppBaseViewController.h"
#import "BoxeeConnectionDelegate.h"
#import "BoxeeConnectionManager.h"
#import "ViewControllerRouter.h"


@interface AppBaseViewController () <BoxeeConnectionDelegate>

@end


@implementation AppBaseViewController

#pragma mark - View lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    [BoxeeConnectionManager sharedManager].delegate = self;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



#pragma mark - BoxeeConnectionDelegate methods


-(void) connectingToBoxee:(BoxeeConnection *)connectingBoxee {
    
    
}


-(void) connectedToBoxee:(BoxeeConnection *)connectedBoxee {
    
    
}


-(void) failedConnectingToBoxee:(BoxeeConnection *)failedConnection withError:(NSError *)error {
    
    
}



-(void) lostConnectionToBoxee:(BoxeeConnection *)lostConnection {
    
    
}


-(void) connectedBoxeeStateChanged:(BoxeeState *)newState {
    
    
}


@end
