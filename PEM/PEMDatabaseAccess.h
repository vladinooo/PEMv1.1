//
//  PEMDatabaseQueries.h
//  PEM
//
//  Created by Vladimir Hartmann on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PEMAppDelegate.h"
#import "PEMDataCenter.h"
#import "PEMProfile.h"
#import "PEMSession.h"

@interface PEMDatabaseAccess : NSObject


@property (strong, nonatomic) PEMAppDelegate *appDelegate;



- (NSArray *)fetchFromDatabase: (NSString *)entityName;


- (NSArray *)fetchSelectedFromDatabase:
(NSString *)entityName:
(NSString *)query:
(NSString *)value;

-(void)insertProfileToDatabase: (PEMProfile *)profile;
-(void)insertSessionToDatabase: (PEMSession *)Session;

-(void)saveChangesToPersistentStore;
-(void)deleteObjectFromPersistentStore:(NSManagedObject *)managedObject;



@end

