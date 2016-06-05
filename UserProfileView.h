//
//  UserProfileView.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/15/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsAppApi.h"
#import "User.h"

@class UserProfileView;
@protocol UserProfileViewDelegate
-(void)triggerLogout;
-(void)triggerImagePicker;
-(void)triggerKeyboardAnimate:(BOOL)toggle ToHeight:(CGFloat)height;
@end

@interface UserProfileView : UIView <UITextFieldDelegate>
@property (assign) id <UserProfileViewDelegate> delegate;
- (IBAction)logoutAction:(id)sender;
- (IBAction)photoAction:(id)sender;
-(void)setProfilePicture:(UIImage *)avatar;
@end
