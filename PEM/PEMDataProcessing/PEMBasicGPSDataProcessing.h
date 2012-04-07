//
//  PEMBasicGPSDataProcessing.h
//  PEM
//
//  Created by Vladimir Hartmann on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface PEMBasicGPSDataProcessing : NSObject


-(CLLocationDistance)calculateTotalDistance:(CLLocation *)startingPoint:(CLLocation *)newValidLocation;

-(double)createHighestSpeed:(double)highestSpeed:(double)speed;

-(double)calculateGrade:(double)firstAltitudePoint:(double)secondAltitudePoint;


@end
