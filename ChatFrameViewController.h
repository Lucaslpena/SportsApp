//
//  ChatFrameViewController.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/18/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSChatViewController.h"
#import "User.h"
@interface ChatFrameViewController : UIViewController
-(void)setOtherUser:(User *)user;
@end
