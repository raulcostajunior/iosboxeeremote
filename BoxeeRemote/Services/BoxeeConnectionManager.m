//
//  BoxeeConnectionManager.m
//
//  Created by Raul Costa Junior on 2/21/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BoxeeConnection.h"
#import "BoxeeConnectionManager.h"
#import "BoxeeState.h"


@interface BoxeeConnectionManager () {
    BOOL _connectingToBoxee; // Indicates that the next keep alive response must be handled as a "connection request" to the Boxee.
    BOOL _connectedToBoxee;  // Indicates that there's a boxee connected - actually, it indicates that the last keep alive was successful.
    
    NSTimer *_keepAliveTimer;
}

@property (strong, nonatomic) NSURLSession *urlSession;

@property (strong, nonatomic) BoxeeConnection *currentConnection;

@property (strong, nonatomic) BoxeeState *previousBoxeeState; // Boxee state as collected in the most recent keep alive pulse

@end


@implementation BoxeeConnectionManager

static const NSString *kCmdUrlTemplate = @"http://%@:%ld/xbmcCmds/xbmcHttp?command=%@";

static const NSInteger kIntervalKeepAlive = 10; // Interval between successive keep alive pulses - in seconds.

static const NSString *kBoxeeUsername = @"boxee"; // At least in the boxes I have access to, the user is fixed as "boxee".


#pragma mark - Singleton infrastructure 


+(instancetype) sharedManager {
    static BoxeeConnectionManager *_sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[BoxeeConnectionManager alloc] initInternal];
    });
    
    return nil;
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
    // TODO: get last successful connection from NSUserDefaults
    return nil;
}




-(void) connectToBoxee:(BoxeeConnection *)connectionParams {
    
    self.currentConnection = connectionParams;
    
    if (_keepAliveTimer) {
        [_keepAliveTimer invalidate];
    }
    
    // Sets up the urlSession
    if (self.currentConnection.password.length > 0) {
        // The user defined a password - set up the corresponding HTTP header in the session so it makes into every request
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSString *plainToken = [NSString stringWithFormat:@"%@:%@", kBoxeeUsername, self.currentConnection.password];
        NSData *tokenData = [plainToken dataUsingEncoding:NSUTF8StringEncoding];
        NSData *encodedToken = [tokenData base64EncodedDataWithOptions:0];
        NSString *authHeaderValue = [NSString stringWithFormat:@"Basic %@", encodedToken];
        config.HTTPAdditionalHeaders = @{@"Authorization":authHeaderValue};
        config.timeoutIntervalForRequest = 20; // Lowers the timeout from the 60 seconds default to 20 seconds.
        self.urlSession = [NSURLSession sessionWithConfiguration:config];
    }
    
    // Connecting to the Boxee is actually sending a keep alive pulse
    [self doKeepAlivePulse];
    
}



-(void) disconnectFromBoxee {
    // TODO: invalidate any keep alive pulse and send the appropriate info to the delegate
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


// TODO: add send command methods internal to the service that send getCurrentlyPlaying and getKeyboardStatus commands to the Boxee; those commands do not interfere with the pulse timer - they are actually called as part of the pulse timer.



#pragma mark - Connection keepalive - updates BoxeeState



-(void) doKeepAlivePulse {
    
    // TODO: implement connection keepalive - piggyback on the keepalive response for a BoxeeState refresh.
    
    // TODO: on success, if connecting, indicate a successful connection and update lastSuccessful connection. Otherwise, checks for a state change and triggers the state change event if appropriate
    
    // TODO: on success, connecting or not, schedules the next keepAlive request.
    
    // TODO: on success, schedules the next keep alive pulse
    
    // TODO: on failure, if connecting, indicate a failedToConnect. Otherwise, signals a connection lost.

}


@end
