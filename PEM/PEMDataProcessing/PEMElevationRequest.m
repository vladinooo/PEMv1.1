//
//  PEMElevationRequest.m
//  PEM
//
//  Created by Vladimir Hartmann on 09/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMElevationRequest.h"

@implementation PEMElevationRequest

@synthesize elevation;
@synthesize client;
@synthesize isDownloaded;

-(id)init {
    
    self = [super init];
    
    if (self != nil) {
        
        // RKClient
        client = [RKClient clientWithBaseURL:@"http://maps.googleapis.com"];
        isDownloaded = false;
    }
    
    return self;
}


// request elevation from The Google Elevation API
-(void)requestElevation:(double)latitude:(double)longitude {
        
    NSString *prefix = @"/maps/api/elevation/json?locations=";
    NSString *sensor = @"&sensor=true";
    NSString *param = [[NSString alloc] initWithFormat:@"%@%f,%f%@", prefix, latitude, longitude, sensor];
    
    // Perform a simple HTTP GET and call me back with the results  
    [client get:param delegate:self];
    
}


// process results from GET request
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response { 
     
    NSString *jsonString = [response bodyAsString];
        
    // Create SBJsonParser object to parse JSON
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    // parse the JSON string into an object   
    NSDictionary *data = (NSDictionary *) [parser objectWithString:jsonString error:nil];  
    
    // getting the data
    NSArray *results = (NSArray *) [data objectForKey:@"results"];  
    
    NSDictionary *items = [results objectAtIndex:0];
    
    elevation =  [[items objectForKey:@"elevation"] doubleValue];
        
    isDownloaded = true;
}  

@end
