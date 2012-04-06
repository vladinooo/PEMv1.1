//
//  PEMDatabaseQueries.h
//  PEM
//
//  Created by Vladimir Hartmann on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMAppDelegate.h"

@interface PEMDatabaseQueries : NSObject {

    PEMAppDelegate *appDelegate;
}


@property (strong, nonatomic) PEMAppDelegate *appDelegate;



- (NSArray *)fetchFromDatabase: (NSString *)entityName;


- (NSArray *)fetchSelectedFromDatabase:
(NSString *)entityName:
(NSString *)query:
(NSString *)value;

- (void)saveChangesToPersistentStore;
- (void)deleteObjectFromPersistentStore:(NSManagedObject *)managedObject;



@end

