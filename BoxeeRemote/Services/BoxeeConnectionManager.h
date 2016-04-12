//
//  BoxeeConnectionManager.h
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 2/21/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
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

-(void) disconnectFromBoxee;

-(void) sendKeyToBoxee:(BoxeeKeyCode)keyCode;

-(void) sendToggleMuteToBoxee;

@end


#endif /* BoxeeConnectionManager_h */
