//
//  ChatTableViewController.h
//  Wink
//
//  Created by Alex Brashear on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
@interface ChatTableViewController : UITableViewController
@property (strong, nonatomic) QBChatDialog *createdDialog;

@end
