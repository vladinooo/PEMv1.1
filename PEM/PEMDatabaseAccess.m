//
//  PEMDatabaseQueries.m
//  PEM
//
//  Created by Vladimir Hartmann on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMDatabaseAccess.h"


@implementation PEMDatabaseAccess 

@synthesize appDelegate;


- (id) init {
    
    self = [super init];
    
    if (self != nil) {
    
        appDelegate = [[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

-(void)insertProfileToDatabase: (PEMProfile *)profile {
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSManagedObject *managedObject = [NSEntityDescription
    insertNewObjectForEntityForName: @"Profile" inManagedObjectContext:context];
    
    [managedObject setValue:@"" forKey:@"firstName"];
    [managedObject setValue:@"" forKey:@"lastName"];
    [managedObject setValue:profile.email forKey:@"email"];
    [managedObject setValue:profile.password forKey:@"password"];
    [managedObject setValue:@"Select body weight" forKey:@"bodyWeight"];

    // save to database
    NSError *error;
    [context save:&error];
}


-(void)insertSessionToDatabase: (PEMSession *)session {
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSManagedObject *managedObject = [NSEntityDescription
    insertNewObjectForEntityForName: @"Session" inManagedObjectContext:context];

    [managedObject setValue:session.date forKey:@"date"];
    [managedObject setValue:session.sessionName forKey:@"sessionName"];
    [managedObject setValue:session.modeOfTransport forKey:@"modeOfTransport"];
    [managedObject setValue:session.caloriesBurned forKey:@"caloriesBurned"];
    [managedObject setValue:session.distance forKey:@"distance"];
    [managedObject setValue:session.time forKey:@"time"];
    [managedObject setValue:session.speed forKey:@"speed"];
    [managedObject setValue:session.cO2Emission forKey:@"cO2Emission"];
    
    // save to database
    NSError *error;
    [context save:&error];
}



// get all from db
- (NSArray *)fetchFromDatabase: (NSString *)entityName {
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = 
    [NSEntityDescription entityForName:entityName 
    inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    return results;
    
}


// get by name
- (NSArray *)fetchSelectedFromDatabase: (NSString *)entityName:
(NSString *)query:
(NSString *)value {
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = 
    [NSEntityDescription entityForName:entityName 
    inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDesc];
    
    NSPredicate *predicate = 
    [NSPredicate predicateWithFormat:query, value];
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    return results;

}


- (void)saveChangesToPersistentStore {
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSError *error;
    [context save:&error];
    
}


- (void)deleteObjectFromPersistentStore:(NSManagedObject *)managedObject {

    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    [context deleteObject:managedObject];
    
}


@end
