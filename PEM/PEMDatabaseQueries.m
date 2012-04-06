//
//  PEMDatabaseQueries.m
//  PEM
//
//  Created by Vladimir Hartmann on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMDatabaseQueries.h"

@implementation PEMDatabaseQueries 

@synthesize appDelegate;


- (id) init {
    
    self = [super init];
    
    if (self != nil) {
    
        appDelegate = [[UIApplication sharedApplication] delegate];
    }
    
    return self;
}

// fetch query
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


// fetch query with specific criteria
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
