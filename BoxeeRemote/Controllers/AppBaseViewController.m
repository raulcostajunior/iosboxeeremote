//
//  AppBaseViewController.m
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 1/17/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import "AppBaseViewController.h"


// TODO: implement BoxeeConnectionDelegate. Assign itself as the BoxeeConnectionManager delegate on ViewDidLoad and unassign it (if it is the delegate) on dealloc.
//       All the controllers will inherit that delegate behavior from the base and will be able to route to the appropriate controller.

@interface AppBaseViewController ()

@end

@implementation AppBaseViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
