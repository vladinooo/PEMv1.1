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
@synthesize mapView;
@synthesize trackingGPS;
@synthesize calculationDelay;
@synthesize horizontalAccuracy = _horizontalAccuracy;
@synthesize elevation = _elevation;
@synthesize distanceTraveled = _distanceTraveled;
@synthesize grade = _grade;
@synthesize speed = _speed;
@synthesize time = _time;
@synthesize vo2 = _vo2;
@synthesize co2 = _co2;
@synthesize calories = _calories;
@synthesize stopWatchTimer;
@synthesize vo2Timer;
@synthesize calorieTimer;
@synthesize tick;
@synthesize startTrackingButtonSender;
@synthesize highestSpeed;
@synthesize locationDataObject;
@synthesize locationDataCollection;
@synthesize elevationCaptureStartPoint;
@synthesize metabolicCalculations;
@synthesize elevationRequest;


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
        
        trackingGPS = TRUE;
        
        // start timer
        [self startTimer];
        
        // start calculating VO2
        vo2Timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateWalkingVo2) userInfo:nil repeats:YES];
        
        // start calculating kcal expenditure
        calorieTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateCalorieExpenditure) userInfo:nil repeats:YES];
        
    }
}


// Gather GPS data and perform basic processing.
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
    
    // only start GPS tracking if horizontal accuracy is < 10m
    if (newValidLocation.horizontalAccuracy > 10) {
    
        // Start activity indicator animation
        [self progressHUDWheelStart];
    }
    
    else {
        
        // Stop activity indicator animation
        [self progressHUDWheelStop];
            
        // get horizontal accuracy
        locationDataObject.horizontalAccuracy = newValidLocation.horizontalAccuracy;
        _horizontalAccuracy.text = [locationDataObject getFormattedHorizontalAccuracy];
        
        // get elevation (altitude) - inaccurate, captured by CoreLocation, only for testing
        locationDataObject.altitude = newValidLocation.altitude;
        
        // get vertical accuracy
        locationDataObject.verticalAccuracy = newValidLocation.verticalAccuracy;
        
        // get accurate elevation (altitude) from Google Maps - every 10m
        // set the initial location for elevation point
        if (elevationCaptureStartPoint == nil) {
            
            elevationCaptureStartPoint = newValidLocation;
            
            dispatch_queue_t myQueue1 = dispatch_queue_create("pem.myQueue1", 0);
            dispatch_async(myQueue1, ^{
                
                [elevationRequest requestElevation:elevationCaptureStartPoint.coordinate.latitude :elevationCaptureStartPoint.coordinate.longitude];
                
                while (!elevationRequest.isDownloaded) {
                    NSLog(@"Downloading...");
                }
                                            
                locationDataObject.elevationOne = elevationRequest.elevation;
                elevationRequest.isDownloaded = false;
                
                NSLog(@"ElevationOne is %f", locationDataObject.elevationOne);
                
            });

            
        }
        
        CLLocation *elevationCaptureFinishPoint = newValidLocation;
        if ([elevationCaptureFinishPoint distanceFromLocation: elevationCaptureStartPoint] >= 10) {
            
            dispatch_queue_t myQueue2 = dispatch_queue_create("pem.myQueue2", 0);
            dispatch_async(myQueue2, ^{
                
                [elevationRequest requestElevation:elevationCaptureFinishPoint.coordinate.latitude :elevationCaptureFinishPoint.coordinate.longitude];

                while (!elevationRequest.isDownloaded) {
                    NSLog(@"Downloading...");
                }
                
                locationDataObject.elevationTwo = elevationRequest.elevation;
                _elevation.text = [locationDataObject getFormattedElevationTwo];
                
                elevationRequest.isDownloaded = false;

                
                // calculate grade on distance of 10m
                locationDataObject.grade = [self calculateGrade:locationDataObject.elevationOne :locationDataObject.elevationTwo];
                                
                _grade.text = [locationDataObject getFormattedGrade];
                
                elevationCaptureStartPoint = newValidLocation;
            
                NSLog(@"ElevationTwo is %f", locationDataObject.elevationTwo);

            });
            
            
        }
        
        
        // get speed in m/s
        locationDataObject.speed = newValidLocation.speed;
        _speed.text = [locationDataObject getFormattedSpeed];
        
        // capture highest speed to show later in session details
        if(locationDataObject.speed > highestSpeed) {
            highestSpeed = locationDataObject.speed;
        }
        
        
        // calculate total distance only when the speed exceeds 0.70 m/s or 2.5 km/h
        // this filters out calculating distance from non-accurate GPS data
        // when user is not moving
        if (locationDataObject.speed > 0.70) {
            locationDataObject.distanceTravelled += [newValidLocation distanceFromLocation:startingPoint];
            _distanceTraveled.text = [locationDataObject getFormattedDistanceTravelled];
            startingPoint = newValidLocation;
        }
        
        
        // store location data to plist for testing and filtering purposes
        [locationDataCollection saveLocationData:locationDataObject];
        

    }
    
    
}


// Start activity indicator animation
-(void)progressHUDWheelStart {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Initialising...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{});
}

// Stop activity indicator animation
-(void)progressHUDWheelStop {
    dispatch_async(dispatch_get_main_queue(),
                   ^{[MBProgressHUD hideHUDForView:self.view animated:YES];});
}

// calculate grade on distance of 10m
-(double)calculateGrade:(double)elevationOne:(double)elevationTwo {
    
    double rise = elevationTwo - elevationOne;
    double grade = rise / 10;
    return grade;
}


-(void)callCalculateWalkingVo2 {
    // calculate walking vo2
    locationDataObject.vo2 += [metabolicCalculations calculateWalkingVo2:locationDataObject];
    _vo2.text = [locationDataObject getFormattedVo2];
}


-(void)callCalculateCalorieExpenditure {
    // calculate calories
    locationDataObject.calories += [metabolicCalculations calculateCalorieExpenditure:locationDataObject.vo2];
    _calories.text = [locationDataObject getFormattedCalories];
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
    [vo2Timer invalidate];
    [calorieTimer invalidate];
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
    
    [vo2Timer invalidate];
    [calorieTimer invalidate];
    
    // reseting total distance
    locationDataObject.horizontalAccuracy = 0;
    locationDataObject.altitude = 0;
    locationDataObject.elevationOne = 0;
    locationDataObject.elevationTwo = 0;
    locationDataObject.verticalAccuracy = 0;
    locationDataObject.distanceTravelled = 0;
    locationDataObject.speed = 0;
    locationDataObject.grade = 0;
    locationDataObject.vo2 = 0;
    locationDataObject.timeString = 0;
    locationDataObject.calories = 0;
    elevationCaptureStartPoint = nil;

    
    [self resetLabels];
    [self resetTimer];
}


- (void)resetLabels {
	_horizontalAccuracy.text = @"0.00";
	_elevation.text = @"0.00";
	_distanceTraveled.text = @"0.00";
	_speed.text = @"0.00 km/h";
    _grade.text = @"0.00";
    _time.text = @"00:00:00";
    _vo2.text = @"0.00";
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
    locationDataObject.timeString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    _time.text = locationDataObject.timeString;
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
    metabolicCalculations = [[PEMMetabolicCalculations alloc] init];
    elevationRequest = [[PEMElevationRequest alloc] init];
    
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
	self.elevation = nil;
	self.distanceTraveled = nil;
	self.speed = nil;
    self.time = nil;
    self.calories = nil;
    self.vo2 = nil;
    self.co2 = nil;
    self.grade = nil;
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
