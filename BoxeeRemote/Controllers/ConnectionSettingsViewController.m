//
//  ConnectionSettingsViewController.m
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 2/8/16.
//  Copyright © 2016 Digital Streams. All rights reserved.
//

#import "ConnectionSettingsViewController.h"
#import "UIView+Toast.h"

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

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    NSInteger txtFieldTag = textField.tag;
    BOOL shouldReturn = YES;
    
    switch (txtFieldTag) {
        case TXT_HOST_TAG:
            if (self.txtBoxeeHost.text.length > 0) {
                [self.txtBoxeeHost resignFirstResponder];
                [self.txtBoxeePort becomeFirstResponder];
            }
            shouldReturn = NO;
            break;
        case TXT_PORT_TAG:
            if (self.txtBoxeePort.text.length > 0) {
                [self.txtBoxeePort resignFirstResponder];
                [self.txtBoxeePassword becomeFirstResponder];
            }
            shouldReturn = NO;
            break;
        case TXT_PASSWORD_TAG:
            [self.txtBoxeePassword resignFirstResponder];
            if (self.txtBoxeeHost.text.length > 0 && self.txtBoxeePort.text.length > 0) {
                [self doConnectToBoxee];
            }
            shouldReturn = NO;
    }
    
    return shouldReturn;
}


#pragma mark - Action methods


-(void) doConnectToBoxee {
    
    [self hideKeyboard];
    
    NSArray<NSString *> *validationErrors = [self validateConnectionParams];
    
    if ([validationErrors count] > 0) {
        CSToastStyle *errorStyle = [[CSToastStyle alloc] initWithDefaultStyle];
        errorStyle.backgroundColor = [UIColor redColor];
        
        if ([validationErrors count] == 1) {
            [self.view makeToast:[validationErrors objectAtIndex:0] duration:3.5f position:CSToastPositionBottom style:errorStyle];
        }
        else if ([validationErrors count] > 1) {
            NSString *errorMsg = [validationErrors objectAtIndex:0];
            for (int i = 1; i < [validationErrors count]; i++) {
                errorMsg = [NSString stringWithFormat:@"%@\n\n%@", errorMsg, [validationErrors objectAtIndex:i]];
            }
            [self.view makeToast:errorMsg duration:4.5f position:CSToastPositionBottom style:errorStyle];
        }
    }
    else {
        // No validation error found - go ahead an try to connect to the Boxee.
    }
    
}


-(void) doFindBoxees {
    
}


#pragma mark - Internal utility methods


-(NSArray<NSString *> *)validateConnectionParams {
    
    NSMutableArray<NSString *> *validationErrors = [[NSMutableArray<NSString *> alloc] initWithCapacity:2];
    if (self.txtBoxeeHost.text.length < 1) {
        [validationErrors addObject: NSLocalizedString(@"hostNotSpecified", @"Empty boxee hostname validation error")];
    }
    if (self.txtBoxeePort.text.length < 1) {
        [validationErrors addObject: NSLocalizedString(@"portNotSpecified", @"Empty boxee port validation error")];
    }
    else {
        NSScanner *portScanner = [[NSScanner alloc] initWithString:self.txtBoxeePort.text];
        int boxeePort = -1;
        BOOL isPortValid = [portScanner scanInt:&boxeePort];
        if (!isPortValid) {
            [validationErrors addObject: NSLocalizedString(@"invalidPort", @"Invalid boxee port validation error")];
        }
        else {
            NSString *boxeePortAsString = [NSString stringWithFormat:@"%d",boxeePort];
            if (boxeePort < 0 || [boxeePortAsString length] != [self.txtBoxeePort.text length]) {
                // The port is either negative or there are extra characters in the port entry
                [validationErrors addObject: NSLocalizedString(@"invalidPort", @"Invalid boxee port validation error")];
            }
        }
    }
    
    return validationErrors;
}


#pragma mark - Internal UI setup methods


-(void) setupButtons {
    self.btnScanBoxees.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnScanBoxees.layer.borderWidth = 1.0;
    self.btnScanBoxees.layer.cornerRadius = 5.0;
    
    self.btnConnectBoxee.layer.borderColor = [[UIColor colorWithRed:174.0/255.0 green:254.0/255.0 blue:133.0/255.0 alpha:1.0] CGColor];
    self.btnConnectBoxee.layer.borderWidth = 1.0;
    self.btnConnectBoxee.layer.cornerRadius = 5.0;
    [self.btnConnectBoxee addTarget:self action:@selector(doConnectToBoxee) forControlEvents:UIControlEventTouchUpInside];
}



-(void) setupTextFields {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    self.txtBoxeeHost.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtBoxeeHost.keyboardType = UIKeyboardTypeDefault;
    self.txtBoxeePort.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.txtBoxeeHost.tag = TXT_HOST_TAG;
    self.txtBoxeeHost.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtBoxeeHost.delegate = self;
    
    self.txtBoxeePort.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtBoxeePort.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.txtBoxeePort.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.txtBoxeePort.tag = TXT_PORT_TAG;
    self.txtBoxeePort.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtBoxeePort.delegate = self;
    
    self.txtBoxeePassword.autocorrectionType = UITextAutocorrectionTypeNo;
    self.txtBoxeePassword.keyboardType = UIKeyboardTypeDefault;
    self.txtBoxeePassword.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.txtBoxeePassword.secureTextEntry = YES;
    self.txtBoxeePassword.tag = TXT_PASSWORD_TAG;
    self.txtBoxeePassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.txtBoxeePassword.delegate = self;
}



-(void) hideKeyboard {
    [self.txtBoxeeHost resignFirstResponder];
    [self.txtBoxeePort resignFirstResponder];
    [self.txtBoxeePassword resignFirstResponder];
}


@end
