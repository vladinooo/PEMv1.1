//
//  PEMProfileViewController.h
//  PEM
//
//  Created by Vladimir Hartmann on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMDatabaseAccess.h"
#import "PEMDataCenter.h"
#import "PEMTextFieldSlider.h"
#import "PEMTextFieldValidation.h"
#import "PEMAppDelegate.h"
#import "PEMDataTransfer.h"
#import "MBProgressHUD.h"

@interface PEMProfileViewController : UIViewController <UIActionSheetDelegate,
                                        UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) PEMDatabaseAccess *dbAccess;
@property (strong, nonatomic) PEMTextFieldValidation *textFieldValidation;
@property (strong, nonatomic) PEMTextFieldSlider *textFieldSlider;
@property (strong, nonatomic) PEMDataCenter *dataCenter;
@property(strong, nonatomic) PEMDataTransfer *dataTransfer;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *re_password;
@property (weak, nonatomic) IBOutlet UILabel *statusMessage;
@property (weak, nonatomic) IBOutlet UIPickerView *bodyWeightPicker;
@property (strong, nonatomic) NSMutableArray *bodyWeightPickerArray;
@property (strong, nonatomic) NSString *choice;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *bodyWeightButton;



- (IBAction)showOptions:(id)sender;
- (IBAction)selectBodyWeight:(id)sender;
-(void)progressHUDWheelStart;
-(void)progressHUDWheelStop;







@end
