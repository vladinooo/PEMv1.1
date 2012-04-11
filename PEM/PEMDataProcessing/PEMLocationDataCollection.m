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
    NSString *altitudeRecord = [[NSString alloc] initWithFormat:@"Altit: %@", altitude];
    
    NSString *verticalAccuracy = [locationDataObject getFormattedVerticalAccuracy];
    NSString *verticalAccuracyRecord = [[NSString alloc] initWithFormat:@"Ver Acc:  %@", verticalAccuracy]; 
    
    NSString *elevationOne = [locationDataObject getFormattedElevationOne];
    NSString *elevationOneRecord = [[NSString alloc] initWithFormat:@"Elev 1: %@", elevationOne];

    NSString *elevationTwo = [locationDataObject getFormattedElevationTwo];
    NSString *elevationTwoRecord = [[NSString alloc] initWithFormat:@"Elev 2: %@", elevationTwo];

    NSString *distanceTravelled = [locationDataObject getFormattedDistanceTravelled];
    NSString *distanceTravelledRecord = [[NSString alloc] initWithFormat:@"Distance: %@", distanceTravelled];    
    
    NSString *speed = [locationDataObject getFormattedSpeed];
    NSString *speedRecord = [[NSString alloc] initWithFormat:@"Speed: %@", speed];
    
    NSString *grade = [locationDataObject getFormattedGrade];
    NSString *gradeRecord = [[NSString alloc] initWithFormat:@"Grade: %@", grade]; 
    
    NSString *lowestGrade = [locationDataObject getFormattedLowestGrade];
    NSString *lowestGradeRecord = [[NSString alloc] initWithFormat:@"L grade : %@", lowestGrade];
    
    NSString *highestGrade = [locationDataObject getFormattedHighestGrade];
    NSString *highestGradeRecord = [[NSString alloc] initWithFormat:@"H grade : %@", highestGrade];
    
    NSString *averageGrade = [locationDataObject getFormattedAverageGrade];
    NSString *averageGradeRecord = [[NSString alloc] initWithFormat:@"Avg grade : %@", averageGrade];
    
    NSString *vo2 = [locationDataObject getFormattedVo2];
    NSString *vo2Record = [[NSString alloc] initWithFormat:@"VO2: %@", vo2];
    
    NSString *calories = [locationDataObject getFormattedCalories];
    NSString *caloriesRecord = [[NSString alloc] initWithFormat:@"Calories: %@", calories];
    
    NSString *time = [locationDataObject getFormattedTime];
    NSString *timeRecord = [[NSString alloc] initWithFormat:@"Time: %@", time];
    
    NSString *locationDataRecord = [[NSString alloc] initWithFormat: @"%@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@, %@ %@", altitudeRecord, verticalAccuracyRecord, elevationOneRecord, elevationTwoRecord, distanceTravelledRecord, speedRecord, gradeRecord, lowestGradeRecord, highestGradeRecord, averageGradeRecord, vo2Record, caloriesRecord, timeRecord];
    
   // NSLog(@"Data: %@", locationDataRecord);

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
