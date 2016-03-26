//
//  AppDelegate.m
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 1/17/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import "AppDelegate.h"
#import "BoxeeConnectionManager.h"
#import "ViewControllerRouter.h"

@interface AppDelegate () {
    ViewControllerRouter *_appViewControllerRouter;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _appViewControllerRouter = [[ViewControllerRouter alloc] init];
    [BoxeeConnectionManager sharedManager].delegate = _appViewControllerRouter;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = (UIViewController *)[_appViewControllerRouter initialViewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[BoxeeConnectionManager sharedManager] disconnectFromBoxee];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    BoxeeConnection *lastConnection = [BoxeeConnectionManager sharedManager].lastSuccessfulConnection;
    if (lastConnection) {
        // There's a connection that is known to have worked at least once - tries to reestabilish it
        [[BoxeeConnectionManager sharedManager] connectToBoxee:lastConnection];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
