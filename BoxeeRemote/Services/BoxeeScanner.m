//
//  BoxeeScanner.m
//
//  Created by Raul Costa Junior on 5/8/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//
//  The documentation for Boxee's discovery request and response can be found at
//  https://web.archive.org/web/20130603035923/http://developer.boxee.tv/Remote_Control_Interface
//  (the original site is not available anymore).

#import <arpa/inet.h>
#import <CommonCrypto/CommonDigest.h>
#import <Foundation/Foundation.h>

#import "BoxeeScanInfo.h"
#import "BoxeeScanner.h"
#import "BoxeeScanningDelegate.h"
#import "DDXML.h"
#import "GCDAsyncUdpSocket.h"


@interface BoxeeScanner() <GCDAsyncUdpSocketDelegate> {
    
    BOOL _scanningBoxee;
    GCDAsyncUdpSocket *_udpSocket;
    NSTimer *_scanTimeoutTimer;
    
}


@end


@implementation BoxeeScanner


#pragma mark - Boxee scanning parameters - no need to externalize as they're not configurable

static NSString *const BOXEE_APP = @"iphone_remote";
static NSString *const BOXEE_KEY = @"b0xeeRem0tE!";
static NSString *const BOXEE_CHALLENGE = @"boxeeChallenge"; // Can be any string
static NSInteger BOXEE_UDP_PORT = 2562;
static NSString *const BOXEE_UDP_BROADCAST_ADDR = @"255.255.255.255";
static NSTimeInterval SCAN_TIMEOUT_SECONDS = 5.0;


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
        _scanningBoxee = NO;
    }
    
    return self;
    
}


-(instancetype) init {
    
    [NSException raise:@"This is a singleton" format:@"Use sharedScanner method to access the singleton instance."];
    
    return nil;
}




#pragma mark - Scanning control methods

-(void) scanForBoxees {
    
    if (_scanningBoxee) {
        NSLog(@"Wrong usage warning: Boxee scanner only supports one device scan at a time. You're attempting to start multiple simultaneous scannings.");
        NSLog(@"Scanning request will be ignored.");
        
        return;
    }
    
    _scanningBoxee = YES;
    
    if (self.delegate) {
        [self.delegate startedScanningForBoxees];
    }
    
    NSError *error;
    BOOL socketInitialized = [self initUdpSocket:&error];
    
    if (!socketInitialized) {
        NSLog(@"UDP socket could not be initialized. Scan process aborted.");
        if (self.delegate) {
            [self.delegate errorWhileScanningForBoxees:error];
        }
        _scanningBoxee = NO;
        return;
    }

    [self broadcastScanMessage];
    
}


-(void) cancelBoxeeScanning {
    
    [_udpSocket close];
    
    _scanningBoxee = NO;
    
    if (self.delegate) {
        [self.delegate cancelledScanningForBoxees];
    }
    
    _udpSocket = nil;
    
}


#pragma mark - UDP based communication (includes GCDAsyncUdpSocketDelegate methods)


-(BOOL) initUdpSocket:(NSError *__autoreleasing *)errorPtr {

    _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *__autoreleasing error;
    
    [_udpSocket bindToPort:0 error:&error];
    if (error) {
        NSLog(@"Error initializing socket - binding to port 0: %@", error.description);
        errorPtr = &error;
        return NO;
    }
    
    [_udpSocket beginReceiving:&error];
    if (error) {
        NSLog(@"Error initializing socket - in beginReceiving call: %@", error.description);
        errorPtr = &error;
        return NO;
    }
    
    
    [_udpSocket enableBroadcast:YES error:&error];
    if (error) {
        NSLog(@"Error initializing socket - in enableBroadcast call: %@", error.description);
        errorPtr = &error;
        return NO;
    }
    else {
        errorPtr = nil;
        return YES;
    }
    
}



-(void) broadcastScanMessage {
    
    NSString *signature = [self signatureFromChallenge:BOXEE_CHALLENGE];
    NSString *scanMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\"?>\n<BDP1 cmd=\"discover\" application=\"%@\" challenge=\"%@\" signature=\"%@\"/>", BOXEE_APP, BOXEE_CHALLENGE, signature];
    NSData *scanMsgData = [scanMsg dataUsingEncoding:NSUTF8StringEncoding];
    
    // Send data with negative timeout to prevent time outs from the AsyncSocket layer - relying on soft timeouts controlled by a timer owned by the service instance instead.
    [_udpSocket sendData:scanMsgData toHost:BOXEE_UDP_BROADCAST_ADDR port:BOXEE_UDP_PORT withTimeout:-1 tag:1];
    _scanTimeoutTimer = [NSTimer scheduledTimerWithTimeInterval:SCAN_TIMEOUT_SECONDS target:self selector:@selector(scanTimedOut:) userInfo:nil repeats:NO];
}


-(void) scanTimedOut:(NSTimer *)timer {
    
    if (_scanningBoxee) {
        
        [_udpSocket close];
        _scanningBoxee = NO;
        _udpSocket = nil;
        
        // A timeout scanning for boxees is interpreted as a finished scan process that didn't manage to find any boxee.
        if (self.delegate) {
            [self.delegate finishedScanningForBoxees:nil];
        }
    }
    
    if (_scanTimeoutTimer) {
        [_scanTimeoutTimer invalidate];
    }
    
}



// Method from GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    
    [_udpSocket close];
    _scanningBoxee = NO;
    _udpSocket = nil;
    
    if (self.delegate) {
        [self.delegate errorWhileScanningForBoxees:error];
    }
    
}


// Method from GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    
    [_udpSocket close];
    _scanningBoxee = NO;
    _udpSocket = nil;
    
    struct sockaddr_in *fromAddr;
    fromAddr = (struct sockaddr_in *)[address bytes];
    NSString *boxeeIpAddr = [NSString stringWithCString:inet_ntoa(fromAddr->sin_addr) encoding:NSASCIIStringEncoding];
    
    NSString *scanResponseContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    BoxeeScanInfo *boxeeInfo = [[BoxeeScanInfo alloc] init];
    boxeeInfo.ipAddress = boxeeIpAddr;

    NSError *error = [[NSError alloc] init];
    NSXMLDocument *respDoc = [[NSXMLDocument alloc] initWithXMLString:scanResponseContents options:1 << 9 error:&error];
    if (error.domain != nil && error.code != 0) {
        
        if (self.delegate) {
            [self.delegate errorWhileScanningForBoxees:error];
        }
        
    }
    else {
        for (NSXMLNode *attrib in respDoc.rootElement.attributes) {
            if ([attrib.name isEqualToString:@"version"]) {
                boxeeInfo.version = [attrib stringValue];
            }
            else if ([attrib.name isEqualToString:@"httpPort"]) {
                boxeeInfo.port = [[attrib stringValue] integerValue];
            }
            else if ([attrib.name isEqualToString:@"httpAuthRequired"]) {
                boxeeInfo.authenticationRequired = [[attrib stringValue] boolValue];
            }
            else if ([attrib.name isEqualToString:@"name"]) {
                boxeeInfo.name = [attrib stringValue];
            }
        }
        
        if (self.delegate) {
            [self.delegate finishedScanningForBoxees:boxeeInfo];
        }
    }

}



// Method from GCDAsyncUdpSocketDelegate
- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    
    NSLog(@"Socket closed");
    if (error) {
        NSLog(@"Socket closed with error: %@", error.description);
    }
    
}


#pragma mark - Internal utility functions


-(NSString *)signatureFromChallenge:(NSString *)challenge {
    
    NSString *md5Entry = [NSString stringWithFormat:@"%@%@", challenge, BOXEE_KEY];
    return [self md5ForString:md5Entry];
    
}


// Extracted from http://stackoverflow.com/questions/652300/using-md5-hash-on-a-string-in-cocoa?rq=1
-(NSString *) md5ForString:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]
            ];
}


@end

