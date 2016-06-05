//
//  UserTableViewCell.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/16/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsAppApi.h"
#import "User.h"
#import "FAImageView.h"
#import "UIFont+FontAwesome.h"

@class UserTableViewCell;
@protocol UserTableViewCellDelegate
-(void)cellWasTouched:(User *)payload;
@end

@interface UserTableViewCell : UITableViewCell
@property (assign) id <UserTableViewCellDelegate> delegate;

- (IBAction)CellPress:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *view;
-(void)resizeViewWidth:(CGFloat) width;
-(void)setData:(User *)user;
@end
