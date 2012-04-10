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
#import "PEMMetabolicCalculations.h"
#import "PEMElevationRequest.h"
#import "MBProgressHUD.h"


@interface PEMTrackingViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) PEMDataCenter *dataCenter;
@property (strong, nonatomic) PEMDatabaseAccess *dbAccess;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startingPoint;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL trackingGPS;
@property (nonatomic) BOOL calculationDelay;
@property (weak, nonatomic) IBOutlet UILabel *horizontalAccuracy;
@property (weak, nonatomic) IBOutlet UILabel *elevation;
@property (weak, nonatomic) IBOutlet UILabel *distanceTraveled;
@property (weak, nonatomic) IBOutlet UILabel *grade;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *vo2;
@property (weak, nonatomic) IBOutlet UILabel *co2;
@property (weak, nonatomic) IBOutlet UILabel *calories;
@property (strong, nonatomic) NSTimer *stopWatchTimer;
@property (strong, nonatomic) NSTimer *vo2Timer;
@property (strong, nonatomic) NSTimer *calorieTimer;
@property (nonatomic) int tick;
@property (strong) id startTrackingButtonSender;
@property (nonatomic) double highestSpeed;
@property (strong, nonatomic) PEMLocationDataCollection *locationDataCollection;
@property (strong, nonatomic) PEMLocationData *locationDataObject;
@property (strong, nonatomic) CLLocation *elevationCaptureStartPoint;
@property (strong, nonatomic) PEMMetabolicCalculations *metabolicCalculations;
@property (strong, nonatomic) PEMElevationRequest *elevationRequest;

-(IBAction)startTracking:(id)sender;
-(IBAction)pauseTracking:(id)sender;
-(IBAction)saveSessionAlert:(id)sender;


@end
