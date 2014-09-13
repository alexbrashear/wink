//
//  PotentialMatchTableViewCell.m
//  Wink
//
//  Created by Connor on 9/13/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "PotentialMatchTableViewCell.h"
#import <Parse/Parse.h>
@implementation PotentialMatchTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)yes:(id)sender {
    PFObject *chat = [PFObject objectWithClassName:@"Chats"];
    chat[@"senderId"] = self.potentialMatchId;
    chat[@"recipientId"] = [[PFUser currentUser] objectId];
    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [self push];
        [self removePotentialFromArray];
    }];
    
}
- (IBAction)no:(id)sender {
    [self removePotentialFromArray];
}

-(void)push{
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"userId" equalTo:self.potentialMatchId];
    // Send push notification to query
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery]; // Set our Installation query
    [push setMessage:[NSString stringWithFormat:@"You've got a match!"]];
    [push sendPushInBackground];
}

-(void)removePotentialFromArray{
    PFQuery *potentialsQuery = [PFUser query];
    [potentialsQuery whereKey:@"objectId" equalTo:[[PFUser currentUser]objectId]];
    [potentialsQuery getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error)
     {
         if (!error){
             NSMutableArray *tempArray = [[NSMutableArray alloc] init];
             tempArray = [user objectForKey:@"potentialMatches"];
             NSMutableArray *tempArray2 = [[NSMutableArray alloc] init];
             for (PFObject *object in tempArray){
                 if (![object.objectId isEqualToString:self.potentialMatchId])
                     [tempArray2 addObject:object.objectId];
             }
             user[@"potentialMatches"] = tempArray2;
             [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"retrievePotentials" object:nil];
             }];
         }
         else
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         
     }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
