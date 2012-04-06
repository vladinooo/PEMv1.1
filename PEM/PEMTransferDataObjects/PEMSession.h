//
//  Session.h
//  PEM
//
//  Created by Vladimir Hartmann on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface PEMSession : NSObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * sessionName;
@property (nonatomic, retain) NSString * modeOfTransport;
@property (nonatomic, retain) NSString * caloriesBurned;
@property (nonatomic, retain) NSString * distance;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * speed;
@property (nonatomic, retain) NSString * cO2Emission;

@end

