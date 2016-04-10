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
    BOOL _connectedToBoxee;  // Indicates that there's currently a boxee connected - actually, it indicates that the last keep alive was successful.
}

@property (strong, nonatomic) NSURLSession *urlSession;

@property (strong, nonatomic) BoxeeConnection *currentConnection;

@property (strong, nonatomic) BoxeeState *previousBoxeeState; // Boxee state as collected in the most recent keep alive pulse

@end


@implementation BoxeeConnectionManager

static const NSString *kCmdUrlTemplate = @"http://%@:%ld/xbmcCmds/xbmcHttp?command=%@";


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
    
    // Connecting to the Boxee is actually sending a keep alive pulse
    // TODO: invalidate any pending keep alive pulse
    // TODO: setup the urlSession
    [self doKeepAlivePulse];
    
}



-(void) disconnectFromBoxee {
    // TODO: invalidate any keep alive pulse and send the appropriate info to the delegate
}



#pragma mark - Send Command methods


-(void) sendKeyToBoxee:(BoxeeKeyCode)keyCode {
    
    // TODO: dispatches a send key command to the current boxee, if there's one connected. Any error in the command response should be interpreted as a connection loss.
    
}


// TODO: add send command methods internal to the service that send getCurrentlyPlaying and getKeyboardStatus commands to the Boxee.



#pragma mark - Connection keepalive - updates BoxeeState



-(void) doKeepAlivePulse {
    
    // TODO: implement connection keepalive - piggyback on the keepalive response for a BoxeeState refresh.
    
    // TODO: on success, if connecting, indicate a successful connection and update lastSuccessful connection. Otherwise, checks for a state change and triggers the state change event if appropriate
    
    // TODO: on success, connecting or not, schedules the next keepAlive request.
    
    // TODO: on failure, if connecting, indicate a failedToConnect. Otherwise, signals a connection lost.

}


@end
