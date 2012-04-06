//
//  PEMLocationDataCollection.h
//  PEM
//
//  Created by Vladimir Hartmann on 06/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEMLocationData.h"

@interface PEMLocationDataCollection : NSObject

@property (nonatomic, retain) NSMutableArray *locationData;


-(void)startSavingLocationData:(PEMLocationData *)locationDataObject;

@end
