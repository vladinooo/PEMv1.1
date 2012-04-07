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
@synthesize horizontalAccuracy = _horizontalAccuracy;
@synthesize altitude = _altitude;
@synthesize filterredAltitude = _filterredAltitude;
@synthesize verticalAccuracy = _verticalAccuracy;
@synthesize distanceTraveled = _distanceTraveled;
@synthesize grade = _grade;
@synthesize speed = _speed;
@synthesize time = _time;
@synthesize vo2 = _vo2;
@synthesize co2 = _co2;
@synthesize stopWatchTimer;
@synthesize calorieTimer;
@synthesize tick;
@synthesize calories = _calories;
@synthesize startTrackingButtonSender;
@synthesize highestSpeed;
@synthesize locationDataObject;
@synthesize locationDataCollection;
@synthesize firstAltitudePoint;
@synthesize basicGPSDataProcessing;



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


// Gather GPS data and send them to perform basic processing.
// This method of CoreLocation framework is executed repeatadly in intervals.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	
    CLLocation *newValidLocation;
    
    // filter possible gps data errors
    newValidLocation = [self getNewValidLocation:newLocation];
    
    // create a starting point
    if (startingPoint == nil) {
        startingPoint = newValidLocation;
    }
	
	// get horizontal accuracy
	locationDataObject.horizontalAccuracy = newValidLocation.horizontalAccuracy;
    _horizontalAccuracy.text = [locationDataObject getFormattedHorizontalAccuracy];
	
    // get altitude - basic
    locationDataObject.altitude = newValidLocation.altitude;
    _altitude.text = [locationDataObject getFormattedAltitude];
    
    // get filterred altitude - every 10m
	// set the initial location for altitude point
    if (firstAltitudePoint == nil) {
        firstAltitudePoint = newValidLocation;
    }
    CLLocation *secondAltitudePoint = newValidLocation;
    if ([secondAltitudePoint distanceFromLocation: firstAltitudePoint] >= 10) {
        locationDataObject.filterredAltitude = secondAltitudePoint.altitude;
        _filterredAltitude.text = [locationDataObject getFormattedFilterredAltitude];
        firstAltitudePoint = secondAltitudePoint;
    }
	
	// get vertical accuracy
    locationDataObject.verticalAccuracy = newValidLocation.verticalAccuracy;
    _verticalAccuracy.text = [locationDataObject getFormattedVerticalAccuracy];
    
    // get speed in m/s and convert to km/h
    locationDataObject.speed = newValidLocation.speed * 3.6;
    _speed.text = [locationDataObject getFormattedSpeed];
    
    // capture highest speed to show later in session details
    highestSpeed = [basicGPSDataProcessing createHighestSpeed:highestSpeed:locationDataObject.speed];
    
    // calculate total distance only when the speed exceeds 2.5 km/h
    // this filters out calculating distance from non-accurate GPS data
    // when user is not moving
    if (locationDataObject.speed > 2.5) {
        totalDistance =
        [basicGPSDataProcessing calculateTotalDistance:startingPoint:newValidLocation];
    }
    
    // Only output distance if more than 0. This filters out some GPS invalid data
    // in the initial satelite search on launch.
    if (totalDistance > 0) {
        locationDataObject.distanceTravelled = totalDistance;
        _distanceTraveled.text = [locationDataObject getFormattedDistanceTravelled];
        startingPoint = newValidLocation;
    }

    // calculate grade
    locationDataObject.grade =
    [basicGPSDataProcessing calculateGrade:firstAltitudePoint.altitude :secondAltitudePoint.altitude];
    _grade.text = [locationDataObject getFormattedGrade];
    
    
    // calculate vo2
    
    
    // calculate co2
    
    
    // store location data to plist for testing and filtering purposes
    [locationDataCollection saveLocationData:locationDataObject];
	
}



// Basic-naive calorie expenditure calculation (for testing only)
- (void)calculateCalorieExpenditure {
    PEMProfile *tempProfile = dataCenter.profile;
    double distance = [_distanceTraveled.text doubleValue] * 0.000621;
    double burnedCalories = [[tempProfile valueForKey:@"bodyWeight"] doubleValue] * 0.53 * distance;
    _calories.text = [NSString stringWithFormat:@"%.2g", burnedCalories];
}


// GPS location data filter
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


// GPS location data filter (helper method)
- (void)getNewLocation {
    // getting valid location
    [self stopTracking];
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


// pause gps tracking and timer
- (IBAction)pauseTracking:(id)sender {
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
                     cancelButtonTitle:@"No"
                     otherButtonTitles:@"Yes", nil];
    
    resetSessionAlert.tag = 2;
    [resetSessionAlert show]; 
}


// stop and reset gps tracking and timer
- (void)stopTracking {
    [self pauseTracking:startTrackingButtonSender];
    
    // reseting total distance
    totalDistance = 0;
    
    [self resetLabels];
    [self resetTimer];
}


- (void)resetLabels {
	_horizontalAccuracy.text = @"0.00";
	_altitude.text = @"0.00";
    _filterredAltitude.text = @"0.00";
	_verticalAccuracy.text = @"0.00";
	_distanceTraveled.text = @"0.00";
	_speed.text = @"0.00 km/h";
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
                [self stopTracking];
            }
            
            // Save button
            if (buttonIndex == 1) {
                [self captureSessionData];
                [self stopTracking];
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
    tempSession.distance = _distanceTraveled.text;
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
	self.horizontalAccuracy = nil;
	self.altitude = nil;
	self.verticalAccuracy = nil;
	self.distanceTraveled = nil;
	self.speed = nil;
    self.time = nil;
    self.calories = nil;
    self.filterredAltitude = nil;
    self.vo2 = nil;
    self.co2 = nil;
    self.grade = nil;
    self.filterredAltitude = nil;
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
