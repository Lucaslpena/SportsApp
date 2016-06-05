//
//  DrawerViewCell.m
//  SportsApp
//
//  Created by Lucas L. Pena on 12/15/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "DrawerViewCell.h"

@implementation DrawerViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setCellImageIcon:(NSString *)type {
    if ([type isEqualToString:@"Me"])
        [self.cellImage setImage:[UIImage imageNamed:@"me_50"]];
    else if ([type isEqualToString:@"Purchases"])
        [self.cellImage setImage:[UIImage imageNamed:@"purchases_50"]];
    else if ([type isEqualToString:@"Listings"])
        [self.cellImage setImage:[UIImage imageNamed:@"purchases_50"]];
    else if ([type isEqualToString:@"Friends"])
        [self.cellImage setImage:[UIImage imageNamed:@"friends_50"]];
    else if ([type isEqualToString:@"Reserves"])
        [self.cellImage setImage:[UIImage imageNamed:@"reserves_50"]];
    else if ([type isEqualToString:@"My Sports"])
        [self.cellImage setImage:[UIImage imageNamed:@"mySports_50"]];
    else if ([type isEqualToString:@"Notifications"])
        [self.cellImage setImage:[UIImage imageNamed:@"friends_50"]];
}
-(void)setDisclosureIndicatorAt:(CGFloat)point {
    UILabel *disclosureIndicator = [[UILabel alloc] initWithFrame:CGRectMake(point-25, 4, 49, 35)];
    [self addSubview:disclosureIndicator];
    [disclosureIndicator setTextColor:[UIColor lightGrayColor]];
    [disclosureIndicator setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [disclosureIndicator setText:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-chevron-right"]];
}
@end
