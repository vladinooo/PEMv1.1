//
//  PEMLocationDataCollection.m
//  PEM
//
//  Created by Vladimir Hartmann on 06/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


///////////////////////////////////////////////////////////////////
// This class is used only for collection of location data points
// for accuracy testing and filtering
///////////////////////////////////////////////////////////////////


#import "PEMLocationDataCollection.h"

@implementation PEMLocationDataCollection

@synthesize locationData;


- (id) init {
    
    self = [super init];
    
    if (self != nil) {
        
        locationData = [[NSMutableArray alloc] init];
    }
    
    return self;
}


-(void)saveLocationData:(PEMLocationData *)locationDataObject {
    
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"PEMLocationDataStorage.plist"];
    
    // create location data records string
    NSString *altitude = [locationDataObject getFormattedAltitude];
    NSString *altitudeRecord = [[NSString alloc] initWithFormat:@"Altitude: %@", altitude];
    
    NSString *filterredAltitude = [locationDataObject getFormattedFilterredAltitude];
    NSString *filterredAltitudeRecord = [[NSString alloc] initWithFormat:@"Filterred altitude: %@", filterredAltitude];    

    NSString *verticalAccuracy = [locationDataObject getFormattedVerticalAccuracy];
    NSString *verticalAccuracyRecord = [[NSString alloc] initWithFormat:@"Vertical Accuracy:  %@", verticalAccuracy];    
    
    NSString *distanceTravelled = [locationDataObject getFormattedDistanceTravelled];
    NSString *distanceTravelledRecord = [[NSString alloc] initWithFormat:@"Distance travelled: %@", distanceTravelled];    
    
    NSString *speed = [locationDataObject getFormattedSpeed];
    NSString *speedRecord = [[NSString alloc] initWithFormat:@"Speed: %@", speed];    
    
    NSString *locationDataRecord = [[NSString alloc] initWithFormat: @"%@, %@, %@, %@", altitudeRecord, filterredAltitudeRecord, verticalAccuracyRecord, distanceTravelledRecord, speedRecord];
    
    NSLog(@"Data: %@", locationDataRecord);

    // add location data to appropriate arrays
    [locationData addObject:locationDataRecord];
    
    // create dictionary
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:
                               [NSArray arrayWithObjects: locationData, nil]
                                                          forKeys:[NSArray arrayWithObjects: @"Location Data", nil]];

    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check is plistData exists
    if(plistData) {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
    }
    else {
        NSLog(@"Error in saving PEMLocationData: %@", error);
    }
}

@end
