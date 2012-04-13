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
@synthesize horizontalAccuracy = _horizontalAccuracy;
@synthesize elevation = _elevation;
@synthesize distanceTraveled = _distanceTraveled;
@synthesize grade = _grade;
@synthesize speed = _speed;
@synthesize time = _time;
@synthesize vo2 = _vo2;
@synthesize co2Emissions = _co2Emissions;
@synthesize calories = _calories;
@synthesize stopWatchTimer;
@synthesize vo2Timer;
@synthesize co2EmissionsTimer;
@synthesize calorieTimer;
@synthesize tick;
@synthesize startTrackingButtonSender;
@synthesize highestSpeed;
@synthesize locationDataObject;
@synthesize locationDataCollection;
@synthesize elevationCaptureStartPoint;
@synthesize metabolicCalculations;
@synthesize elevationRequest;
@synthesize activity;
@synthesize co2EmissionCalculations;
@synthesize formatter;


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
        
        if ([activity isEqualToString:@"Walk"]) {
            
            // trigger calculating walking VO2 every 1min
            vo2Timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateWalkingVo2) userInfo:nil repeats:YES];
            
            // trigger calculating kcal expenditure every 1min
            calorieTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateCalorieExpenditure) userInfo:nil repeats:YES];
        }
        
        if ([activity isEqualToString:@"Run"]) {
            
            // trigger calculating running VO2 every 1min
            vo2Timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateRunningVo2) userInfo:nil repeats:YES];
            
            // trigger calculating kcal expenditure every 1min
            calorieTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateCalorieExpenditure) userInfo:nil repeats:YES];
        
        }
        
        if ([activity isEqualToString:@"Car"]) {
            
            // trigger calculating traveling by car VO2 every 1min
            vo2Timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateTravelingByCarVo2) userInfo:nil repeats:YES];
            
            // trigger calculating kcal expenditure every 1min
            calorieTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateCalorieExpenditure) userInfo:nil repeats:YES];
            
            // trigger calculating traveling by car co2 Emissions every 1s
            co2EmissionsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callCalculateTravelingByCarCo2Emissions) userInfo:nil repeats:YES];
            
        }
        
        if ([activity isEqualToString:@"Bus"]) {
            
            // trigger calculating traveling by bus VO2 every 1min
            vo2Timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateTravelingByBusVo2) userInfo:nil repeats:YES];
            
            // trigger calculating kcal expenditure every 1min
            calorieTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateCalorieExpenditure) userInfo:nil repeats:YES];
            
            // trigger calculating traveling by bus co2 Emissions every 1s
            co2EmissionsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callCalculateTravelingByBusCo2Emissions) userInfo:nil repeats:YES];
            
        }
        
        if ([activity isEqualToString:@"Train"]) {
            
            // trigger calculating traveling by train VO2 every 1min
            vo2Timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateTravelingByTrainVo2) userInfo:nil repeats:YES];
            
            // trigger calculating kcal expenditure every 1min
            calorieTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(callCalculateCalorieExpenditure) userInfo:nil repeats:YES];
            
            // trigger calculating traveling by train co2 Emissions every 1s
            co2EmissionsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(callCalculateTravelingByTrainCo2Emissions) userInfo:nil repeats:YES];
            
        }
        
    }
}


// Gather GPS data and perform basic processing.
// This method of CoreLocation framework is executed repeatadly in intervals.
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	
    CLLocation *newValidLocation;
    
    // filter possible gps data errors
    newValidLocation = [self getNewValidLocation:newLocation];
    
    
    // only start GPS tracking if horizontal accuracy is < 10m
    if (newValidLocation.horizontalAccuracy > 10) {
    
        // Start activity indicator animation
        [self progressHUDWheelStart];
    }
    
    else {
        
        // Stop activity indicator animation
        [self progressHUDWheelStop];
        
        // create a starting point for distance calculation
        if (startingPoint == nil) {
            startingPoint = newValidLocation;
        }
            
        // get horizontal accuracy
        locationDataObject.horizontalAccuracy = newValidLocation.horizontalAccuracy;
        _horizontalAccuracy.text = [locationDataObject getFormattedHorizontalAccuracy];
        
        // get elevation (altitude) - inaccurate, captured by CoreLocation, only for testing
        locationDataObject.altitude = newValidLocation.altitude;
        
        // get vertical accuracy
        locationDataObject.verticalAccuracy = newValidLocation.verticalAccuracy;
        
        // get accurate elevation (altitude) from Google Maps - every 20m
        // set the initial location for elevation point
        if (elevationCaptureStartPoint == nil) {
            
            elevationCaptureStartPoint = newValidLocation;
            
            dispatch_queue_t myQueue1 = dispatch_queue_create("pem.myQueue1", 0);
            dispatch_async(myQueue1, ^{
                
                [elevationRequest requestElevation:elevationCaptureStartPoint.coordinate.latitude :elevationCaptureStartPoint.coordinate.longitude];
                
                while (!elevationRequest.isDownloaded) {
                    _elevation.text = @"Receiving...";
                    NSLog(@"Receiving..");
                }
                                            
                locationDataObject.elevationOne = elevationRequest.elevation;
                elevationRequest.isDownloaded = false;
                
                _elevation.text = [locationDataObject getFormattedElevationOne];
                
                NSLog(@"ElevationOne is %f", locationDataObject.elevationOne);
                
            });

            
        }
        
        CLLocation *elevationCaptureFinishPoint = newValidLocation;
        if ([elevationCaptureFinishPoint distanceFromLocation: elevationCaptureStartPoint] >= 20) {
            
            dispatch_queue_t myQueue2 = dispatch_queue_create("pem.myQueue2", 0);
            dispatch_async(myQueue2, ^{
                
                [elevationRequest requestElevation:elevationCaptureFinishPoint.coordinate.latitude :elevationCaptureFinishPoint.coordinate.longitude];

                while (!elevationRequest.isDownloaded) {
                    _elevation.text = @"Receiving...";
                    NSLog(@"Receiving..");
                }
                
                locationDataObject.elevationTwo = elevationRequest.elevation;
                _elevation.text = [locationDataObject getFormattedElevationTwo];
                
                elevationRequest.isDownloaded = false;

                
                // calculate grade on distance of 20m
                locationDataObject.grade = [metabolicCalculations calculateGrade:locationDataObject.elevationOne :locationDataObject.elevationTwo];
                
                // output current grade calculation
                _grade.text = [locationDataObject getFormattedGrade];
                
                
                // capture lowest grade
                if(locationDataObject.grade < locationDataObject.lowestGrade) {
                    locationDataObject.lowestGrade = locationDataObject.grade;
                }
                
                // capture highest grade
                if(locationDataObject.grade > locationDataObject.highestGrade) {
                    locationDataObject.highestGrade = locationDataObject.grade;
                }
                
                // calculate average grade
                locationDataObject.averageGrade = [metabolicCalculations getAverageGrade:locationDataObject];
                
                // update elevationCaptureStartPoint
                elevationCaptureStartPoint = elevationCaptureFinishPoint;
                locationDataObject.elevationOne = locationDataObject.elevationTwo;
            
                NSLog(@"ElevationTwo is %f", locationDataObject.elevationTwo);

            });
            
            
        }
        
        
        // save speed in m/s
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
            // filter possible gps data errors
            newValidLocation = [self getNewValidLocation:newLocation];
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


-(void)callCalculateWalkingVo2 {
    // calculate walking vo2
    locationDataObject.vo2 += [metabolicCalculations calculateWalkingVo2:locationDataObject];
    _vo2.text = [locationDataObject getFormattedVo2];
}

-(void)callCalculateRunningVo2 {
    // calculate running vo2
    locationDataObject.vo2 += [metabolicCalculations calculateRunningVo2:locationDataObject];
    _vo2.text = [locationDataObject getFormattedVo2];
}

-(void)callCalculateTravelingByCarVo2 {
    // calculate driving vo2
    locationDataObject.vo2 += [metabolicCalculations calculateTravelingByCarVo2:locationDataObject];
    _vo2.text = [locationDataObject getFormattedVo2];
}

-(void)callCalculateTravelingByBusVo2 {
    // calculate traveling by bus vo2
    locationDataObject.vo2 += [metabolicCalculations calculateTravelingByBusVo2:locationDataObject];
    _vo2.text = [locationDataObject getFormattedVo2];
}

-(void)callCalculateTravelingByTrainVo2 {
    // calculate traveling by train vo2
    locationDataObject.vo2 += [metabolicCalculations calculateTravelingByTrainVo2:locationDataObject];
    _vo2.text = [locationDataObject getFormattedVo2];
}

-(void)callCalculateCalorieExpenditure {
    // calculate calories (Do not acccumulate as vo2 is accumulated already!)
    locationDataObject.calories = [metabolicCalculations calculateCalorieExpenditure:locationDataObject.vo2];
    _calories.text = [locationDataObject getFormattedCalories];
}

-(void)callCalculateTravelingByCarCo2Emissions {
    // calculate traveling by car co2 emissions
    locationDataObject.co2emissions += [co2EmissionCalculations calculateTravelingByCarCo2emissions:locationDataObject];
    _co2Emissions.text = [locationDataObject getFormattedco2Emissions];
}

-(void)callCalculateTravelingByBusCo2Emissions {
    // calculate traveling by bus co2 emissions
    locationDataObject.co2emissions += [co2EmissionCalculations calculateTravelingByBusCo2emissions:locationDataObject];
    _co2Emissions.text = [locationDataObject getFormattedco2Emissions];
}

-(void)callCalculateTravelingByTrainCo2Emissions {
    // calculate traveling by train co2 emissions
    locationDataObject.co2emissions += [co2EmissionCalculations calculateTravelingByTrainCo2emissions:locationDataObject];
    _co2Emissions.text = [locationDataObject getFormattedco2Emissions];
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
    [co2EmissionsTimer invalidate];
    trackingGPS = FALSE;
}

// ask to save the session
- (IBAction)saveSessionAlert:(id)sender {
    UIAlertView *resetSessionAlert =
    [[UIAlertView alloc] initWithTitle:@"Save the session?" 
                               message:nil
                              delegate:self
                     cancelButtonTitle:@"Cancel"
                     otherButtonTitles:@"Yes", nil];
    
    resetSessionAlert.tag = 1;
    [resetSessionAlert show]; 
}


// stop and reset gps tracking and timer
- (void)stopTracking {
    [self pauseTracking:startTrackingButtonSender];
    
    [vo2Timer invalidate];
    [calorieTimer invalidate];
    [co2EmissionsTimer invalidate];
    
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
    locationDataObject.co2emissions = 0;
    locationDataObject.totalTimeString = 0;
    locationDataObject.calories = 0;
    elevationCaptureStartPoint = nil;

    
    [self resetLabels];
    [self resetTimer];
}


- (void)resetLabels {
	_horizontalAccuracy.text = @"0.00 m";
	_elevation.text = @"0.00 m";
	_distanceTraveled.text = @"0.00 m";
	_speed.text = @"0.00 km/h";
    _grade.text = @"0.00 %";
    _time.text = @"00:00:00";
    _vo2.text = @"0.00 mL/kg";
    _co2Emissions.text = @"0.00 kgCO2";
    _calories.text = @"0.00 kcal";
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
    locationDataObject.totalTimeString = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    _time.text = locationDataObject.totalTimeString;
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
   
    [bodyWeightAlert show];

}


// alertView delegate method which is launched on alertView button press
// handle actions of all alert views in this view controller
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    switch (alertView.tag) {
            
        case 1:    
            
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
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MMM-yyyy HH:mm"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    tempSession.sessionName = @"";
    tempSession.date = dateString;
    tempSession.activity = activity;
    tempSession.distanceTravelled = [locationDataObject getFormattedDistanceTravelled];
    tempSession.totalTime = [locationDataObject getFormattedTotalTime];
    NSString *highestSpeedString = [[NSString alloc] initWithFormat:@"%.2lf%@", highestSpeed, @" km/h"];
    tempSession.highestSpeed = highestSpeedString;
    tempSession.averageGrade = [locationDataObject getFormattedAverageGrade];
    tempSession.vo2 = [locationDataObject getFormattedVo2];
    tempSession.calories = [locationDataObject getFormattedCaloriesPure];
    tempSession.co2Emissions = [locationDataObject getFormattedco2EmissionsPure];

    // save sessionData to dataCentre for sharing
    dataCenter.session = tempSession;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    // set title
    NSString *title = [[NSString alloc] initWithFormat:@"Tracking - %@", activity];
    [self setTitle:title];
    
    dbAccess = [[PEMDatabaseAccess alloc] init];
    locationDataObject = [[PEMLocationData alloc] init];
    locationDataCollection = [[PEMLocationDataCollection alloc] init];
    metabolicCalculations = [[PEMMetabolicCalculations alloc] init];
    elevationRequest = [[PEMElevationRequest alloc] init];
    co2EmissionCalculations = [[PEMCO2EmissionCalculations alloc] init];
    
    trackingGPS = FALSE;
    
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
    self.mapView = nil;
    self.locationManager = nil;
	self.horizontalAccuracy = nil;
	self.elevation = nil;
	self.distanceTraveled = nil;
	self.speed = nil;
    self.time = nil;
    self.calories = nil;
    self.vo2 = nil;
    self.co2Emissions = nil;
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
