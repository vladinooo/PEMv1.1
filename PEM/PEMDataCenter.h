//
//  PEMDataCenter.h
//  PEM
//
//  Created by Vladimir Hartmann on 23/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMProfile.h"
#import "PEMSession.h"


@interface PEMDataCenter : NSObject

// stores individual data about user (name, email, password, weight etc.)
@property(strong, nonatomic) PEMProfile *profile; 

// array that stores individual session data (name, time, speed, calories etc.)
@property(strong, nonatomic) PEMSession *session;

+(id)shareDataCenter;

@end
