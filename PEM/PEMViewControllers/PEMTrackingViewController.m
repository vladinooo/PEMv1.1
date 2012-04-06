//
//  PEMFirstViewController.m
//  PEM
//
//  Created by Vladimir Hartmann on 12/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMTrackingViewController.h"

@implementation PEMTrackingViewController

@synthesize dataCenter;
@synthesize dbAccess;
@synthesize locationManager;
@synthesize startingPoint;
@synthesize totalDistance;
@synthesize mapView;
@synthesize trackingGPS;
@synthesize calculationDelay;
@synthesize latitudeLabel = _latitudeLabel;
@synthesize longitudeLabel = _longitudeLabel;
@synthesize horizontalAccuracyLabel = _horizontalAccuracyLabel;
@synthesize altitudeLabel = _altitudeLabel;
@synthesize altitudeFilterredLabel = _altitudeFilterredLabel;
@synthesize verticalAccuracyLabel = _verticalAccuracyLabel;
@synthesize distanceTraveledLabel = _distanceTraveledLabel;
@synthesize speedLabel = _speedLabel;
@synthesize time = _time;
@synthesize stopWatchTimer;
@synthesize calorieTimer;
@synthesize tick;
@synthesize calories = _calories;
@synthesize startTrackingButtonSender;
@synthesize highestSpeed;
@synthesize locationDataObject;
@synthesize locationDataCollection;
@synthesize firstAltitudePoint;



// start gps tracking and timer
- (IBAction)startTracking:(id)sender {
    
    // capturing the sender for reuse
    startTrackingButtonSender = sender;
    
    if (trackingGPS) {
        return;
    }
    
    else if (![self isReadyToCalculateCalorieExpenditure]) {
        [self notifyAboutMissingInfo];
    }
    
    else {
        // zoom in to user current location
        [self zoomInToUserLocation];
        
        [locationManager startUpdatingLocation];
        mapView.showsUserLocation = YES;
        
        [self startTimer];
        trackingGPS = TRUE;
        
        calorieTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(calculateCalorieExpenditure) userInfo:nil repeats:YES];
        
    }
}


// get GPS data
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	
    CLLocation *newValidLocation;
    
    newValidLocation = [self getNewValidLocation:newLocation];
    
    // create a starting point
    if (startingPoint == nil) {
        startingPoint = newValidLocation;
    }
	
	// get latitude
	NSString *latitudeString = [[NSString alloc] initWithFormat:@"%g\u00B0", newValidLocation.coordinate.latitude];
	_latitudeLabel.text = latitudeString;
	
	// get longitude
	NSString *longitudeString = [[NSString alloc] initWithFormat:@"%g\u00B0", newValidLocation.coordinate.longitude];
	_longitudeLabel.text = longitudeString;
	
	// get horizontal accuracy
	NSString *horizontalAccuracyString = [[NSString alloc] initWithFormat:@"%gm", newValidLocation.horizontalAccuracy];
	_horizontalAccuracyLabel.text = horizontalAccuracyString;
	
    // get altitude
    NSString *altitudeString = [[NSString alloc] initWithFormat:@"%.2lf", newValidLocation.altitude];
    _altitudeLabel.text = altitudeString;
    
	// set the initial location for altitude point
    if (firstAltitudePoint == nil) {
        firstAltitudePoint = newValidLocation;
    }
    
    // set current altitude point
    double secondAltitudePoint = newValidLocation.altitude;
    // every 10m release the altitude
    if ([newValidLocation distanceFromLocation: firstAltitudePoint] >= 10) {
        NSString *altitudeFilterredString = [[NSString alloc] initWithFormat:@"%.2lf", secondAltitudePoint];
        _altitudeFilterredLabel.text = altitudeFilterredString;
        firstAltitudePoint = newValidLocation;
    }
	
	// get vertical accuracy
	NSString *verticalAccuracyString = [[NSString alloc] initWithFormat:@"%.2lf", newValidLocation.verticalAccuracy];
	_verticalAccuracyLabel.text = verticalAccuracyString;
    
    // get speed in m/s and conver to km/h
    double speed = newValidLocation.speed * 3.6;
    
    [self highestSpeed:speed];
    
    NSString *km =@" km/h";
    if(speed >= 0) {
        NSString *speedString = [[NSString alloc] initWithFormat:@"%.2lf%@",speed,km];
        _speedLabel.text = speedString;
    }	
    
    // calculate total distance only when the speed exceeds 2.5 km/h
    // this filters out calculating distance from non-accurate GPS data
    // when user is not moving
    if (speed > 2.5) {
        [self calculateTotalDistance:newLocation];
    }
    
    // create locationData object (for testing only)
    locationDataObject.altitude = _altitudeLabel.text;
    locationDataObject.verticalAccuracy = _verticalAccuracyLabel.text;
    locationDataObject.distanceTravelled = _distanceTraveledLabel.text;
    locationDataObject.speed = _speedLabel.text;
    
    
    
    // store location data to plist for testing and filtering purposes
    [locationDataCollection startSavingLocationData:locationDataObject];
	
}


-(void)filterLatitude:(NSString *)verticalAccuracy:(CLLocation *)newValidLocation:(CLLocation *)oldLocation {

    
}


// calculate total distance
- (void)calculateTotalDistance:(CLLocation *)newLocation {
    
    // filter bad locations
    CLLocation *newValidLocation = [self getNewValidLocation:newLocation];
    
    totalDistance += [newValidLocation distanceFromLocation:startingPoint];
    
    if (totalDistance > 0) {
        
        NSString *distanceString = [[NSString alloc] initWithFormat:@"%.2lf", totalDistance];
        _distanceTraveledLabel.text = distanceString;
        startingPoint = newValidLocation;
    }
    
}

// store the highest speed traveled to show in session details once finished tracking
- (void)highestSpeed:(double)speed {
    if(speed > highestSpeed) {
        highestSpeed = speed;
    }
}


// Basic-naive calorie expenditure calculation
- (void)calculateCalorieExpenditure {
    PEMProfile *tempProfile = dataCenter.profile;
    double distance = [_distanceTraveledLabel.text doubleValue] * 0.000621;
    double burnedCalories = [[tempProfile valueForKey:@"bodyWeight"] doubleValue] * 0.53 * distance;
    _calories.text = [NSString stringWithFormat:@"%.2g", burnedCalories];
}


// Core Location filter
- (CLLocation *)getNewValidLocation:(CLLocation *)newLocation {
    
    // filter out nil locations
    if (!newLocation){
        [self getNewLocation];
    }
    
    // filter out points by invalid accuracy
    if (newLocation.horizontalAccuracy < 0){
        [self getNewLocation];
    }
    
    // ignore cached value
    NSTimeInterval timeSinceLastUpdate = [[newLocation timestamp] timeIntervalSinceNow];
    
    // If the information is older than a minute, or two minutes, or whatever
    // you want based on expected average speed and desired accuracy, 
    // don't use it.
    if(timeSinceLastUpdate < -5) {
        [self getNewLocation];
    }
    
    // newLocation is good to use
    return newLocation;
} 


// Core Location filter - get new location helper method
- (void)getNewLocation {
    
    // getting valid location
    [self stopTracking:startTrackingButtonSender];
    [self resetTracking];
    [self startTracking:startTrackingButtonSender];
}


// notify about possible GPS errors
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	
	NSString *errorType = (error.code == kCLErrorDenied) ?
	@"Acces Denied" : @"Unknown Error";
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting location"
													message: errorType
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}


// zoom map in to user's location
- (void)zoomInToUserLocation {
    [self.mapView.userLocation addObserver:self 
                                forKeyPath:@"location" 
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) 
                                   context:nil];    
}


// Listen to change in the userLocation
// keep following the user location
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:
(NSDictionary *)change context:(void *)context {  
    
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;  
    
    MKCoordinateSpan span; 
    span.latitudeDelta  = 0.001; // Change these values to change the zoom
    span.longitudeDelta = 0.001; 
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
}


// stop gps tracking and timer
- (IBAction)stopTracking:(id)sender {
	[locationManager stopUpdatingLocation];
    [self stopTimer];
    trackingGPS = FALSE;
}

// ask to save the session
- (IBAction)saveSessionAlert:(id)sender {
    UIAlertView *resetSessionAlert =
    [[UIAlertView alloc] initWithTitle:@"Save the session?" 
                               message:nil
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"OK", nil];
    
    resetSessionAlert.tag = 2;
    [resetSessionAlert show]; 
}


// reset gps tracking and timer
- (void)resetTracking {
	[locationManager stopUpdatingLocation];
    
    [self resetLabels];
    
    // reseting total distance
    totalDistance = 0;
    
    [self stopTimer];
    [self resetTimer];
    trackingGPS = FALSE;
}


- (void)resetLabels {
    _latitudeLabel.text = @"0.00";
	_longitudeLabel.text = @"0.00";
	_horizontalAccuracyLabel.text = @"0.00";
	_altitudeLabel.text = @"0.00";
	_verticalAccuracyLabel.text = @"0.00";
	_distanceTraveledLabel.text = @"0.00";
	_speedLabel.text = @"0 km/h";
    _time.text = @"00:00:00";
    _calories.text = @"0";
}


// start timer
- (void)startTimer {
    stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES]; 
}

// stop timer
- (void)stopTimer {
    [stopWatchTimer invalidate];
}

// reset timer
- (void)resetTimer {
    int hours, minutes, seconds;
    
    tick = 0;
    hours = 0;
    minutes = 0;
    seconds = 0;
    
    _time.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

// update timer
- (void)updateTimer {
    int hours, minutes, seconds;
    tick++;
    hours = tick / 3600;
    minutes = (tick % 3600) / 60;
    seconds = (tick %3600) % 60;
    _time.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}


// check if body weight exists
- (BOOL)isReadyToCalculateCalorieExpenditure {
    PEMProfile *tempProfile = dataCenter.profile;
    if ([[tempProfile valueForKey:@"bodyWeight"] isEqualToString:@"Select body weight"]) {
        
        return FALSE;
    }
    
    else
        return TRUE;
}


// Missing body weight alert
- (void)notifyAboutMissingInfo {
    
    // body weight missing alert
    UIAlertView *bodyWeightAlert =
    [[UIAlertView alloc] initWithTitle:@"You have to enter your weight in profile!" 
                               message:nil
                              delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
   
    bodyWeightAlert.tag = 1;
    [bodyWeightAlert show];

}


// alertView delegate method which is launched on alertView button press
// handle actions of all alert views in this view controller
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    switch (alertView.tag) {
            
        case 1:
            
            if (buttonIndex == 0) {
                
                // switch back to the profile view to enter body weight
                // [self performSegueWithIdentifier:@"profileViewSegue" sender:startTrackingButtonSender];
            }
            break;
                
        case 2:
            
            // Cancel button
            if (buttonIndex == 0) {
                [self resetTracking];
            }
            
            // Save button
            if (buttonIndex == 1) {
                [self captureSessionData];
                
                // switch to save session view
                PEMTrackingViewController *trackingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"saveSession"];
                [self.navigationController pushViewController:trackingVC animated:YES];
            }
            break;
            
        default:
            break;
    }
            
}

// capture session
- (void)captureSessionData {
    PEMSession *tempSession = [[PEMSession alloc] init];
    tempSession.date = @"";
    tempSession.sessionName = @"";
    tempSession.modeOfTransport = @"";
    tempSession.caloriesBurned = _calories.text;
    tempSession.distance = _distanceTraveledLabel.text;
    tempSession.time = _time.text;
    tempSession.speed = [NSString stringWithFormat:@"%f", highestSpeed];
    tempSession.cO2Emission = @"";

    // save sessionData to dataCentre for sharing
    dataCenter.session = tempSession;
    NSLog(@"Session calories are: %@", dataCenter.session.caloriesBurned);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
       
    dbAccess = [[PEMDatabaseAccess alloc] init];
    locationDataObject = [[PEMLocationData alloc] init];
    locationDataCollection = [[PEMLocationDataCollection alloc] init];
    
    trackingGPS = FALSE;
    calculationDelay = TRUE;
    
    dataCenter = [PEMDataCenter shareDataCenter];
    
	self.locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	locationManager.distanceFilter = kCLDistanceFilterNone;
    
    
    [self resetLabels];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
    
    self.locationManager = nil;
	self.latitudeLabel = nil;
	self.longitudeLabel = nil;
	self.horizontalAccuracyLabel = nil;
	self.altitudeLabel = nil;
	self.verticalAccuracyLabel = nil;
	self.distanceTraveledLabel = nil;
	self.speedLabel = nil;
    self.time = nil;
    self.altitudeFilterredLabel = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
