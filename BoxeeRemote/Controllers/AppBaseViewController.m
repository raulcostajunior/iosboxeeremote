//
//  AppBaseViewController.m
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 1/17/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import "AppBaseViewController.h"
#import "ViewControllerRouter.h"


@interface AppBaseViewController ()

@end


@implementation AppBaseViewController

#pragma mark - View lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}






@end
