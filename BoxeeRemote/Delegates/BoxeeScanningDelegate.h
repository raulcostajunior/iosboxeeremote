//
//  BoxeeScanningDelegate.h
//
//  Created by Raul Costa Junior on 5/8/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BoxeeConnection;

@protocol BoxeeScanningDelegate <NSObject>

@required

-(void) startedScanningForBoxees;

-(void) cancelledScanningForBoxees;

-(void) finishedScanningForBoxees:(NSArray<BoxeeConnection *> *)boxeesFound;

-(void) errorWhileScanningForBoxees:(NSError *)error;


@end
