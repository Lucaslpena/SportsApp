//
//  SportsTableViewCell.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/18/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "SportsTableViewCell.h"

@implementation SportsTableViewCell {
    UISwitch *cellSwitch;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setLabel:(NSString *)string AndHeight:(CGFloat)height
{
    [self.nameLabel setText:string];
    cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(height-60,6, 51, 31)];
    [cellSwitch setOnTintColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
    [cellSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:cellSwitch];
}
-(void)setSwitchEnabled {
    [cellSwitch setOn:YES animated:YES];
}
- (void)changeSwitch:(id)sender{
    if([sender isOn])
        [self.delegate sportDisplayName:_nameLabel.text WasAdded:YES];
    else
        [self.delegate sportDisplayName:_nameLabel.text WasAdded:NO];
}
@end
