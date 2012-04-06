//
//  PEMSessionsViewController.m
//  PEM
//
//  Created by Vladimir Hartmann on 08/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PEMSessionsViewController.h"


@implementation PEMSessionsViewController

@synthesize dbAccess;
@synthesize sessions;


- (id)initWithStyle:(UITableViewStyle)style {
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    dbAccess = [[PEMDatabaseAccess alloc] init];
    NSArray *results = [dbAccess fetchFromDatabase:@"Session"];
    sessions = [[NSMutableArray alloc] initWithArray:results];
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [sessions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"sessionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [[sessions objectAtIndex:indexPath.row] valueForKey:@"sessionName"];
    NSString *caloriesBurned = [NSString stringWithFormat:@"%@ %@",[[sessions objectAtIndex:indexPath.row] valueForKey:@"caloriesBurned"], @"calories"];
    cell.detailTextLabel.text = caloriesBurned;
    
    return cell;
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // push session sedails to details view
    PEMSessionDetailsViewController *sessionDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sessionDetails"];
    
    sessionDetailsVC.sessionName = [[sessions objectAtIndex:indexPath.row] valueForKey:@"sessionName"];
    sessionDetailsVC.caloriesBurned = [[sessions objectAtIndex:indexPath.row] valueForKey:@"caloriesBurned"];
    sessionDetailsVC.distance = [[sessions objectAtIndex:indexPath.row] valueForKey:@"distance"];
    sessionDetailsVC.time = [[sessions objectAtIndex:indexPath.row] valueForKey:@"time"];
    sessionDetailsVC.speed = [[sessions objectAtIndex:indexPath.row] valueForKey:@"speed"];
    sessionDetailsVC.co2Emission = [[sessions objectAtIndex:indexPath.row] valueForKey:@"cO2Emission"];
    
    [self.navigationController pushViewController:sessionDetailsVC animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}


// Handle deletion of an event.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
		NSManagedObject *sessionToDelete = [sessions objectAtIndex:indexPath.row];
		[dbAccess deleteObjectFromPersistentStore: sessionToDelete];
		
		// Update the array and table view.
        [sessions removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		// save to database
        [dbAccess saveChangesToPersistentStore];
        
    }   
}

@end

