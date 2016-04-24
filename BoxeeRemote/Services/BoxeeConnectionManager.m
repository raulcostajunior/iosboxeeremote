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


@interface BoxeeConnectionManager () <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    BOOL _connectingToBoxee;   // Indicates that the next keep alive response must be handled as a "connection request" to the Boxee.
    BOOL _connectedToBoxee;    // Indicates that there's a boxee connected - actually, it indicates that the last keep alive was successful.
    
    NSURLConnection *_updateStateConnection;
    
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
    [self updateBoxeeState:nil];
    
}



-(void) cancelConnection {
    
    [_updateStateConnection cancel];
    
    if (self.delegate) {
        [self.delegate cancelledConnectingToBoxee:self.currentConnection];
    }
    
    self.currentConnection = nil;
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
    
    self.currentConnection = nil;
}



#pragma mark - Send Command methods


-(void) sendKeyToBoxee:(BoxeeKeyCode)keyCode {
    
    if (_updateStateTimer) {
        [_updateStateTimer invalidate];
    }
    
    NSString *keyCmd = [NSString stringWithFormat:@"SendKey(%ld)", (long)keyCode];
    NSString *urlAsString = [NSString stringWithFormat:kCmdUrlTemplate, self.currentConnection.hostname, (long)self.currentConnection.port, keyCmd];
    NSURL *sendKeyUrl = [NSURL URLWithString:urlAsString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:sendKeyUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:4];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // Response is intentionally ignored, as an UpdateRequest is immediatelly dispatched - leave any potential connection health issue be handled by the next update cycle.
        
        if (connectionError) {
            NSLog(@"Error during sendKeyToBoxee command: '%@'", connectionError.description);
        }
        
        [self updateBoxeeState:nil];
        
    }];
    
}


-(void) sendToggleMuteToBoxee {
    
    // TODO: invalidate pulse timer - a pulse will be requested right after successful command execution.
    
    // TODO: dispatches a mute command to the current boxee, if there's one connected. Any error in the command response should be interpreted as a connection loss.
    
}



#pragma mark - Connection "keepalive" - updates BoxeeState


-(void) updateBoxeeState:(NSTimer *)timer {
    
    NSString *urlAsString = [NSString stringWithFormat:kCmdUrlTemplate, self.currentConnection.hostname, (long)self.currentConnection.port, @"getcurrentlyplaying()"];
    
    NSURL *updateStateUrl = [[NSURL alloc] initWithString:urlAsString];
    NSURLRequest *request = [NSURLRequest requestWithURL:updateStateUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20];
    
    if (self.currentConnection.password.length > 0) {
        request = [self addAuthenticationHeaderToRequest:request withUser:kBoxeeUsername andPassword:self.currentConnection.password];
    }
    
    _updateStateConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_updateStateConnection start];
    
}


#pragma mark - NSURLConnectionDelegate methods

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"updateBoxeeState completed with error %@", error.description);
    if (_connectingToBoxee) {
        _connectingToBoxee = NO;
        _connectedToBoxee = NO;
        if (self.delegate) {
                [self.delegate failedConnectingToBoxee:self.currentConnection withError:error];
        }
    }
    else {
        _connectedToBoxee = NO;
        if (self.delegate) {
            [self.delegate lostConnectionToBoxee:self.currentConnection];
        }
    }
    self.currentConnection = nil;
}



#pragma mark - NSURLConnectionDataDelegate methods


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    if (((NSHTTPURLResponse *)response).statusCode == 200) {
        
        if (_connectingToBoxee) {
            _connectedToBoxee = YES;
            _connectingToBoxee = NO;
            [[[LastSuccessfulConnectionStore alloc] init] saveLastSuccessfulConnection:self.currentConnection];
            if (self.delegate) {
                // TODO: retrieve boxee state from received data stored by didReceiveData
                // TODO: update current boxee state info
                [self.delegate connectedToBoxee:self.currentConnection withState:nil];
            }
        }
        else {
            // TODO: retrieve boxee state from data stored by didReceiveData and trigger a state change event if appropriate
            // TODO: update current boxee state info
            NSLog(@"Periodic update boxee state request successful");
        }
        
        _updateStateTimer = [NSTimer scheduledTimerWithTimeInterval:kIntervalUpdateState target:self selector:@selector(updateBoxeeState:) userInfo:nil repeats:NO];
        
    }
    else {
        if (_connectingToBoxee) {
            _connectingToBoxee = NO;
            _connectedToBoxee = NO;
            [self.delegate failedConnectingToBoxee:self.currentConnection withError:[NSError errorWithDomain:@"Http error" code:((NSHTTPURLResponse *)response).statusCode userInfo:nil]];
        }
        else {
            _connectedToBoxee = NO;
            if (self.delegate) {
                [self.delegate lostConnectionToBoxee:self.currentConnection];
            }
        }
        self.currentConnection = nil;
    }
    
}


// TODO: handle didReceiveData and store received data in new member - as the Boxee response will never be a large multipart mime type, the received data can be assumed to be the whole chunk.


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
