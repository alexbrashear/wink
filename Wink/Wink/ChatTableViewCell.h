//
//  ChatTableViewCell.h
//  Wink
//
//  Created by Connor on 9/13/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profPic;
@property (strong, nonatomic) IBOutlet UITextView *lastMessageView;

@end
