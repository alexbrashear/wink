//
//  ProfilesTableViewController.m
//  Wink
//
//  Created by Alex Brashear on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "ProfilesTableViewController.h"
#import <Parse/Parse.h>
#import "User.h"
@interface ProfilesTableViewController ()
@property NSMutableArray *potentialMatches;
@property NSMutableArray *potentialsInfo;
@end

@implementation ProfilesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.potentialMatches = [[NSMutableArray alloc] init];
    [self retrievePotentials];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)retrievePotentials{
    PFQuery *potentialsQuery = [PFUser query];
    [potentialsQuery whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    [potentialsQuery getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error)
     {
         if (!error){
             self.potentialMatches = [user objectForKey:@"potentialMatches"];
             [self retrievePotentialsInfo];
         }
         else
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         
     }];
}

-(void)retrievePotentialsInfo{
    PFQuery *potentialsQuery = [PFUser query];
    [potentialsQuery whereKey:@"objectId" containedIn:self.potentialMatches];
    [potentialsQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error)
     {
         if (!error){
             for (PFObject *user in users){
                 
             }
                 
         }
         else
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.potentialMatches.count;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
