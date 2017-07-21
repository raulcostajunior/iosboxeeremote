//
//  ConnectionSettingsViewController.m
//  BoxeeRemote
//
//  Created by Raul Costa Junior on 2/8/16.
//

#import "BoxeeConnection.h"
#import "BoxeeConnectionManager.h"
#import "BoxeeScanInfo.h"
#import "BoxeeScanner.h"
#import "BoxeeScanningDelegate.h"
#import "ConnectionSettingsViewController.h"
#import "UIView+Toast.h"

@interface ConnectionSettingsViewController () <UITextFieldDelegate, UIAlertViewDelegate, BoxeeScanningDelegate> {
    
    BoxeeScanInfo *_boxeeFound;
    
}

@property (weak, nonatomic) IBOutlet UITextField *txtBoxeeHost;

@property (weak, nonatomic) IBOutlet UITextField *txtBoxeePort;

@property (weak, nonatomic) IBOutlet UITextField *txtBoxeePassword;

@property (weak, nonatomic) IBOutlet UIButton *btnScanBoxees;

@property (weak, nonatomic) IBOutlet UIButton *btnConnectBoxee;

@property (weak, nonatomic) IBOutlet UIView *viewToastContainer;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *lblVersion;


@end

@implementation ConnectionSettingsViewController

static const NSInteger TXT_HOST_TAG = 1;
static const NSInteger TXT_PORT_TAG = 2;
static const NSInteger TXT_PASSWORD_TAG = 3;

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *verNumFmtStr = NSLocalizedString(@"versionNumberLabel", @"Application version number label");
    self.lblVersion.text = [NSString stringWithFormat:verNumFmtStr, [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
    
    [self setupButtonsDefaultState];
    [self setupTextFields];
    
    BoxeeConnection *lastConnection = [[BoxeeConnectionManager sharedManager] lastSuccessfulConnection];
    if (lastConnection) {
        self.txtBoxeeHost.text = lastConnection.hostname;
        self.txtBoxeePort.text = [NSString stringWithFormat:@"%ld", (long)lastConnection.port];
        self.txtBoxeePassword.text = lastConnection.password;
    }
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


#pragma mark - Connection progress handler methods

-(void) connectingToBoxee {
    
    [self.activityIndicator startAnimating];
    
    [self setupButtonsConnectingState];
    
}


-(void) cancelledConnectionToBoxee {
    
    [self.activityIndicator stopAnimating];
    
    CSToastStyle *errorStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    errorStyle.backgroundColor = [UIColor darkGrayColor];
    
    [self.viewToastContainer makeToast:NSLocalizedString(@"cancelledConnectionMsg", @"Message to be displayed upon cancelling connection to a Boxee") duration:1.5f position:CSToastPositionTop style:errorStyle];
    
    [self setupButtonsDefaultState];
    
}

#pragma mark - Connection error handler methods


-(void) displayLostConnectionError {
    
    [self.activityIndicator stopAnimating];
    
    CSToastStyle *errorStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    errorStyle.backgroundColor = [UIColor redColor];
    
    [self.viewToastContainer makeToast:NSLocalizedString(@"lostConnectionMsg", @"Message to be displayed upon loosing connection to a Boxee") duration:3.5f position:CSToastPositionTop style:errorStyle];
    
}



-(void) displayFailedToConnectError:(NSError *)error {
    
    [self.activityIndicator stopAnimating];
       
    [self setupButtonsDefaultState];
    
    CSToastStyle *errorStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    errorStyle.backgroundColor = [UIColor redColor];
    
    [self.viewToastContainer makeToast:NSLocalizedString(@"failedToConnectMsg", @"Message to be displayed upon failing to connect to a Boxee") duration:3.5f position:CSToastPositionTop style:errorStyle];
    
}


#pragma mark - BoxeeScanningDelegate methods


-(void) startedScanningForBoxees {
    
    [self.activityIndicator startAnimating];
    
    [self setupButtonsScanningState];
    
}



-(void) cancelledScanningForBoxees {
    
    // TODO: add method body as soon as scan action becomes cancellable. For now it is not cancellable as it has a very short timeout, 5 secs.
    
}



-(void) finishedScanningForBoxees:(BoxeeScanInfo *)boxeeFound {
    
    [self.activityIndicator stopAnimating];
    
    [self setupButtonsDefaultState];
    
    if (boxeeFound) {
        
        _boxeeFound = boxeeFound;
        
        NSString *authRequiredMsg;
        if (boxeeFound.authenticationRequired) {
            authRequiredMsg = NSLocalizedString(@"passwordRequired", @"Password required by Boxee message.");
        }
        else {
            authRequiredMsg = NSLocalizedString(@"passwordNotRequired", @"Password not required by Boxee message.");
        }
        UIAlertView *boxeeInfoMsg = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"boxeeFoundTitle", @"Boxee found title") message:[NSString stringWithFormat:NSLocalizedString(@"boxeeFoundMessage", @"Boxee found message."), boxeeFound.ipAddress, (long)boxeeFound.port, authRequiredMsg] delegate:self cancelButtonTitle:NSLocalizedString(@"no", @"No") otherButtonTitles:NSLocalizedString(@"yes", @"Yes"), nil];
        
        [boxeeInfoMsg show];
        
    }
    else {
        
        CSToastStyle *infoStyle = [[CSToastStyle alloc] initWithDefaultStyle];
        infoStyle.backgroundColor = [UIColor grayColor];
        
        [self.viewToastContainer makeToast:NSLocalizedString(@"tryAgainMsg", @"Try again message") duration:3.5f position:CSToastPositionTop title:NSLocalizedString(@"noBoxeeFoundTitle", @"No Boxee found title") image:nil style:infoStyle completion:nil];
        
    }
    
}



-(void) errorWhileScanningForBoxees:(NSError *)error {
    
    [self.activityIndicator stopAnimating];
    
    [self setupButtonsDefaultState];
    
    CSToastStyle *errorStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    errorStyle.backgroundColor = [UIColor redColor];
    
    // TODO: Localize message and see if any improvement can be made to it.
    [self.viewToastContainer makeToast:NSLocalizedString(@"errorScanningForBoxeesMsg", @"Message to be displayed when an error happens while scanning for Boxees") duration:3.5f position:CSToastPositionTop style:errorStyle];
    
}


#pragma mark - UIAlertViewDelegate methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != alertView.cancelButtonIndex) {
        // User confirmed that wants to connect to the Boxee that has been found by the scanning process
        self.txtBoxeeHost.text = _boxeeFound.ipAddress;
        self.txtBoxeePort.text = [NSString stringWithFormat:@"%ld", (long)_boxeeFound.port];
        if (_boxeeFound.authenticationRequired) {
            // Authentication is required: put focus on the password field
            [self.txtBoxeePassword becomeFirstResponder];
        }
        else {
            // No authentication is required: go ahead and try to connect to the Boxee; delays the connection command so that the alert view is completely dismissed
            // before starting the connection process - needed to guarantee proper UI feedback while connection is taking place.
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self doConnectToBoxee];
            });
        }
    }
    
    _boxeeFound = nil;
    
}



#pragma mark - Action methods


-(void) doConnectToBoxee {
    
    [self hideKeyboard];
    
    NSArray<NSString *> *validationErrors = [self validateConnectionParams];
    
    if ([validationErrors count] > 0) {
        CSToastStyle *errorStyle = [[CSToastStyle alloc] initWithDefaultStyle];
        errorStyle.backgroundColor = [UIColor redColor];
        
        if ([validationErrors count] == 1) {
            [self.viewToastContainer makeToast:[validationErrors objectAtIndex:0] duration:3.5f position:CSToastPositionTop style:errorStyle];
        }
        else if ([validationErrors count] > 1) {
            NSString *errorMsg = [validationErrors objectAtIndex:0];
            for (int i = 1; i < [validationErrors count]; i++) {
                errorMsg = [NSString stringWithFormat:@"%@\n\n%@", errorMsg, [validationErrors objectAtIndex:i]];
            }
            [self.viewToastContainer makeToast:errorMsg duration:4.5f position:CSToastPositionTop style:errorStyle];
        }
    }
    else {
        // No validation error found - go ahead an try to connect to the Boxee.
        BoxeeConnection *conn = [[BoxeeConnection alloc] init];
        conn.hostname = self.txtBoxeeHost.text;
        conn.port = [self.txtBoxeePort.text integerValue];
        conn.password = self.txtBoxeePassword.text;
        
        [[BoxeeConnectionManager sharedManager] connectToBoxee:conn];
    }
    
}


-(void) doFindBoxees {

    [self hideKeyboard];
    
    [BoxeeScanner sharedScanner].delegate = self;
    [[BoxeeScanner sharedScanner] scanForBoxees];
    
}


-(void) doCancelConnection {
    
    [[BoxeeConnectionManager sharedManager] cancelConnection];
}



-(void) doCancelBoxeeScan {
    
    [[BoxeeScanner sharedScanner] cancelBoxeeScanning];
    
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


-(void) setupButtonsDefaultState {
    self.btnScanBoxees.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnScanBoxees.layer.borderWidth = 1.0;
    self.btnScanBoxees.layer.cornerRadius = 5.0;
    [self.btnScanBoxees removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.btnScanBoxees setTitle:NSLocalizedString(@"scanBoxeeLabel", @"Button label for scan Boxee action") forState:UIControlStateNormal];
    [self.btnScanBoxees addTarget:self action:@selector(doFindBoxees) forControlEvents:UIControlEventTouchUpInside];
    self.btnScanBoxees.enabled = YES;
    
    self.btnConnectBoxee.layer.borderColor = [[UIColor colorWithRed:174.0/255.0 green:254.0/255.0 blue:133.0/255.0 alpha:1.0] CGColor];
    self.btnConnectBoxee.layer.borderWidth = 1.0;
    self.btnConnectBoxee.layer.cornerRadius = 5.0;
    [self.btnConnectBoxee removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.btnConnectBoxee setTitle:NSLocalizedString(@"connectBoxeeLabel", @"Button label for connect to Boxee action") forState:UIControlStateNormal];
    [self.btnConnectBoxee addTarget:self action:@selector(doConnectToBoxee) forControlEvents:UIControlEventTouchUpInside];
    self.btnConnectBoxee.enabled = YES;
}


-(void) setupButtonsConnectingState {
    self.btnScanBoxees.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnScanBoxees.layer.borderWidth = 1.0;
    self.btnScanBoxees.layer.cornerRadius = 5.0;
    self.btnScanBoxees.enabled = NO;
    
    self.btnConnectBoxee.layer.borderColor = [[UIColor colorWithRed:174.0/255.0 green:254.0/255.0 blue:133.0/255.0 alpha:1.0] CGColor];
    self.btnConnectBoxee.layer.borderWidth = 1.0;
    self.btnConnectBoxee.layer.cornerRadius = 5.0;
    [self.btnConnectBoxee removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.btnConnectBoxee setTitle:NSLocalizedString(@"cancelConnectionLabel", @"Button label for cancel ongoing connection action") forState:UIControlStateNormal];
    [self.btnConnectBoxee addTarget:self action:@selector(doCancelConnection) forControlEvents:UIControlEventTouchUpInside];
    self.btnConnectBoxee.enabled = YES;
}



-(void) setupButtonsScanningState {
    self.btnScanBoxees.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.btnScanBoxees.layer.borderWidth = 1.0;
    self.btnScanBoxees.layer.cornerRadius = 5.0;
    [self.btnScanBoxees setTitle:NSLocalizedString(@"scanningBoxeeLabel", @"Button label for scanning Boxee action") forState:UIControlStateNormal];
    self.btnScanBoxees.enabled = NO;
    
    self.btnConnectBoxee.layer.borderColor = [[UIColor colorWithRed:174.0/255.0 green:254.0/255.0 blue:133.0/255.0 alpha:1.0] CGColor];
    self.btnConnectBoxee.layer.borderWidth = 1.0;
    self.btnConnectBoxee.layer.cornerRadius = 5.0;
    self.btnConnectBoxee.enabled = NO;

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
    self.txtBoxeePort.text = [NSString stringWithFormat:@"%ld", (long)[BoxeeConnection boxeeDefaultPort]];
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
