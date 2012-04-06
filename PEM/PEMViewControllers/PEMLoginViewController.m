//
//  PEMLoginViewController.m
//  PEM
//
//  Created by Vladimir Hartmann on 12/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMLoginViewController.h"

@implementation PEMLoginViewController

@synthesize dbAccess;
@synthesize textFieldSlider;
@synthesize textFieldValidation;
@synthesize dataCenter;
@synthesize email = _email;
@synthesize password = _password;
@synthesize statusMessage = _statusMessage;



// Sliding UITextFields around to avoid the keyboard
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textFieldSlider slideUp:self.view:textField];
}


// Animate back again (helper method to textFieldDidBeginEditing:textField method)
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textFieldSlider slideDown:self.view:textField];
}


- (IBAction)login:(id)sender {
    
    // validate email
    if (![textFieldValidation isValidEmail: _email.text]) {
        _statusMessage.text = @"Invalid email";
    }
    
    NSArray *results = [dbAccess fetchSelectedFromDatabase:@"Profile" :@"email == %@" :_email.text];
    
    
    // check if email/user exists
    if ([results count] == 0) {
        _statusMessage.text = @"Profile doesn't exist";
    }
    
    // check if passwords match
    else if (![[[results objectAtIndex:0] valueForKey:@"password"] isEqualToString: _password.text]) {
        _statusMessage.text = @"Invalid password";
        
    } else {
        // save this profile to dataCenter for sharing
        dataCenter.profile = [results objectAtIndex:0];
        
        _statusMessage.text = @"";
        // switch to the profile view
        [self performSegueWithIdentifier:@"goToProfileView" sender:sender];
    }
    
}

- (IBAction)autofill:(id)sender {
    
    [_email setText:@"artmannv@yahoo.co.uk"];
    [_password setText:@"vava"];
}

- (IBAction)goToCreateProfile:(id)sender {
    
    NSArray *results = [dbAccess fetchFromDatabase:@"Profile"];
    
    if ([results count] == 0) {
        // switch to the create profile view
        [self performSegueWithIdentifier:@"goToCreateProfileView" sender:sender];
    }
    else {
        _statusMessage.text = @"Profile already exists.";
    }
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
    
    [super viewDidLoad];
}


- (void)viewDidUnload {
    [self setEmail:nil];
    [self setPassword:nil];
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
