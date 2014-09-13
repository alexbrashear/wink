//
//  ChatMessageTableViewCell.h
//  Wink
//
//  Created by Connor on 9/12/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
@interface ChatMessageTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextView  *messageTextView;
@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;

+ (CGFloat)heightForCellWithMessage:(QBChatAbstractMessage *)message;
- (void)configureCellWithMessage:(QBChatAbstractMessage *)message;

@end
