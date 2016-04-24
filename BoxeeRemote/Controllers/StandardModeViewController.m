//
//  StandardModeViewController.m
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 4/10/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import "StandardModeViewController.h"
#import "BoxeeConnectionManager.h"
#import "BoxeeKeyCode.h"

@interface StandardModeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btnOptions;

@property (weak, nonatomic) IBOutlet UIButton *btnEnter;

@property (weak, nonatomic) IBOutlet UIButton *btnUp;

@property (weak, nonatomic) IBOutlet UIButton *btnLeft;

@property (weak, nonatomic) IBOutlet UIButton *btnDown;

@property (weak, nonatomic) IBOutlet UIButton *btnRight;

@property (weak, nonatomic) IBOutlet UIButton *btnBoxeeLogo;

@end

@implementation StandardModeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButtons];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Send command methods

-(void) sendMoveUp {
    [[BoxeeConnectionManager sharedManager] sendKeyToBoxee:BoxeeKeyCodeUp];
}


-(void) sendMoveDown {
    [[BoxeeConnectionManager sharedManager] sendKeyToBoxee:BoxeeKeyCodeDown];
}


-(void) sendMoveRight {
    [[BoxeeConnectionManager sharedManager] sendKeyToBoxee:BoxeeKeyCodeRight];
}


-(void) sendMoveLeft{
    [[BoxeeConnectionManager sharedManager] sendKeyToBoxee:BoxeeKeyCodeLeft];
}


-(void) sendGo {
    [[BoxeeConnectionManager sharedManager] sendKeyToBoxee:BoxeeKeyCodeGo];
}


-(void) sendBack {
    [[BoxeeConnectionManager sharedManager] sendKeyToBoxee:BoxeeKeyCodeBack];
}



#pragma mark - Internal utility methods


-(void) setupButtons {
    
    self.btnUp.layer.cornerRadius = 8.0f;
    [self.btnUp addTarget:self action:@selector(sendMoveUp) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnRight.layer.cornerRadius = 8.0f;
    [self.btnRight addTarget:self action:@selector(sendMoveRight) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnDown.layer.cornerRadius = 8.0f;
    [self.btnDown addTarget:self action:@selector(sendMoveDown) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnLeft.layer.cornerRadius = 8.0f;
    [self.btnLeft addTarget:self action:@selector(sendMoveLeft) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnEnter.layer.cornerRadius = 29.0f;
    [self.btnEnter addTarget:self action:@selector(sendGo) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnOptions.layer.cornerRadius = 8.0f;
    [self.btnOptions addTarget:self action:@selector(sendBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnBoxeeLogo addTarget:self action:@selector(doDisconnectBoxee) forControlEvents:UIControlEventTouchUpInside];

}

-(void) doDisconnectBoxee {
    // "Disconnects" the Boxee - as a result the application will move back to the Connection Settings view (the "home" screen).
    [[BoxeeConnectionManager sharedManager] disconnectFromBoxee];
    
}

@end
