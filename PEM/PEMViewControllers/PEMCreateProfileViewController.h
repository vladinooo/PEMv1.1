//
//  PEMCreateProfileViewController.h
//  PEM
//
//  Created by Vladimir Hartmann on 12/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMAppDelegate.h"
#import "PEMTextFieldValidation.h"
#import "PEMDatabaseAccess.h"
#import "PEMTextFieldSlider.h"
#import "PEMProfile.h"

@interface PEMCreateProfileViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) PEMDatabaseAccess *dbAccess;
@property (strong, nonatomic) PEMDataCenter *dataCenter;
@property (strong, nonatomic) PEMTextFieldSlider *textFieldSlider;
@property (strong, nonatomic) PEMTextFieldValidation *textFieldValidation;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *re_password;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (strong) id creatProfileButtonSender;


- (IBAction)createProfile:(id)sender;
- (IBAction)autofill:(id)sender;

@end
