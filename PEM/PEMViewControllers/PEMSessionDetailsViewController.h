//
//  PEMSessionDetailsViewController.h
//  PEM
//
//  Created by Vladimir Hartmann on 06/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMLocationData.h"

@interface PEMSessionDetailsViewController : UIViewController

@property (strong, nonatomic) NSString *sessionNameString;
@property (strong, nonatomic) NSString *dateString;
@property (strong, nonatomic) NSString *activityString;
@property (strong, nonatomic) NSString *distanceTravelledString;
@property (strong, nonatomic) NSString *totalTimeString;
@property (strong, nonatomic) NSString *highestSpeedString;
@property (strong, nonatomic) NSString *averageGradeString;
@property (strong, nonatomic) NSString *vo2String;
@property (strong, nonatomic) NSString *caloriesString;
@property (strong, nonatomic) NSString *caloriesBigString;
@property (strong, nonatomic) NSString *co2EmissionsString;
@property (strong, nonatomic) NSString *co2EmissionsBigString;

@property (weak, nonatomic) IBOutlet UILabel *sessionName;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *activity;
@property (weak, nonatomic) IBOutlet UILabel *distanceTravelled;
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
@property (weak, nonatomic) IBOutlet UILabel *highestSpeed;
@property (weak, nonatomic) IBOutlet UILabel *averageGrade;
@property (weak, nonatomic) IBOutlet UILabel *vo2;
@property (weak, nonatomic) IBOutlet UILabel *calories;
@property (weak, nonatomic) IBOutlet UILabel *co2Emissions;
@property (weak, nonatomic) IBOutlet UILabel *footerInfoTop;
@property (weak, nonatomic) IBOutlet UILabel *footerInfoBody;
@property (weak, nonatomic) IBOutlet UILabel *footerInfoBottom;
@property (strong, nonatomic) PEMLocationData *locationDataObject;
@property (strong, nonatomic) UIImageView *imageView;

@end
