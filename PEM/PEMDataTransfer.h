//
//  PEMDataTransfer.h
//  PEM
//
//  Created by Vladimir Hartmann on 29/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEMDatabaseAccess.h"
#import "PEMDataCenter.h"

@class PEMProfileViewController;

@protocol ProfileViewControllerDelegate
-(void)progressHUDWheelStart;
-(void)progressHUDWheelStop;
@end

@interface PEMDataTransfer : NSObject <RKRequestDelegate, RKObjectLoaderDelegate>
    
@property (strong, nonatomic) PEMDatabaseAccess *dbAccess;
@property (strong, nonatomic) PEMDataCenter *dataCenter;
@property (nonatomic, assign) id <ProfileViewControllerDelegate> profileViewControllerDelegate;
@property (strong, nonatomic) PEMDataTransfer *dataTransfer;

-(void)transferDataToPemWebApp:(NSString *)identifier:(PEMDataTransfer *)theDataTransfer;
-(void)deleteDataFromPemWebApp:(NSString *)identifier:(PEMDataTransfer *)theDataTransfer;

@end