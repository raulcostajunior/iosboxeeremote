//
//  BoxeeConnection.h
//
//  Created by Raul Costa Junior on 2/21/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#ifndef BoxeeConnection_h
#define BoxeeConnection_h

#import <Foundation/Foundation.h>

@interface BoxeeConnection: NSObject

+(NSInteger) boxeeDefaultPort;

@property (nonatomic, strong) NSString *hostname;
@property (nonatomic) NSInteger port;
@property (nonatomic, strong) NSString *password;

@end


#endif /* BoxeeConnection_h */
