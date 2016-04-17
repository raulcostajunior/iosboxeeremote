//
//  LastSuccessfulConnectionStore.m
//
//  Created by Raul Costa Junior on 4/13/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BoxeeConnection.h"
#import "LastSuccessfulConnectionStore.h"
#import "SSKeychain.h"

@implementation LastSuccessfulConnectionStore

static NSString *const kHostKey = @"BoxeeHost";
static NSString *const kPortKey = @"BoxeePort";
static NSString *const kKeychainService = @"BoxeeRemoteiOS";
static NSString *const kKeychainAccount = @"br.com.dstreams.boxeeRemote";


-(BoxeeConnection *)loadLastSuccessfulConnection {
    
    BOOL hasLastSuccessfuConnection = NO;
    NSString *hostName;
    NSInteger port;
    NSString *password;
    
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    if ([userPrefs valueForKey:kHostKey] != nil) {
        hasLastSuccessfuConnection = YES;
        hostName = [userPrefs objectForKey:kHostKey];
    }
    
    if (!hasLastSuccessfuConnection) {
        return nil;
    }
    
    if ([userPrefs valueForKey:kPortKey] != nil) {
        port = [[userPrefs objectForKey:kPortKey] integerValue];
    }
    else {
        port = [BoxeeConnection boxeeDefaultPort];
    }
    
    password = [SSKeychain passwordForService:kKeychainService account:kKeychainAccount];
    
    BoxeeConnection *con = [[BoxeeConnection alloc] init];
    con.hostname = hostName;
    con.port = port;
    con.password = password;
    
    return con;
}



-(void) saveLastSuccessfulConnection:(BoxeeConnection *) lastSuccessfulConnection {
    
    NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
    [userPrefs setObject:lastSuccessfulConnection.hostname forKey:kHostKey];
    [userPrefs setObject:[NSNumber numberWithInteger:lastSuccessfulConnection.port] forKey:kPortKey];
    [userPrefs synchronize];
    
    [SSKeychain setPassword:lastSuccessfulConnection.password forService:kKeychainService account:kKeychainAccount];
}

@end

