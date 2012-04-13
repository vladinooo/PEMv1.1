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
@synthesize lowestGrade;
@synthesize highestGrade;
@synthesize averageGrade;
@synthesize vo2;
@synthesize calories;
@synthesize co2emissions;

@synthesize horizontalAccuracyString;
@synthesize altitudeString;
@synthesize elevationOneString;
@synthesize elevationTwoString;
@synthesize verticalAccuracyString;
@synthesize distanceTravelledString;
@synthesize speedString;
@synthesize gradeString;
@synthesize lowestGradeString;
@synthesize highestGradeString;
@synthesize averageGradeString;
@synthesize vo2String;
@synthesize totalTimeString;
@synthesize caloriesString;
@synthesize co2EmissionsString;


-(NSString *)getFormattedHorizontalAccuracy {
    return horizontalAccuracyString = [[NSString alloc] initWithFormat:@"%.2lf%@", horizontalAccuracy, @" m"];
}

-(NSString *)getFormattedAltitude {
    return altitudeString = [[NSString alloc] initWithFormat:@"%.2lf%@", altitude, @" m"];
}

-(NSString *)getFormattedElevationOne {
    return elevationOneString = [[NSString alloc] initWithFormat:@"%.2lf%@", elevationOne, @" m"];
}

-(NSString *)getFormattedElevationTwo {
    return elevationTwoString = [[NSString alloc] initWithFormat:@"%.2lf%@", elevationTwo, @" m"];
}

-(NSString *)getFormattedVerticalAccuracy {
    return verticalAccuracyString = [[NSString alloc] initWithFormat:@"%.2lf%@", verticalAccuracy, @" m"];
}

-(NSString *)getFormattedDistanceTravelled {
    return distanceTravelledString = [[NSString alloc] initWithFormat:@"%.2lf%@", distanceTravelled, @" m"];
}

-(NSString *)getFormattedSpeed {
    
    if(speed >= 0) {
        // from m/s to km/h
        double tempSpeed = speed;
        tempSpeed = tempSpeed * 3.6;
        return speedString = [[NSString alloc] initWithFormat:@"%.2lf%@", tempSpeed, @" km/h"];
    }
    else {
        return @"0.00 km/h";
    }
}

-(NSString *)getFormattedGrade {
    return gradeString = [[NSString alloc] initWithFormat:@"%.2lf%@", grade, @" %"];
}

-(NSString *)getFormattedLowestGrade {
    return lowestGradeString = [[NSString alloc] initWithFormat:@"%.2lf%@", lowestGrade, @" %"];
}

-(NSString *)getFormattedHighestGrade {
    return highestGradeString = [[NSString alloc] initWithFormat:@"%.2lf%@", highestGrade, @" %"];
}

-(NSString *)getFormattedAverageGrade {
    return averageGradeString = [[NSString alloc] initWithFormat:@"%.2lf%@", averageGrade, @" %"];
}

-(NSString *)getFormattedVo2 {
    return vo2String = [[NSString alloc] initWithFormat:@"%.2lf%@", vo2, @" mL/kg"];
}

-(NSString *)getFormattedTotalTime {
    return totalTimeString;
}

-(NSString *)getFormattedCalories {
    return caloriesString = [[NSString alloc] initWithFormat:@"%.2lf%@", calories, @" kcal"];
}

-(NSString *)getFormattedCaloriesPure {
    NSString *caloriesPureString = [[NSString alloc] initWithFormat:@"%.2lf", calories];
    return caloriesPureString;
}

-(NSString *)getFormattedco2Emissions {
    return co2EmissionsString = [[NSString alloc] initWithFormat:@"%.2lf%@", co2emissions, @" kgCO2"];
}

-(NSString *)getFormattedco2EmissionsPure {
    NSString *co2EmissionsPureString = [[NSString alloc] initWithFormat:@"%.2lf", co2emissions];
    return co2EmissionsPureString;
}

@end
