//
//  Session.h
//  PEM
//
//  Created by Vladimir Hartmann on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface PEMSession : NSObject

@property (nonatomic, retain) NSString *sessionName;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *activity;
@property (nonatomic, retain) NSString *distanceTravelled;
@property (nonatomic, retain) NSString *totalTime;
@property (nonatomic, retain) NSString *highestSpeed;
@property (nonatomic, retain) NSString *averageGrade;
@property (nonatomic, retain) NSString *vo2;
@property (nonatomic, retain) NSString *calories;
@property (nonatomic, retain) NSString *co2Emissions;

@end

