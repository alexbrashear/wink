//
//  ChatTableViewController.m
//  Wink
//
//  Created by Alex Brashear on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "ChatTableViewController.h"
#import "ChatTableViewCell.h"
#import "PlaceTheyChatTableViewController.h"
#import <Parse/Parse.h>
#import "Message.h"
@interface ChatTableViewController ()
@property (nonatomic, strong) NSMutableArray *dialogs;

@end

@implementation ChatTableViewController

-(void)viewDidLoad{
    self.dialogs = [[NSMutableArray alloc] init];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self retrieveChats];
}

-(void)retrieveChats{
    __block NSString *checkString1;
    __block NSString *checkString2;

    PFQuery *sent = [PFQuery queryWithClassName:@"Chats"];
    [sent whereKey:@"senderId" equalTo:[[PFUser currentUser]objectId]];
    
    PFQuery *received = [PFQuery queryWithClassName:@"Chats"];
    [received whereKey:@"recipientId" equalTo:[[PFUser currentUser]objectId]];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[sent,received]];
    query.limit = 50;
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error) {
            for (PFObject *dialog in results) {
                Message *chat = [[Message alloc] init];
                chat.content = [dialog objectForKey:@"content"];
                chat.recipient = [dialog objectForKey:@"recipient"];
                chat.sender = [dialog objectForKey:@"sender"];
                chat.senderId = [dialog objectForKey:@"senderId"];
                chat.recipientId = [dialog objectForKey:@"recipientId"];
                chat.createdAt = [dialog objectForKey:@"createdAt"];
                chat.messageId = dialog.objectId;
                chat.combinedId = [NSString stringWithFormat:@"%@%@", chat.senderId, chat.recipientId];
                checkString1 = chat.combinedId;
                checkString2 = [NSString stringWithFormat:@"%@%@", chat.recipientId, chat.senderId];
                [self.dialogs addObject:chat];
                
            }
            NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
            [self.dialogs sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            NSMutableArray *seenArray = [[NSMutableArray alloc] init];
            //checkstring 1 and 2 are to make sure that only one dialog shows up
            for (Message *message in self.dialogs){
                if ([seenArray containsObject:checkString1] || [seenArray containsObject:checkString2]){
                }
                else {
                    [tempArray addObject:message];
                    [seenArray addObject:message.combinedId];
                }
            }
            self.dialogs = tempArray;
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
    return [self.dialogs count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 76;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"previewCell";
    ChatTableViewCell *cell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    Message *message = [self.dialogs objectAtIndex:indexPath.row];
    cell.lastMessageView.text = message.content;
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Message *message = [self.dialogs objectAtIndex:indexPath.row];
    PlaceTheyChatTableViewController *vc = segue.destinationViewController;
    vc.sender = message.sender;
    vc.recipient = message.recipient;
    vc.createdAt = message.createdAt;
    vc.senderId = message.senderId;
    vc.recipientId = message.recipientId;
}

@end
