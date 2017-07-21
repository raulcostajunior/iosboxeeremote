//
//  ConnectionSettingsViewController.h
//
//  Created by Raul Costa Junior on 2/8/16.
//

#import "AppBaseViewController.h"

@interface ConnectionSettingsViewController : AppBaseViewController


// Connection process handlers at the UI level.

-(void) connectingToBoxee;

-(void) cancelledConnectionToBoxee;


// Connection error handlers at the UI level: all the handling logic for those kinds of errors are
// centralized in this ViewController. The ViewControllerRouter takes care of activating this
// ViewController if any error is detected.

-(void) displayFailedToConnectError:(NSError *)error;

-(void) displayLostConnectionError;


@end
