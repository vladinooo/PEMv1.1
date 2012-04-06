//
//  PEMDataCenter.m
//  PEM
//
//  Created by Vladimir Hartmann on 23/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMDataCenter.h"

@implementation PEMDataCenter

@synthesize profile;
@synthesize session;

static PEMDataCenter *sharedPEMDataCenter = nil;


+ (id)shareDataCenter {
    
    @synchronized(self) {
        
        if (sharedPEMDataCenter == nil)
            sharedPEMDataCenter = [[self alloc] init];
    }
    
    return sharedPEMDataCenter;
}



@end
