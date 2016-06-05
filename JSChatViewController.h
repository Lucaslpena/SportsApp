//
//  JSChatViewController.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/18/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSMessagesViewController.h"
#import "MessageData.h"
#import "SportsAppApi.h"

@interface JSChatViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
-(void)setOtherId:(NSNumber *)userId;
@end
