//
//  PEMFirstViewController.h
//  PEM
//
//  Created by Vladimir Hartmann on 12/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "PEMDataCenter.h"
#import "PEMDatabaseAccess.h"
#import "PEMSaveSessionViewController.h"
#import "PEMProfile.h"
#import "PEMSession.h"
#import "PEMLocationData.h"
#import "PEMLocationDataCollection.h"

@interface PEMTrackingViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) PEMDataCenter *dataCenter;
@property (strong, nonatomic) PEMDatabaseAccess *dbAccess;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startingPoint;
@property (nonatomic) CLLocationDistance totalDistance;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL trackingGPS;
@property (nonatomic) BOOL calculationDelay;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *horizontalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeFilterredLabel;
@property (weak, nonatomic) IBOutlet UILabel *verticalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceTraveledLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) NSTimer *calorieTimer;
@property (nonatomic) int tick;
@property (weak, nonatomic) IBOutlet UILabel *calories;
@property (strong) id startTrackingButtonSender;
@property (nonatomic) double highestSpeed;
@property (strong, nonatomic) PEMLocationDataCollection *locationDataCollection;
@property (strong, nonatomic) PEMLocationData *locationDataObject;
@property (strong, nonatomic) CLLocation *firstAltitudePoint;



- (IBAction)startTracking:(id)sender;
- (IBAction)stopTracking:(id)sender;
- (IBAction)saveSessionAlert:(id)sender;
- (void)resetTracking;

- (void)startTimer;
- (void)stopTimer;
- (void)resetTimer;
- (BOOL)isReadyToCalculateCalorieExpenditure;
- (void)notifyAboutMissingInfo;
- (void)calculateCalorieExpenditure;

- (CLLocation *)getNewValidLocation:(CLLocation *)newLocation;

- (void)calculateTotalDistance:(CLLocation *)newLocation;


- (void)zoomInToUserLocation;

- (void)getNewLocation;

- (void)resetLabels;

- (void)captureSessionData;

- (void)highestSpeed:(double)speed;



@end
