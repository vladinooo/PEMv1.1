//
//  PEMSaveSessionViewController.h
//  PEM
//
//  Created by Vladimir Hartmann on 06/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMTrackingViewController.h"
#import "PEMDataCenter.h"
#import "PEMDatabaseAccess.h"
#import "PEMSessionDetailsViewController.h"

@interface PEMSaveSessionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (weak, nonatomic) IBOutlet UITextField *sessionName;


- (IBAction)saveSession:(id)sender;
- (IBAction)cancelSaveSession:(id)sender;

@end
