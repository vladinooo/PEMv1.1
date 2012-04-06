//
//  PEMSessionDetailsViewController.m
//  PEM
//
//  Created by Vladimir Hartmann on 06/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMSessionDetailsViewController.h"

@implementation PEMSessionDetailsViewController

@synthesize sessionName;
@synthesize sessionNameLabel;
@synthesize caloriesBurned;
@synthesize caloriesBurnedLabel;
@synthesize distance;
@synthesize distanceLabel;
@synthesize time;
@synthesize timeLabel;
@synthesize speed;
@synthesize speedLabel;
@synthesize co2Emission;
@synthesize co2EmissionLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    sessionNameLabel.text = sessionName;
    caloriesBurnedLabel.text = caloriesBurned;
    distanceLabel.text = distance;
    timeLabel.text = time;
    speedLabel.text = speed;
    co2EmissionLabel.text = co2Emission;
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
