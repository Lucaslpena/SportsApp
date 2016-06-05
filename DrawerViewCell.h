//
//  DrawerViewCell.h
//  SportsApp
//
//  Created by Lucas L. Pena on 12/15/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+FontAwesome.h"
#import "FAImageView.h"

@interface DrawerViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *cellImage;
@property (strong, nonatomic) IBOutlet UILabel *cellLabel;
-(void)setDisclosureIndicatorAt:(CGFloat)point;
-(void)setCellImageIcon:(NSString *)type;
@end
