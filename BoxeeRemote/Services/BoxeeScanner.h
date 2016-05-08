//
//  BoxeeScanner.h
//
//  Created by Raul Costa Junior on 5/8/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#ifndef BoxeeScanner_h
#define BoxeeScanner_h

@protocol BoxeeScanningDelegate;

@interface BoxeeScanner: NSObject

+(instancetype) sharedScanner;

@property (nonatomic, weak) NSObject<BoxeeScanningDelegate> *delegate;

-(void) scanForBoxees;

-(void) cancelBoxeeScanning;


@end


#endif /* BoxeeScanner_h */
