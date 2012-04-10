//
//  PEMElevationRequest.h
//  PEM
//
//  Created by Vladimir Hartmann on 09/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "SBJson.h"


@interface PEMElevationRequest : NSObject <RKRequestDelegate>

@property (nonatomic) double elevation;
@property (nonatomic, strong) RKClient *client;
@property (nonatomic) bool isDownloaded;


-(void)requestElevation:(double)latitude:(double)longitude;


@end
