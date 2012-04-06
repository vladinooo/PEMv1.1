//
//  Profile.h
//  PEM
//
//  Created by Vladimir Hartmann on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface PEMProfile : NSObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * bodyWeight;
@property (nonatomic, retain) NSMutableArray *sessions;

@end


