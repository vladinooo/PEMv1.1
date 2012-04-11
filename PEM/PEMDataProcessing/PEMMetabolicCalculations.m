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

// calculate grade on distance of 20m
-(double)calculateGrade:(double)elevationOne:(double)elevationTwo {
    
    int RUN = 20;
    double rise = elevationTwo - elevationOne;
    double grade = rise / RUN;
    return grade;
}


// calculate average grade
-(double)getAverageGrade:(PEMLocationData *)locationDataObject {
    
    double averageGrade = (locationDataObject.lowestGrade + locationDataObject.highestGrade) / 2;
    
    if (averageGrade < 0) {
        return averageGrade * -1;
    }
    else {
        return averageGrade;
    } 
}


// calculate walking VO2
-(double)calculateWalkingVo2:(PEMLocationData *)locationDataObject {
    
    // walking equation constants
    static double HOR_OXYGEN_COST = 0.1; // oxygen cost of moving horizontally 0.1 mL/kg/m
    static double VER_OXYGEN_COST = 1.8; // oxygen cost of moving vertically 1.8 mL/min/m
    static double RMR = 3.5;             // resting metabolic rate 3.5 mL/kg/min

    double speed = locationDataObject.speed * 60; // from m/s to m/min
    double grade = locationDataObject.averageGrade; // grade
    
    // VO2 (mL/kg/min)
    double walkingVo2 = (speed * HOR_OXYGEN_COST) + (speed * grade * VER_OXYGEN_COST) + RMR;
    
    return walkingVo2;
    
}


// calculate running VO2
-(double)calculateRunningVo2:(PEMLocationData *)locationDataObject {
    
    // running equation constants
    static double HOR_OXYGEN_COST = 0.2; // oxygen cost of moving horizontally 0.2 mL/kg/m
    static double VER_OXYGEN_COST = 0.9; // oxygen cost of moving vertically 0.9 mL/min/m
    static double RMR = 3.5;             // resting metabolic rate 3.5 mL/kg/min
    
    double speed = locationDataObject.speed * 60; // from m/s to m/min
    double grade = locationDataObject.averageGrade; // grade
    
    // VO2 (mL/kg/min)
    double runningVo2 = (speed * HOR_OXYGEN_COST) + (speed * grade * VER_OXYGEN_COST) + RMR;
    
    return runningVo2;
    
}


// calculate driving VO2
-(double)calculateTravelingByCarVo2:(PEMLocationData *)locationDataObject {
    
    static double RMR = 3.5; // resting metabolic rate 3.5 mL/kg/min
    
    // VO2 (mL/kg/min)
    double drivingVo2 = RMR;
    
    return drivingVo2;
}


// calculate traveling by bus VO2
-(double)calculateTravelingByBusVo2:(PEMLocationData *)locationDataObject {
    
    static double RMR = 3.5; // resting metabolic rate 3.5 mL/kg/min
    
    // VO2 (mL/kg/min)
    double travelingByBusVo2 = RMR;
    
    return travelingByBusVo2;
}


// calculate traveling by train VO2
-(double)calculateTravelingByTrainVo2:(PEMLocationData *)locationDataObject {
    
    static double RMR = 3.5; // resting metabolic rate 3.5 mL/kg/min
    
    // VO2 (mL/kg/min)
    double travelingByTrainVo2 = RMR;
    
    return travelingByTrainVo2;
}

// calculate calorie expenditure
-(double)calculateCalorieExpenditure:(double)vO2 {

    PEMProfile *profile = dataCenter.profile;
    int bodyWeight = [profile.bodyWeight intValue] ;
    
    vO2 = vO2 * bodyWeight; // convert VO2 into mL/min
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
