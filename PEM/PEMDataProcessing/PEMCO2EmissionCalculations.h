//
//  PEMCO2EmissionCalculations.h
//  PEM
//
//  Created by Vladimir Hartmann on 11/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEMLocationData.h"

@interface PEMCO2EmissionCalculations : NSObject


-(double)calculateTravelingByCarCo2emissions:(PEMLocationData *)locationDataObject;

-(double)calculateTravelingByBusCo2emissions:(PEMLocationData *)locationDataObject;

-(double)calculateTravelingByTrainCo2emissions:(PEMLocationData *)locationDataObject;


@end
