//
//  BoxeeScanInfo.h
//  Information returned by a Boxee in response for a locally broadcasted scan request.
//
//  Created by Raul Costa Junior on 5/21/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#ifndef BoxeeScanInfo_h
#define BoxeeScanInfo_h

@interface BoxeeScanInfo: NSObject

@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ipAddress;
@property (nonatomic) NSInteger port;
@property (nonatomic) BOOL authenticationRequired;

@end


#endif /* BoxeeScanInfo_h */
