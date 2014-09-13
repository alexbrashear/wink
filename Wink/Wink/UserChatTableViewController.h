//
//  UserChatTableViewController.h
//  Wink
//
//  Created by Connor on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
@interface UserChatTableViewController : UITableViewController
@property (nonatomic, strong) QBChatDialog *dialog;
@end
