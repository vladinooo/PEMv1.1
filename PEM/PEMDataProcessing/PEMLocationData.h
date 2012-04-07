//
//  PEMLocationData.h
//  PEM
//
//  Created by Vladimir Hartmann on 06/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEMLocationData : NSObject

@property (nonatomic) double horizontalAccuracy;
@property (nonatomic) double altitude;
@property (nonatomic) double filterredAltitude;
@property (nonatomic) double verticalAccuracy;
@property (nonatomic) double distanceTravelled;
@property (nonatomic) double speed;
@property (nonatomic) double grade;
@property (nonatomic) double vo2;
@property (nonatomic) double co2;

@property (nonatomic, retain) NSString *horizontalAccuracyString;
@property (nonatomic, retain) NSString *altitudeString;
@property (nonatomic, retain) NSString *filterredAltitudeString;
@property (nonatomic, retain) NSString *verticalAccuracyString;
@property (nonatomic, retain) NSString *distanceTravelledString;
@property (nonatomic, retain) NSString *speedString;
@property (nonatomic, retain) NSString *gradeString;
@property (nonatomic, retain) NSString *vo2String;
@property (nonatomic, retain) NSString *co2String;

-(NSString *)getFormattedHorizontalAccuracy;
-(NSString *)getFormattedAltitude;
-(NSString *)getFormattedFilterredAltitude;
-(NSString *)getFormattedVerticalAccuracy;
-(NSString *)getFormattedDistanceTravelled;
-(NSString *)getFormattedSpeed;
-(NSString *)getFormattedGrade;
-(NSString *)getFormattedVo2;
-(NSString *)getFormattedco2;


@end
