//
//  PEMSessionDetailsViewController.h
//  PEM
//
//  Created by Vladimir Hartmann on 06/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface PEMSessionDetailsViewController : UIViewController

@property (strong, nonatomic) NSString *sessionName, *caloriesBurned, *distance, *time, *speed, *co2Emission;
@property (strong, nonatomic) IBOutlet UILabel *sessionNameLabel, *caloriesBurnedLabel, *distanceLabel, *timeLabel, *speedLabel, *co2EmissionLabel;

@end
