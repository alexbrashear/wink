//
//  Message.h
//  Wink
//
//  Created by Connor on 9/13/14.
//  Copyright (c) 2014 Nortron Technologies LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property NSString *content;
@property NSString *sender;
@property NSString *recipient;
@property NSString *createdAt;
@property NSString *messageId;
@end
