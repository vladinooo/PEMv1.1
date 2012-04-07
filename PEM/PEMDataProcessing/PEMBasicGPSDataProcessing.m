//
//  PEMBasicGPSDataProcessing.m
//  PEM
//
//  Created by Vladimir Hartmann on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMBasicGPSDataProcessing.h"

@implementation PEMBasicGPSDataProcessing


// calculate total distance
-(CLLocationDistance)calculateTotalDistance:(CLLocation *)startingPoint:(CLLocation *)newValidLocation {
    CLLocationDistance totalDistance;
    totalDistance += [newValidLocation distanceFromLocation:startingPoint];
    return totalDistance;
}


// create highest speed
-(double)createHighestSpeed:(double)highestSpeed:(double)speed {
    if(speed > highestSpeed) {
        highestSpeed = speed;
        return highestSpeed;
    }
    else {
        return speed;
    }
}


// calculate grade
-(double)calculateGrade:(double)firstAltitudePoint:(double)secondAltitudePoint {
    
    // Calculate rise
    double rise = secondAltitudePoint - firstAltitudePoint;
    
    // calculate grade on distance of 10m
    double grade = rise / 10;
    
    return grade;
}


@end
