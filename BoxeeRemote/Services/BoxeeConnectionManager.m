//
//  BoxeeConnectionManager.m
//
//  Created by Raul Costa Junior on 2/21/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BoxeeConnection.h"
#import "BoxeeConnectionDelegate.h"
#import "BoxeeConnectionManager.h"
#import "BoxeeState.h"
#import "LastSuccessfulConnectionStore.h"


@interface BoxeeConnectionManager () {
    BOOL _connectingToBoxee; // Indicates that the next keep alive response must be handled as a "connection request" to the Boxee.
    BOOL _connectedToBoxee;  // Indicates that there's a boxee connected - actually, it indicates that the last keep alive was successful.
    
    NSTimer *_updateStateTimer;
}

@property (strong, nonatomic) BoxeeConnection *currentConnection;

@property (strong, nonatomic) BoxeeState *previousBoxeeState; // Boxee state as collected in the most recent update state pulse

@end


@implementation BoxeeConnectionManager

static NSString *const kCmdUrlTemplate = @"http://%@:%ld/xbmcCmds/xbmcHttp?command=%@";

static const NSInteger kIntervalUpdateState = 10; // Interval between successive update state pulses - in seconds.

static  NSString *const kBoxeeUsername = @"boxee"; // At least in the boxes I have access to, the user is fixed as "boxee".


#pragma mark - Singleton infrastructure 


+(instancetype) sharedManager {
    static BoxeeConnectionManager *_sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BoxeeConnectionManager alloc] initInternal];
    });
    
    return _sharedInstance;
}


-(instancetype) initInternal {
    
    self = [super init];
    
    if (self) {
        _connectedToBoxee = NO;
        _connectingToBoxee = NO;
    }
    
    return self;
    
}


-(instancetype) init {
    
    [NSException raise:@"This is a singleton" format:@"Use sharedManager method to access the singleton instance"];
    
    return nil;
}



#pragma mark - Public connection control methods


-(BoxeeConnection *) lastSuccessfulConnection {
    LastSuccessfulConnectionStore *store = [[LastSuccessfulConnectionStore alloc] init];
    return [store loadLastSuccessfulConnection];
}




-(void) connectToBoxee:(BoxeeConnection *)connectionParams {
    
    self.currentConnection = connectionParams;
    
    if (_updateStateTimer) {
        [_updateStateTimer invalidate];
    }
    
    _connectedToBoxee = NO;
    _connectingToBoxee = YES;
    
    if (self.delegate) {
        [self.delegate connectingToBoxee:self.currentConnection];
    }
    
    // Connecting to the Boxee is actually requesting a state update
    [self updateBoxeeState];
    
}



-(void) disconnectFromBoxee {
    if (_updateStateTimer) {
        [_updateStateTimer invalidate];
    }
    
    _connectedToBoxee = NO;
    _connectingToBoxee = NO;
    
    if (self.delegate) {
        [self.delegate disconnectedFromBoxee:self.currentConnection];
    }
}



#pragma mark - Send Command methods


-(void) sendKeyToBoxee:(BoxeeKeyCode)keyCode {
    
    // TODO: invalidate pulse timer - a pulse will be requested right after successful command execution.
    
    // TODO: dispatches a send key command to the current boxee, if there's one connected. Any error in the command response should be interpreted as a connection loss.
    
}


-(void) sendToggleMuteToBoxee {
    
    // TODO: invalidate pulse timer - a pulse will be requested right after successful command execution.
    
    // TODO: dispatches a mute command to the current boxee, if there's one connected. Any error in the command response should be interpreted as a connection loss.
    
}



#pragma mark - Connection "keepalive" - updates BoxeeState



-(void) updateBoxeeState {
    
    NSString *urlAsString = [NSString stringWithFormat:kCmdUrlTemplate, self.currentConnection.hostname, (long)self.currentConnection.port, @"getcurrentlyplaying()"];
    
    NSURL *updateStateUrl = [[NSURL alloc] initWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:updateStateUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    
    if (self.currentConnection.password.length > 0) {
        request = [self addAuthenticationHeaderToRequest:request withUser:kBoxeeUsername andPassword:self.currentConnection.password];
    }
    

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        if (!connectionError) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"Http status code for response: %ld", (long)httpResponse.statusCode);
            NSLog(@"Http response body:");
            NSLog(@"%@", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
            
            if (httpResponse.statusCode == 200) {
                [[[LastSuccessfulConnectionStore alloc] init] saveLastSuccessfulConnection:self.currentConnection];
                if (self.delegate) {
                // TODO: retrieve boxee state from response
                [self.delegate connectedToBoxee:self.currentConnection withState:nil];
                }
            }
        }
        else {
            NSLog(@"updateBoxeeState completed with error %@", connectionError.description);
        }
        
        // TODO: on success, if connecting, indicate a successful connection and update lastSuccessful connection. Otherwise, checks for a state change and triggers the state change event if appropriate
        
        // TODO: on success, connecting or not, schedules the next keepAlive request.
        
        // TODO: on success, schedules the next keep alive pulse
        
        // TODO: on failure, if connecting, indicate a failedToConnect. Otherwise, signals a connection lost.
    }];
    
}


#pragma mark - Internal utility methods


-(NSURLRequest *)addAuthenticationHeaderToRequest:(NSURLRequest *)request withUser:(NSString*)user andPassword:(NSString *)password {
    
    NSMutableURLRequest *mutRequest = [request mutableCopy];
    
    NSString *plainToken = [NSString stringWithFormat:@"%@:%@", user, password];
    NSData *tokenData = [plainToken dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encodedToken = [tokenData base64EncodedDataWithOptions:0];
    NSString *authHeaderValue = [NSString stringWithFormat:@"Basic %@", encodedToken];
    
    if ([mutRequest valueForHTTPHeaderField:@"Authorization"] != nil) {
        [mutRequest setValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    }
    else {
        [mutRequest addValue:authHeaderValue forHTTPHeaderField:@"Authorization"];
    }
    
    return mutRequest;
    
}




@end
