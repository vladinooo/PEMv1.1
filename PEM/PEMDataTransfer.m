//
//  PEMDataTransfer.m
//  PEM
//
//  Created by Vladimir Hartmann on 29/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMDataTransfer.h"

@implementation PEMDataTransfer

@synthesize dbAccess;
@synthesize dataCenter;
@synthesize profileViewControllerDelegate;
@synthesize dataTransfer;

- (id) init {
    
    self = [super init];
    
    if (self != nil) {
        
        dbAccess = [[PEMDatabaseAccess alloc] init];
    }
    
    return self;
}


// transfer data to PemWebApp
-(void)transferDataToPemWebApp:(NSString *)identifier:(PEMDataTransfer *)theDataTransfer {  
    
    // Start activity indicator animation
    dataTransfer = theDataTransfer;
    [dataTransfer.profileViewControllerDelegate progressHUDWheelStart];
    
    // Perform a simple HTTP GET and call me back with the results  
    [[RKClient sharedClient] get:identifier delegate:self];
}


// delete data from PemWebApp
-(void)deleteDataFromPemWebApp:(NSString *)identifier:(PEMDataTransfer *)theDataTransfer {  
    
    // Start activity indicator animation
    dataTransfer = theDataTransfer;
    [dataTransfer.profileViewControllerDelegate progressHUDWheelStart];
    
    [self deleteObject];
}


// process results from GET request
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response { 
    
    if ([request isGET]) {
        if ([[response bodyAsString] isEqualToString:@"1"]) {  
            
            NSLog(@"Profile exists. Deleting!");
            [self deleteObject];
            NSLog(@"Sending profile data...");
            [self postObject];
        }
        if ([[response bodyAsString] isEqualToString:@"0"]) {  
            
            NSLog(@"Creating new profile!");
            [self postObject];
        }
    }
    
    if ([request isDELETE]) {
    
        if ([[response bodyAsString] isEqualToString:@"1"]) {
            NSLog(@"Profile deleted!");
            
        }
        if ([[response bodyAsString] isEqualToString:@"0"]) {  
            
            NSLog(@"Profile doesn't exist!");
        }
    }

}  


// get current profile from dataCenter
// get all current profile's sessions from database
// transfer it all to PEMWEBAPP
-(void)postObject {
    
    // Grab the reference to the router from the manager
    RKObjectRouter *router =  [RKObjectManager sharedManager].router;
    
    // Define a default resource path for all unspecified HTTP verbs
    [router routeClass:[PEMProfile class] toResourcePath:@"/:identifier"];
    [router routeClass:[PEMProfile class] toResourcePath:@"/" forMethod:RKRequestMethodPOST];
    
    // mapping
    RKObjectMapping *profileMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [profileMapping mapKeyPath:@"firstName" toAttribute:@"firstName"];
    [profileMapping mapKeyPath:@"lastName" toAttribute:@"lastName"];
    [profileMapping mapKeyPath:@"email" toAttribute:@"email"];
    [profileMapping mapKeyPath:@"password" toAttribute:@"password"];
    [profileMapping mapKeyPath:@"bodyWeight" toAttribute:@"bodyWeight"];
    
    RKObjectMapping *sessionMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
    [sessionMapping mapKeyPath:@"date" toAttribute:@"date"];
    [sessionMapping mapKeyPath:@"sessionName" toAttribute:@"sessionName"];
    [sessionMapping mapKeyPath:@"modeOfTransport" toAttribute:@"modeOfTransport"];
    [sessionMapping mapKeyPath:@"caloriesBurned" toAttribute:@"caloriesBurned"];
    [sessionMapping mapKeyPath:@"distance" toAttribute:@"distance"];
    [sessionMapping mapKeyPath:@"time" toAttribute:@"time"];
    [sessionMapping mapKeyPath:@"speed" toAttribute:@"speed"];
    [sessionMapping mapKeyPath:@"cO2Emission" toAttribute:@"cO2Emission"];
    
    // Define the relationship mapping
    [profileMapping mapKeyPath:@"sessions" toRelationship:@"sessions" withMapping:sessionMapping];
    
    // Set wire format for POST/PUT operations
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [[RKObjectManager sharedManager] setAcceptMIMEType:RKMIMETypeJSON];
    
    // Register the mapping with the provider
    [[RKObjectManager sharedManager].mappingProvider addObjectMapping: profileMapping];
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[profileMapping inverseMapping] forClass:[PEMProfile class]];
    
    // POST data to webservice
    [[RKObjectManager sharedManager] postObject:[self createObjectForTransfer]
                                mapResponseWith:profileMapping delegate:self];
    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Data transferred, and response mapped OK");
    // Stop activity indicator animation
    [dataTransfer.profileViewControllerDelegate progressHUDWheelStop];
    
    // Data successfully transferred alert
    UIAlertView *dataTransferredAlert =
    [[UIAlertView alloc] initWithTitle:@"Data successfully transferred to online PEM account." 
                               message:nil
                              delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [dataTransferredAlert show];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
    NSLog(@"log : %@",msg);
    
    // Stop activity indicator animation
    [dataTransfer.profileViewControllerDelegate progressHUDWheelStop];
}

// connect with Core Data to obtail persisted objects
// and convert them to POJO
-(PEMProfile *)createObjectForTransfer {
    
    // get profile object from db
    dataCenter = [PEMDataCenter shareDataCenter];
    NSArray *results = [dbAccess fetchSelectedFromDatabase:@"Profile" :@"email == %@" : dataCenter.profile.email];
    NSManagedObject *profileFromDb;
    profileFromDb = [results objectAtIndex:0];
    
    // create profile object for transfer
    PEMProfile *profile = [[PEMProfile alloc] init];
    profile.firstName = [profileFromDb valueForKey:@"firstName"];
    profile.lastName = [profileFromDb valueForKey:@"lastName"];
    profile.email = [profileFromDb valueForKey:@"email"];
    profile.password = [profileFromDb valueForKey:@"password"];
    profile.bodyWeight = [profileFromDb valueForKey:@"bodyWeight"];
    
    // get sessions object from db
    NSArray *results2 = [dbAccess fetchFromDatabase:@"Session"];
    
    // create sessions object for transfer
    NSMutableArray *sessions = [[NSMutableArray alloc] init];
    for (NSManagedObject *sessionFromDb in results2) {
        PEMSession *session = [[PEMSession alloc] init];
        session.date = [sessionFromDb valueForKey:@"date"];
        session.sessionName = [sessionFromDb valueForKey:@"sessionName"];
        session.modeOfTransport = [sessionFromDb valueForKey:@"modeOfTransport"];
        session.caloriesBurned = [sessionFromDb valueForKey:@"caloriesBurned"];
        session.distance = [sessionFromDb valueForKey:@"distance"];
        session.time = [sessionFromDb valueForKey:@"time"];
        session.speed = [sessionFromDb valueForKey:@"speed"];
        session.cO2Emission = [sessionFromDb valueForKey:@"cO2Emission"];
        [sessions addObject:session];
        NSLog(@"Session: %@", session.sessionName);
    }
    
    profile.sessions = sessions; // add sessions to profile
    return profile;
}


// perform DELETE request
-(void)deleteObject {
    dataCenter = [PEMDataCenter shareDataCenter];
    NSString *email = dataCenter.profile.email;
    NSString *resourceIdentifier = [[NSString alloc] initWithFormat:@"/%@", email];
    [[RKClient sharedClient] delete:resourceIdentifier delegate:self];
}


@end



