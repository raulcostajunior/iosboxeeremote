//
//  BoxeeScanner.m
//
//  Created by Raul Costa Junior on 5/8/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BoxeeConnection.h"
#import "BoxeeScanner.h"
#import "BoxeeScanningDelegate.h"


@interface BoxeeScanner() {
    
    BOOL _scanningBoxees;
    
}


@end


@implementation BoxeeScanner


#pragma mark - Singleton life cycle

+(instancetype) sharedScanner {
    
    static BoxeeScanner *scanner;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scanner = [[BoxeeScanner alloc] initInternal];
    });
    
    return scanner;
}


-(instancetype) initInternal {
    
    self = [super init];
    
    if (self) {
        _scanningBoxees = NO;
    }
    
    return self;
    
}


-(instancetype) init {
    
    [NSException raise:@"This is a singleton" format:@"Use sharedScanner method to access the singleton instance."];
    
    return nil;
}




#pragma mark - Scanning control methods

-(void) scanForBoxees {
    
    if (_scanningBoxees) {
        NSLog(@"Wrong usage warning: Boxee scanner only supports one device scan at a time. You're attempting to start multiple simultaneous scannings.");
        NSLog(@"Scanning request will be ignored.");
        
        return;
    }
    
    // TODO: add method body
}

-(void) cancelBoxeeScanning {
    
    // TODO: add method body
}



@end

