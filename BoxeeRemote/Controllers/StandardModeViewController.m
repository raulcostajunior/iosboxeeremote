//
//  StandardModeViewController.m
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 4/10/16.
//

#import "StandardModeViewController.h"
#import "BoxeeConnectionManager.h"
#import "BoxeeKeyCode.h"

@interface StandardModeViewController () {
    BoxeeKeyCode _touchedKeyCode;
}

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
    
    _touchedKeyCode = BoxeeKeyCodeNone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Touch handling methods

-(void) touchedDownButton:(UIButton *)sender {
    
    if (_touchedKeyCode != BoxeeKeyCodeNone) {
        // Another button is already being touched. The remote is not multi-touched, so ignore this touch
        return;
    }
    
    sender.layer.shadowRadius = 22.0f;
    sender.layer.shadowColor = [[UIColor greenColor] CGColor];//[[UIColor colorWithRed:178.0 green:254.0 blue:135.0 alpha:1.0] CGColor];
    sender.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    sender.layer.shadowOpacity = 1.0;
    sender.layer.masksToBounds = NO;
    
    // Sends the key code corresponding to the touched button once and keep sending it while the user keeps touching the button and no key send command error happens.
    _touchedKeyCode = sender.tag;
    [[BoxeeConnectionManager sharedManager] startSendKeyToBoxee:sender.tag];
    
}


-(void) touchedUpButton:(UIButton *)sender {
    
    // Interrupts the send key code sequence.
    _touchedKeyCode = BoxeeKeyCodeNone;
    
    [[BoxeeConnectionManager sharedManager] stopSendKeyToBoxee];
    
    sender.layer.shadowRadius = 0;
    sender.layer.shadowColor = [[UIColor clearColor] CGColor];
    sender.layer.masksToBounds = YES;
    
}


#pragma mark - Internal utility methods


-(void) setupButtons {
    
    self.btnUp.layer.cornerRadius = 8.0f;
    self.btnUp.tag = BoxeeKeyCodeUp;
    [self.btnUp addTarget:self action:@selector(touchedDownButton:) forControlEvents:UIControlEventTouchDown];
    [self.btnUp addTarget:self action:@selector(touchedUpButton:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpInside];
    
    self.btnRight.layer.cornerRadius = 8.0f;
    self.btnRight.tag = BoxeeKeyCodeRight;
    [self.btnRight addTarget:self action:@selector(touchedDownButton:) forControlEvents:UIControlEventTouchDown];
    [self.btnRight addTarget:self action:@selector(touchedUpButton:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpInside];
    
    self.btnDown.layer.cornerRadius = 8.0f;
    self.btnDown.tag = BoxeeKeyCodeDown;
    [self.btnDown addTarget:self action:@selector(touchedDownButton:) forControlEvents:UIControlEventTouchDown];
    [self.btnDown addTarget:self action:@selector(touchedUpButton:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpInside];
    
    self.btnLeft.layer.cornerRadius = 8.0f;
    self.btnLeft.tag = BoxeeKeyCodeLeft;
    [self.btnLeft addTarget:self action:@selector(touchedDownButton:) forControlEvents:UIControlEventTouchDown];
    [self.btnLeft addTarget:self action:@selector(touchedUpButton:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpInside];
    
    self.btnEnter.layer.cornerRadius = 29.0f;
    self.btnEnter.tag = BoxeeKeyCodeGo;
    [self.btnEnter addTarget:self action:@selector(touchedDownButton:) forControlEvents:UIControlEventTouchDown];
    [self.btnEnter addTarget:self action:@selector(touchedUpButton:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpInside];
    
    self.btnOptions.layer.cornerRadius = 8.0f;
    self.btnOptions.tag = BoxeeKeyCodeBack;
    [self.btnOptions addTarget:self action:@selector(touchedDownButton:) forControlEvents:UIControlEventTouchDown];
    [self.btnOptions addTarget:self action:@selector(touchedUpButton:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpInside];
    
    [self.btnBoxeeLogo addTarget:self action:@selector(doDisconnectBoxee) forControlEvents:UIControlEventTouchUpInside];

}

-(void) doDisconnectBoxee {
    // "Disconnects" the Boxee - as a result the application will move back to the Connection Settings view (the "home" screen).
    [[BoxeeConnectionManager sharedManager] disconnectFromBoxee];
    
}

@end
