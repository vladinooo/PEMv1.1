//
//  PEMLocationData.m
//  PEM
//
//  Created by Vladimir Hartmann on 06/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMLocationData.h"

@implementation PEMLocationData

@synthesize horizontalAccuracy;
@synthesize altitude;
@synthesize elevationOne;
@synthesize elevationTwo;
@synthesize verticalAccuracy;
@synthesize distanceTravelled;
@synthesize speed;
@synthesize grade;
@synthesize vo2;
@synthesize calories;
@synthesize co2;

@synthesize horizontalAccuracyString;
@synthesize altitudeString;
@synthesize elevationOneString;
@synthesize elevationTwoString;
@synthesize verticalAccuracyString;
@synthesize distanceTravelledString;
@synthesize speedString;
@synthesize gradeString;
@synthesize vo2String;
@synthesize timeString;
@synthesize caloriesString;
@synthesize co2String;


-(NSString *)getFormattedHorizontalAccuracy {
    return horizontalAccuracyString = [[NSString alloc] initWithFormat:@"%.2lf", horizontalAccuracy];
}

-(NSString *)getFormattedAltitude {
    return altitudeString = [[NSString alloc] initWithFormat:@"%.2lf", altitude];
}

-(NSString *)getFormattedElevationOne {
    return elevationOneString = [[NSString alloc] initWithFormat:@"%.2lf", elevationOne];
}

-(NSString *)getFormattedElevationTwo {
    return elevationTwoString = [[NSString alloc] initWithFormat:@"%.2lf", elevationTwo];
}

-(NSString *)getFormattedVerticalAccuracy {
    return verticalAccuracyString = [[NSString alloc] initWithFormat:@"%.2lf", verticalAccuracy];
}

-(NSString *)getFormattedDistanceTravelled {
    return distanceTravelledString = [[NSString alloc] initWithFormat:@"%.2lf", distanceTravelled];
}

-(NSString *)getFormattedSpeed {
    
    NSString *km =@" km/h";
    if(speed >= 0) {
        // from m/s to km/h
        double tempSpeed = speed;
        tempSpeed = tempSpeed * 3.6;
        return speedString = [[NSString alloc] initWithFormat:@"%.2lf %@", tempSpeed, km];
    }
    else {
        return @"0.00 km/h";
    }
}

-(NSString *)getFormattedGrade {
    return gradeString = [[NSString alloc] initWithFormat:@"%.2lf", grade];
}

-(NSString *)getFormattedVo2 {
    return vo2String = [[NSString alloc] initWithFormat:@"%.2lf", vo2];
}

-(NSString *)getFormattedTime {
    return timeString;
}

-(NSString *)getFormattedCalories {
    return caloriesString = [[NSString alloc] initWithFormat:@"%.2lf", calories];
}

-(NSString *)getFormattedco2 {
    return co2String = [[NSString alloc] initWithFormat:@"%.2lf", co2];
}

@end
