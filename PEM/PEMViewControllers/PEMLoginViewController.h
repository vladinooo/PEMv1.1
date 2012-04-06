//
//  PEMLoginViewController.h
//  PEM
//
//  Created by Vladimir Hartmann on 12/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEMTextFieldValidation.h"
#import "PEMTextFieldSlider.h"
#import "PEMDatabaseAccess.h"
#import "PEMDataCenter.h"
 
@interface PEMLoginViewController : UIViewController

@property (strong, nonatomic) PEMDatabaseAccess *dbAccess;
@property (strong, nonatomic) PEMTextFieldSlider *textFieldSlider;
@property (strong, nonatomic) PEMTextFieldValidation *textFieldValidation;
@property (strong, nonatomic) PEMDataCenter *dataCenter;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;

- (IBAction)goToCreateProfile:(id)sender;

- (IBAction)login:(id)sender;
- (IBAction)autofill:(id)sender;


@end
