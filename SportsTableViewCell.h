//
//  SportsTableViewCell.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/18/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>

@class SportsTableViewCell;
@protocol SportsTableViewCellDelegate
-(void)sportDisplayName:(NSString *)sport WasAdded:(BOOL)trigger;
@end

@interface SportsTableViewCell : UITableViewCell
@property (assign) id <SportsTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
-(void)setLabel:(NSString *)string AndHeight:(CGFloat)height;
-(void)setSwitchEnabled;
@end
