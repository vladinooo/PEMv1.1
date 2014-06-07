//
//  PEMProfileViewController.m
//  PEM
//
//  Created by Vladimir Hartmann on 14/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMProfileViewController.h"

@implementation PEMProfileViewController

@synthesize dbAccess;
@synthesize textFieldValidation;
@synthesize textFieldSlider;
@synthesize dataCenter;
@synthesize dataTransfer;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize email = _email;
@synthesize password = _password;
@synthesize re_password = _re_password;
@synthesize statusMessage = _statusMessage;
@synthesize bodyWeightPicker = _bodyWeightPicker;
@synthesize bodyWeightPickerArray;
@synthesize choice;
@synthesize scrollView;
@synthesize bodyWeightButton;



// Sliding UITextFields around to avoid the keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textFieldSlider slideUp:self.view:textField];
}


// Animate back again
// call updateProfileData method to save data to database on each exit from textfield
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textFieldSlider slideDown:self.view:textField];
    [self updateProfileData: textField];
}


// load profile data from database
- (void)loadProfileData {
    
    PEMProfile *tempProfile = dataCenter.profile;
    
    [_firstName setText: [tempProfile valueForKey:@"firstName"]];
    [_lastName setText:[tempProfile valueForKey:@"lastName"]];
    [_email setText: [tempProfile valueForKey:@"email"]];
    [_password setText: [tempProfile valueForKey:@"password"]];
    [_re_password setText: [tempProfile valueForKey:@"password"]];
    
    if (![[tempProfile valueForKey:@"bodyWeight"] isEqualToString:@""]) {
        
        [bodyWeightButton setTitle:[tempProfile valueForKey:@"bodyWeight"] forState:UIControlStateNormal];
    }
    
}



// create actionsheet
- (IBAction)showOptions:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Upload Profile", @"Log Out", nil];
    actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}


// handle actionsheet buttons
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: {
            // Begin data transfer         
            dataTransfer.profileViewControllerDelegate = self;
            [dataTransfer transferDataToPemWebApp:dataCenter.profile.email: dataTransfer];
            
            break;
        }
            
        case 1:
            // switch to the login view
            [self logout];
            break;
            
        default:
            break;
    }
    
}



-(void)progressHUDWheelStart {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Uploading...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{});
}

-(void)progressHUDWheelStop {
    dispatch_async(dispatch_get_main_queue(),
                   ^{[MBProgressHUD hideHUDForView:self.view animated:YES];});
}

// change to login view
- (void)logout {
    [self performSegueWithIdentifier:@"goToLoginView" sender:self];
}


// slide picker view
- (IBAction)selectBodyWeight:(id)sender {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.6];
    CGAffineTransform transfrom = CGAffineTransformMakeTranslation(0, 720);
    _bodyWeightPicker.transform = transfrom;
    _bodyWeightPicker.alpha = _bodyWeightPicker.alpha * (-1) + 1;
    [UIView commitAnimations];    
    
    NSInteger row = [_bodyWeightPicker selectedRowInComponent:0];
    choice = [bodyWeightPickerArray objectAtIndex:row];
    
    [bodyWeightButton setTitle:choice forState:UIControlStateNormal];
    
    PEMProfile *tempProfile = dataCenter.profile;
    [tempProfile setValue:choice forKey:@"bodyWeight"];
    
    // save profile changes to dataCenter for sharing
    dataCenter.profile = tempProfile;
    
    // save to database
    [dbAccess saveChangesToPersistentStore];
    
}


// weight picker view helper method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// weight picker view helper method
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [bodyWeightPickerArray count];
}

// weight picker view helper method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [bodyWeightPickerArray objectAtIndex:row];
}


// update managed object and save to database
- (void)updateProfileData: (UITextField *)theTextField {
    
    PEMProfile *tempProfile = dataCenter.profile;
    
    if (theTextField == _firstName) {
        [tempProfile setValue:_firstName.text forKey:@"firstName"];        
    }
    
    else if (theTextField == _lastName) {
        [tempProfile setValue:_lastName.text forKey:@"lastName"];
    }
    
    else if (theTextField == _email) {
        [tempProfile setValue:_email.text forKey:@"email"];
    }
    
    else if (theTextField == _password) {
        if([textFieldValidation doPasswordsMatch:_password :_re_password]) {
            [tempProfile setValue:_password.text forKey:@"password"];
            _statusMessage.text = @"";
        }
        
        else {
            _statusMessage.text = @"Must match!"; //Passwords don't match
            [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
    
    else if (theTextField == _re_password) {
        if([textFieldValidation doPasswordsMatch:_password :_re_password]) {
            [tempProfile setValue:_password.text forKey:@"password"];
            _statusMessage.text = @"";
        }
        
        else {
            _statusMessage.text = @"Must match!"; //Passwords don't match
            [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
    
    
    // save to database
    [dbAccess saveChangesToPersistentStore];
}


// give up first responder status - hide keyboard when done typing
// gets executed on every app's loop
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];    
    return YES;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    dbAccess = [[PEMDatabaseAccess alloc] init];
    textFieldSlider = [[PEMTextFieldSlider alloc] init];
    textFieldValidation = [[PEMTextFieldValidation alloc] init];
    dataCenter = [PEMDataCenter shareDataCenter];
    dataTransfer = [[PEMDataTransfer alloc] init];
    
    // scroll view size
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 700)];
    
    
    // initialize the picker view array with weight
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for ( int i = 40; i <= 200; ++i ) {
        NSString *weight = [NSString stringWithFormat:@"%d",i];
        NSString *kg = @"kg";
        NSString *totalWeight = [NSString stringWithFormat:@"%@ %@",weight,kg];
        
        [values addObject:[NSString stringWithString:totalWeight]];
    }
    self.bodyWeightPickerArray = values;
    
    
    // set bodyWeightPicker invisible
    _bodyWeightPicker.alpha = 0;
    
    
    [self loadProfileData];
    [super viewDidLoad];
}


- (void)viewDidUnload {
    [self setFirstName:nil];
    [self setLastName:nil];
    [self setEmail:nil];
    [self setPassword:nil];
    [self setRe_password:nil];
    [self setStatusMessage:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
