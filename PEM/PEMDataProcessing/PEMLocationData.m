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
@synthesize filterredAltitude;
@synthesize verticalAccuracy;
@synthesize distanceTravelled;
@synthesize speed;
@synthesize grade;
@synthesize vo2;
@synthesize co2;

@synthesize horizontalAccuracyString;
@synthesize altitudeString;
@synthesize filterredAltitudeString;
@synthesize verticalAccuracyString;
@synthesize distanceTravelledString;
@synthesize speedString;
@synthesize gradeString;
@synthesize vo2String;
@synthesize co2String;


-(NSString *)getFormattedHorizontalAccuracy {
    return horizontalAccuracyString = [[NSString alloc] initWithFormat:@"%.2lf", horizontalAccuracy];
}

-(NSString *)getFormattedAltitude {
    return altitudeString = [[NSString alloc] initWithFormat:@"%.2lf", altitude];
}

-(NSString *)getFormattedFilterredAltitude {
    return filterredAltitudeString = [[NSString alloc] initWithFormat:@"%.2lf", filterredAltitude];
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
        return speedString = [[NSString alloc] initWithFormat:@"%.2lf%@", speed, km];
    }
    else {
        return @"hahaha";
    }
}

-(NSString *)getFormattedGrade {
    return gradeString = [[NSString alloc] initWithFormat:@"%.2lf", grade];
}

-(NSString *)getFormattedVo2 {
    return vo2String = [[NSString alloc] initWithFormat:@"%.2lf", vo2];
}

-(NSString *)getFormattedco2 {
    return co2String = [[NSString alloc] initWithFormat:@"%.2lf", co2];
}

@end
