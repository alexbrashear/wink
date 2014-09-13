//
//  PlaceTheyChatTableViewController.m
//  Wink
//
//  Created by Connor on 9/13/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "PlaceTheyChatTableViewController.h"
#import "PlaceTheyChatTableViewCell.h"
#import <Parse/Parse.h>
#import "Message.h"
#define TABBAR_HEIGHT 49.0f
#define TEXTFIELD_HEIGHT 30.0f;
#define KEYBOARD_HEIGHT 216.0f;

@interface PlaceTheyChatTableViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *messages;
@end
@implementation PlaceTheyChatTableViewController

-(void)viewDidLoad{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.messages = [[NSMutableArray alloc] init];
    [self retrieveChats];
}

-(void)retrieveChats{
    PFQuery *credits = [PFQuery queryWithClassName:@"Chats"];
    [credits whereKey:@"senderId" equalTo:[[PFUser currentUser]objectId]];
    
    PFQuery *debits = [PFQuery queryWithClassName:@"Chats"];
    [debits whereKey:@"recipientId" equalTo:[[PFUser currentUser]objectId]];
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[credits,debits]];
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
                [self.messages addObject:chat];
                
            }
            NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:NO];
            [self.messages sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
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
#pragma mark uitextfield delegates

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self sendMessage];
    return textField.text.length != 0 ? YES:NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)sender{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    float newHeightTextField = self.textField.frame.size.height + KEYBOARD_HEIGHT;
    float newHeightImageView = self.imageView.frame.size.height + KEYBOARD_HEIGHT;

    [UIView animateWithDuration:0.25 animations:^{
        [self.imageView setFrame:CGRectMake(0, screenHeight-newHeightImageView, 320, 55)];
        [self.textField setFrame:CGRectMake(16, screenHeight-newHeightTextField, 288, 30)];
    }];
}
-(void)sendMessage{
    PFObject *message = [PFObject objectWithClassName:@"Chats"];
    message[@"sender"] = self.sender;
    message[@"recipient"] = self.recipient;
    message[@"senderId"] = self.senderId;
    message[@"recipientId"] = self.recipientId;
    message[@"content"] = self.textField.text;
    [message saveInBackground];
    [self push];
}

-(void)push{
    
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"userId" equalTo:self.recipientId];
    
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:[NSString stringWithFormat:@"%@", self.textField.text]];
    [push sendPushInBackground];
    self.textField.text = @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"chatCell";
    PlaceTheyChatTableViewCell *cell = (PlaceTheyChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[PlaceTheyChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Message *message = [self.messages objectAtIndex:indexPath.row];
    cell.messageTextView.text = message.content;
    cell.nameLabel.text = message.sender;
    cell.dateLabel.text = message.createdAt;
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
    /*
    cell.profPic.layer.borderWidth = 3.0f;
    cell.profPic.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.profPic.layer.cornerRadius = 10.0f;
     */
    [cell setNeedsLayout];
    
    return cell;
}

@end
