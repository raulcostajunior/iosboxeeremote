//
//  BoxeeConnectionManager.h
//
//  Created by Raul Costa Junior on 2/21/16.
//

#ifndef BoxeeConnectionManager_h
#define BoxeeConnectionManager_h

#import "BoxeeKeyCode.h"

@class BoxeeConnection;
@protocol BoxeeConnectionDelegate;


@interface BoxeeConnectionManager: NSObject

+(instancetype) sharedManager;

@property (nonatomic, weak) NSObject<BoxeeConnectionDelegate> *delegate;

-(BoxeeConnection *) lastSuccessfulConnection;

-(void) connectToBoxee:(BoxeeConnection *)connectionParams;

-(void) cancelConnection;

-(void) disconnectFromBoxee;

-(void) startSendKeyToBoxee:(BoxeeKeyCode)keyCode;

-(void) stopSendKeyToBoxee;

-(void) sendToggleMuteToBoxee;

@end


#endif /* BoxeeConnectionManager_h */
