//
//  PlaceTheyChatTableViewCell.h
//  Wink
//
//  Created by Connor on 9/13/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceTheyChatTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextView *messageTextView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
