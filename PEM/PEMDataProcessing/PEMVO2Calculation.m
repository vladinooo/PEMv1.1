//
//  PEMVO2Calculation.m
//  PEM
//
//  Created by Vladimir Hartmann on 06/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMVO2Calculation.h"

@implementation PEMVO2Calculation


-(void)calculateVO2:(PEMLocationData *)locationDataObject {

    
    
}

-(double)calculateGrade:(double)firstAltitudePoint:(double)secondAltitudePoint {

    // Calculate rise. Result will be - or + depending on the value
    // of secondAltitudePoint
    double rise = secondAltitudePoint - firstAltitudePoint;
    
    // calculate grade on distance of 10m
    double grade = rise / 10;
    
    return grade;
}
@end
