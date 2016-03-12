//
//  BoxeeConnectionManager.m
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 2/21/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BoxeeConnection.h"
#import "BoxeeConnectionManager.h"


@implementation BoxeeConnectionManager

+(instancetype) sharedManager {
    // TODO: implement actual body
    return nil;
}


-(BoxeeConnection *) lastSuccessfulConnection {
    // TODO: implement actual body
    return nil;
}


-(void) connectToBoxee:(BoxeeConnection *)connectionParams {
    // TODO: implement actual body
}

// TODO: implement connection keepalive - piggyback on the keepalive response for a BoxeeState refresh.

@end
