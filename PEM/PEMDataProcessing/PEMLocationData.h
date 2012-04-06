//
//  PEMLocationData.h
//  PEM
//
//  Created by Vladimir Hartmann on 06/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEMLocationData : NSObject

@property (nonatomic, retain) NSString *altitude;
@property (nonatomic, retain) NSString *verticalAccuracy;
@property (nonatomic, retain) NSString *distanceTravelled;
@property (nonatomic, retain) NSString *speed;

@end
