//
//  PEMSaveSessionViewController.m
//  PEM
//
//  Created by Vladimir Hartmann on 06/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMSaveSessionViewController.h"

@implementation PEMSaveSessionViewController

@synthesize statusMessage = _statusMessage;
@synthesize sessionName = _sessionName;



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


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// take data from the dataCenter, create managed object,
// up data in it and store the object in database
- (IBAction)saveSession:(id)sender {
    
    PEMDataCenter *dataCenter = [PEMDataCenter shareDataCenter];
    PEMSession *newSession = dataCenter.session;
    newSession.sessionName = _sessionName.text;
    dataCenter.session = newSession; // save back to dataCenter for app sharing
    
    
    // persist to database
    PEMDatabaseAccess *dbAccess = [[PEMDatabaseAccess alloc] init];
    [dbAccess insertSessionToDatabase:newSession];
    
    _statusMessage.text = @"Session saved successfully";
    
    [self performSelector:@selector(switchBackToActivitiesView) withObject:nil afterDelay: 1];
    
}

- (void)switchBackToActivitiesView {

    // switch back to tracking view
    [self performSegueWithIdentifier:@"fromSaveToActivities" sender:self];
}

- (IBAction)cancelSaveSession:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


// give up first responder status - hide keyboard when done typing
// gets executed on every app's loop
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [theTextField resignFirstResponder];
    
    return YES;
}



@end
