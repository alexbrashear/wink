//
//  ChatTableViewController.m
//  Wink
//
//  Created by Alex Brashear on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "ChatTableViewController.h"
#import "ChatTableViewCell.h"
#import <Parse/Parse.h>
#import "Message.h"
@interface ChatTableViewController ()
@property (nonatomic, strong) NSMutableArray *dialogs;

@end

@implementation ChatTableViewController

-(void)viewDidLoad{
    [self retrieveChats];
}

-(void)retrieveChats{
    self.dialogs = [[NSMutableArray alloc] init];
    PFQuery *credits = [PFQuery queryWithClassName:@"Transaction"];
    [credits whereKey:@"sellerId" equalTo:[[PFUser currentUser]objectId]];
    
    PFQuery *debits = [PFQuery queryWithClassName:@"Transaction"];
    [debits whereKey:@"buyerId" equalTo:[[PFUser currentUser]objectId]];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[credits,debits]];
    query.limit = 15;
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            
            for (PFObject *dialog in results) {
                Message *chat = [[Message alloc] init];
                chat.content = [dialog objectForKey:@"content"];
                chat.recipient = [dialog objectForKey:@"recipient"];
                chat.sender = [dialog objectForKey:@"sender"];
                chat.createdAt = [dialog objectForKey:@"createdAt"];
                [self.dialogs addObject:chat];
                
            }
            //[self findTotal];
            NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
            [self.dialogs sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
            [self.tableView reloadData];
            
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"chatCell";
    ChatTableViewCell *cell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:transaction.createdAt];
    */
    /*
    if ([[[PFUser currentUser]objectId] isEqualToString:transaction.sellerId]){
        cell.infoLabel.text = transaction.buyerUsername;
        cell.amountLabel.textColor = [UIColor blackColor];
        cell.amountLabel.text = [NSString stringWithFormat:@"$%@", transaction.amount];
    }
    else {
        cell.infoLabel.text = transaction.sellerUsername;
        cell.amountLabel.textColor = [UIColor redColor];
        cell.amountLabel.text = [NSString stringWithFormat:@"-$%@", transaction.amount];
    }
    */
    cell.profPic.layer.borderWidth = 3.0f;
    cell.profPic.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.profPic.layer.cornerRadius = 10.0f;
    //cell.dateLabel.text = dateString;
    //cell.infoLabel.font = [UIFont fontWithName:@"Bender" size:18];
    //cell.infoLabel.textColor = [UIColor blackColor];
    [cell setNeedsLayout];
    
    return cell;
}

@end
