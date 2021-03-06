//
//  BoxeeState.h
//
//  Created by Raul Costa Junior on 2/21/16.
//

#ifndef BoxeeState_h
#define BoxeeState_h

typedef NS_ENUM(NSInteger, BoxeeMode) {
    BoxeeModeStandard,
    BoxeeModePlaying,
    BoxeeModeTextEntry
};


typedef NS_ENUM(NSInteger, BoxeeMediaType) {
    BoxeeMediaNone,
    BoxeeMediaAudio,
    BoxeeMediaVideo,
    BoxeeMediaPhoto
};


@interface BoxeeState: NSObject

@property (nonatomic) BoxeeMode mode;
@property (nonatomic) BoxeeMediaType mediaType;
@property (nonatomic, strong) NSString *mediaTitle;
@property (nonatomic, strong) NSString *mediaFile;
@property (nonatomic) NSInteger mediaDurationSeconds;
@property (nonatomic) NSInteger mediaTimeSeconds;
@property (nonatomic, strong) NSString* initialTextValue;
@property (nonatomic) BOOL hideText;
@property (nonatomic) NSInteger volume;
@property (nonatomic) BOOL muteOn;

@end


#endif /* BoxeeState_h */
