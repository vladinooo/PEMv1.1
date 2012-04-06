//
//  PEMSessionsViewController.h
//  PEM
//
//  Created by Vladimir Hartmann on 08/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PEMSessionDetailsViewController.h"
#import "PEMDatabaseAccess.h"

@interface PEMSessionsViewController : UITableViewController


@property (strong, nonatomic) PEMDatabaseAccess *dbAccess;
@property (strong, nonatomic) NSMutableArray *sessions;


@end
