//
//  LastSuccessfulConnectionStore.h
//
//  Created by Raul Costa Junior on 4/13/16.
//

#ifndef LastSuccessfulConnectionStore_h
#define LastSuccessfulConnectionStore_h

@class BoxeeConnection;

@interface LastSuccessfulConnectionStore: NSObject

-(BoxeeConnection *) loadLastSuccessfulConnection;

-(void) saveLastSuccessfulConnection:(BoxeeConnection *)lastSuccessfulConnection;

@end

#endif /* LastSuccessfulConnectionStore_h */
