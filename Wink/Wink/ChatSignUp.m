//
//  ChatSignUp.m
//  Wink
//
//  Created by Connor on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import "ChatSignUp.h"
#import <Quickblox/Quickblox.h>
#import <Parse/Parse.h>
@implementation ChatSignUp
+(void)quickBloxChatSignUp{
    // Create QuickBlox User entity
    QBUUser *user = [QBUUser user];
    user.password = [[PFUser currentUser] objectId];
    user.login = [[PFUser currentUser] objectId];
    
    //@weakify(self);
    // create User
    [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
        //@strongify(self);
        NSLog(@"successfully signed up");
    } errorBlock:^(QBResponse *response) {
        NSLog(@"errors: %@", [response.error description]);
    }];

}
@end
