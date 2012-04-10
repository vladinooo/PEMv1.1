//
//  PEMMetabolicCalculations.m
//  PEM
//
//  Created by Vladimir Hartmann on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMMetabolicCalculations.h"

@implementation PEMMetabolicCalculations
@synthesize dataCenter;

- (id) init {
    
    self = [super init];
    
    if (self != nil) {
        
        dataCenter = [PEMDataCenter shareDataCenter];
    }
    
    return self;
}


-(double)calculateWalkingVo2:(PEMLocationData *)locationDataObject {
    
    // walking equation constants
    static double HOR_OXYGEN_COST = 0.1; // oxygen cost of moving horizontally 0.1 mL/kg/m
    static double VER_OXYGEN_COST = 1.8; // oxygen cost of moving vertically 1.8 mL/min/m
    static double RMR = 3.5;             // resting metabolic rate 3.5 mL/kg/min

    double SPEED = locationDataObject.speed * 60; // from m/s to m/min
    double GRADE = 0;                    // grade set to 0 due to iaccurate data received from CoreLocation
    
    // VO2 (mL/kg/min)
    double walkingVo2 = (SPEED * HOR_OXYGEN_COST) + (SPEED * GRADE * VER_OXYGEN_COST) + RMR;
    
    return walkingVo2;
    
}

-(double)calculateCalorieExpenditure:(double)vO2 {

    PEMProfile *profile = dataCenter.profile;
    int BODY_WEIGHT = [profile.bodyWeight intValue] ;
    
    vO2 = vO2 * BODY_WEIGHT; // convert VO2 into mL/min
    vO2 = vO2 / 1000;        // convert VO2 into L/min
    double kcal = vO2 * 5;   // convert VO2 into kcals/min = Calories/min
    return kcal;
}

//// Basic-naive calorie expenditure calculation (for testing only)
//-(double)calculateNaiveCalorieExpenditure:(PEMLocationData *)locationDataObject {
//    PEMProfile *tempProfile = dataCenter.profile;
//    double distance = locationDataObject.distanceTravelled * 0.000621;
//    double burnedCalories = [[tempProfile valueForKey:@"bodyWeight"] doubleValue] * 0.53 * distance;
//    return burnedCalories;
//}


@end
