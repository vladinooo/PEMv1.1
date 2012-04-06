//
//  PEMActivitiesViewController.m
//  PEM
//
//  Created by Vladimir Hartmann on 27/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMActivitiesViewController.h"


@interface PEMActivitiesViewController ()

@end

@implementation PEMActivitiesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)walk:(id)sender {
    
    PEMTrackingViewController *trackingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tracking"];
    [self.navigationController pushViewController:trackingVC animated:YES];
}

- (IBAction)run:(id)sender {
    
    PEMTrackingViewController *trackingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tracking"];
    [self.navigationController pushViewController:trackingVC animated:YES];

}

- (IBAction)car:(id)sender {
    
    PEMTrackingViewController *trackingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tracking"];
    [self.navigationController pushViewController:trackingVC animated:YES];

}

- (IBAction)bus:(id)sender {
    
    PEMTrackingViewController *trackingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tracking"];
    [self.navigationController pushViewController:trackingVC animated:YES];

}

- (IBAction)train:(id)sender {
    
    PEMTrackingViewController *trackingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tracking"];
    [self.navigationController pushViewController:trackingVC animated:YES];

}
@end
