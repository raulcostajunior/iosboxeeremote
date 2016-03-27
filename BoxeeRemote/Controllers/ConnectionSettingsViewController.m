//
//  ConnectionSettingsViewController.m
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 2/8/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import "ConnectionSettingsViewController.h"

@interface ConnectionSettingsViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtBoxeeHost;

@property (weak, nonatomic) IBOutlet UITextField *txtBoxeePort;

@property (weak, nonatomic) IBOutlet UITextField *txtBoxeePassword;

@property (weak, nonatomic) IBOutlet UIButton *btnScanBoxees;

@property (weak, nonatomic) IBOutlet UIButton *btnConnectBoxee;


@end

@implementation ConnectionSettingsViewController

static const NSInteger TXT_HOST_TAG = 1;
static const NSInteger TXT_PORT_TAG = 2;
static const NSInteger TXT_PASSWORD_TAG = 3;

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButtons];
    [self setupTextFields];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITextFieldDelegate methods




#pragma mark - Internal UI setup methods


-(void) setupButtons {
    self.btnScanBoxees.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnScanBoxees.layer.borderWidth = 1.0;
    self.btnScanBoxees.layer.cornerRadius = 5.0;
    
    self.btnConnectBoxee.layer.borderColor = [[UIColor colorWithRed:174.0/255.0 green:254.0/255.0 blue:133.0/255.0 alpha:1.0] CGColor];
    self.btnConnectBoxee.layer.borderWidth = 1.0;
    self.btnConnectBoxee.layer.cornerRadius = 5.0;
}



-(void) setupTextFields {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.txtBoxeeHost.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtBoxeeHost.keyboardType = UIKeyboardTypeDefault;
    self.txtBoxeePort.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.txtBoxeeHost.tag = TXT_HOST_TAG;
    self.txtBoxeeHost.delegate = self;
    
    self.txtBoxeePort.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtBoxeePort.keyboardType = UIKeyboardTypeNumberPad;
    self.txtBoxeePort.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.txtBoxeePort.tag = TXT_PORT_TAG;
    self.txtBoxeePort.delegate = self;
    
    self.txtBoxeePassword.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtBoxeePassword.keyboardType = UIKeyboardTypeDefault;
    self.txtBoxeePassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.txtBoxeePassword.secureTextEntry = YES;
    self.txtBoxeePassword.tag = TXT_PASSWORD_TAG;
    self.txtBoxeePassword.delegate = self;
    
    
}



-(void) hideKeyboard {
    [self.txtBoxeeHost resignFirstResponder];
    [self.txtBoxeePort resignFirstResponder];
    [self.txtBoxeePassword resignFirstResponder];
}


@end
