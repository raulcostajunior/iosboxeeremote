//
//  BoxeeConnectionDelegate.h
//
//  Created by Raul Costa Junior on 2/21/16.
//

#import <Foundation/Foundation.h>

@class BoxeeConnection;
@class BoxeeState;


@protocol BoxeeConnectionDelegate <NSObject>

@required

-(void) connectingToBoxee:(BoxeeConnection *)connectingBoxee;

-(void) connectedToBoxee:(BoxeeConnection *)connectedBoxee withState:(BoxeeState *)connectedBoxeeState;

-(void) cancelledConnectingToBoxee:(BoxeeConnection *)cancelledConnection;

-(void) failedConnectingToBoxee:(BoxeeConnection *)failedConnection withError:(NSError *)error;

-(void) lostConnectionToBoxee:(BoxeeConnection *)lostConnection;

-(void) connectedBoxeeStateChanged:(BoxeeState *)currentState fromPreviousState:(BoxeeState *)previousState;

-(void) disconnectedFromBoxee:(BoxeeConnection *)disconnectedBoxee;


@end
