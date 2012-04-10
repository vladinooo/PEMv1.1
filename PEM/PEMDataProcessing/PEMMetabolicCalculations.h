//
//  PEMMetabolicCalculations.h
//  PEM
//
//  Created by Vladimir Hartmann on 07/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEMProfile.h"
#import "PEMDataCenter.h"
#import "PEMLocationData.h"

@interface PEMMetabolicCalculations : NSObject

@property (strong, nonatomic) PEMDataCenter *dataCenter;

-(double)calculateWalkingVo2:(PEMLocationData *)locationDataObject;

-(double)calculateCalorieExpenditure:(double)vO2;


@end
