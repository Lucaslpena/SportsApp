//
//  UserTableViewCell.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/16/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "UserTableViewCell.h"

@interface UserTableViewCell() {
    IBOutlet UIImageView *profileImage;
    IBOutlet UIView *headerView;
    IBOutlet UITextField *nameLabel;
    IBOutlet UILabel *emailLabel;
}
@end


@implementation UserTableViewCell {
    User *data;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)awakeFromNib {
    self.view.layer.shadowOffset = CGSizeMake(1, 2);
    self.view.layer.shadowRadius = 2;
    self.view.layer.shadowOpacity = 0.3;
    [self.view.layer setBorderWidth:.75f];
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [headerView setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)resizeViewWidth:(CGFloat) width {
    CGRect frame = self.view.frame;
    frame.size.width = width;
    self.view.frame = frame;
    [self.view layoutIfNeeded];
    UILabel *disclosureIndicator = [[UILabel alloc] initWithFrame:CGRectMake(width-15, self.view.center.y-30, 50, 35)];
    [self.view addSubview:disclosureIndicator];
    [disclosureIndicator setTextColor:[UIColor lightGrayColor]];
    [disclosureIndicator setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [disclosureIndicator setText:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-chevron-right"]];
    
    [self.view layoutIfNeeded];
}
-(void)setData:(User *)user {
    [nameLabel setText:[user.attrs objectForKey:@"ll"]];
    [emailLabel setText:[user.attrs objectForKey:@"name"]];
    [[SportsAppApi sharedInstance] getUserAvatarById:[[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"rowId"] WithCompletionBlock:^(NSError *err, id result) {
        [profileImage setImage:[UIImage imageWithData:result]];
    }];
    profileImage.layer.cornerRadius = profileImage.frame.size.width / 2;
    profileImage.clipsToBounds = YES;
    profileImage.layer.borderWidth = 3.0f;
    profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    data = user;
}
- (IBAction)CellPress:(id)sender {
    [self.delegate cellWasTouched:data];
}
@end