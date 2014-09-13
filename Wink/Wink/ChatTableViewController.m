//
//  ChatTableViewController.m
//  Wink
//
//  Created by Alex Brashear on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "ChatTableViewController.h"
#import <SVProgressHUD.h>

@interface ChatTableViewController ()
@property (nonatomic, strong) NSMutableArray *dialogs;

@end

@implementation ChatTableViewController

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
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    static NSString *CellIdentifier = @"historyCell";
    PSHistoryTableViewCell *cell = (PSHistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PSHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    PSTransaction *transaction = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
        transaction = [self.searchResults objectAtIndex:indexPath.row];
    else
        transaction = [self.transactions objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:transaction.createdAt];
    
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
    
    cell.dateLabel.text = dateString;
    //cell.infoLabel.font = [UIFont fontWithName:@"Bender" size:18];
    cell.infoLabel.textColor = [UIColor blackColor];
    [cell setNeedsLayout];
    
    return cell;
    */
    return nil;
}

@end
