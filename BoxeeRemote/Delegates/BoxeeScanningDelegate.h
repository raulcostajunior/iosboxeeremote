//
//  BoxeeScanningDelegate.h
//
//  Created by Raul Costa Junior on 5/8/16.
//

#import <Foundation/Foundation.h>

@class BoxeeScanInfo;

@protocol BoxeeScanningDelegate <NSObject>

@required

-(void) startedScanningForBoxees;

-(void) cancelledScanningForBoxees;

// The Boxee scan process finished. At the end of the scan process, either no Boxee has been found (boxeeFound is nil), or a Boxee has been found and its
// data is returned within boxeeFound.
// At least for now, the scan stops as soon as the scan timeout interval elapses or a response comes from one Boxee. Even if there are multiple Boxees in the
// local network, only the first that responds is returned.
-(void) finishedScanningForBoxees:(BoxeeScanInfo *)boxeeFound;

-(void) errorWhileScanningForBoxees:(NSError *)error;


@end
