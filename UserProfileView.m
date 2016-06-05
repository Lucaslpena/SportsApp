//
//  UserProfileView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/15/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "UserProfileView.h"

@interface UserProfileView() {
    IBOutlet UIView *view;
    IBOutlet UIView *headerView;
    IBOutlet UIImageView *profileImage;
    IBOutlet UITextField *nameLabel;
    IBOutlet UILabel *emailLabel;
    IBOutlet UITextField *streetField;
    IBOutlet UITextField *apartmentField;
    IBOutlet UITextField *cityField;
    IBOutlet UITextField *stateField;
    IBOutlet UITextField *zipField;
    IBOutlet UITextField *phoneField;
    
    IBOutlet UIButton *logoutButton;
}
@end

@implementation UserProfileView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"UserProfileView" owner:self options:nil] objectAtIndex:0];
        [xibView setFrame:[self bounds]];
        [self addSubview:xibView];
        [self layoutIfNeeded];
        [self initContents];
        [self setProfilePicture:[UIImage imageWithData:[SportsAppApi sharedInstance].mainUser.avatar]];
//        [[SportsAppApi sharedInstance] getUserAvatarById:[[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"rowId"] WithCompletionBlock:^(NSError *err, id result) {
//            [self setProfilePicture:[UIImage imageWithData:result]];
//        }];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"UserProfileView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:xibView];
    }
    return self;
}
-(void)initContents {
    [nameLabel setDelegate:self];
    [streetField setDelegate:self];
    [apartmentField setDelegate:self];
    [cityField setDelegate:self];
    [stateField setDelegate:self];
    [zipField setDelegate:self];
    [phoneField setDelegate:self];
    
    [nameLabel setTextColor:[UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f]];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
    [logoutButton.titleLabel setText:@"Log out"];
    [logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
    logoutButton.layer.shadowOffset = CGSizeMake(1, 2);
    logoutButton.layer.shadowRadius = 2;
    logoutButton.layer.shadowOpacity = .3;
  
    //NSDictionary *sdf = [[SportsAppApi sharedInstance] mainUser].attrs;
    if ([[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"firstName"] == nil) {
        [nameLabel setText:@"Your Name"];
    }
    else
        [nameLabel setText:[NSString stringWithFormat:@"%@ %@",[[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"firstName"], [[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"lastName"]]];
    [emailLabel setText:[[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"name"]];
    
    if ([[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"street"])
        [streetField setText:[NSString stringWithFormat:@"%@",[[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"street"]]];
    if ([[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"apt"])
        [apartmentField setText:[NSString stringWithFormat:@"%@",[[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"apt"]]];
    if ([[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"city"])
        [cityField setText:[NSString stringWithFormat:@"%@",[[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"city"]]];
    if ([[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"city"])
        [stateField setText:[NSString stringWithFormat:@"%@",[[[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"state"] uppercaseString]]];
    if ([[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"zip"])
        [zipField setText:[NSString stringWithFormat:@"%@",[[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"zip"]]];
    if ([[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"phone"])
        [phoneField setText:[NSString stringWithFormat:@"%@",[[[SportsAppApi sharedInstance] mainUser].attrs objectForKey:@"phone"]]];
}
-(void)setProfilePicture:(UIImage *)avatar {
    [profileImage setImage:avatar];
    profileImage.layer.cornerRadius = profileImage.frame.size.width / 2;
    profileImage.clipsToBounds = YES;
    profileImage.layer.borderWidth = 3.0f;
    profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
}
- (IBAction)logoutAction:(id)sender {
#warning TODO - handle logout
    [[SportsAppApi sharedInstance] whipeUser];
    //////////
    [self.delegate triggerLogout];
}
- (IBAction)photoAction:(id)sender {
    [self.delegate triggerImagePicker];
}
#pragma mark - Textfields
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [view endEditing:YES];
    [self.delegate triggerKeyboardAnimate:NO ToHeight:0];
    [self becomeFirstResponder];
    [self compareForUpdate];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate triggerKeyboardAnimate:NO ToHeight:0];
    [textField resignFirstResponder];
    [self compareForUpdate];
    return true;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.delegate triggerKeyboardAnimate:YES ToHeight:textField.frame.origin.y];
}
#pragma mark - Update Methods
-(void)compareForUpdate {
    NSMutableDictionary *compareAttrs = [[NSMutableDictionary alloc] initWithObjects: @[cityField.text, emailLabel.text, [stateField.text lowercaseString], zipField.text, streetField.text, apartmentField.text]
                                                               forKeys: @[@"city", @"name", @"state",@"zip",@"street1",@"street2"]];
    if ((nameLabel.text.length > 0) && ![nameLabel.text isEqualToString:@"Your Name"])
    {
        NSArray *names = [nameLabel.text componentsSeparatedByString: @" "];
        [compareAttrs setObject:[names objectAtIndex:1] forKey:@"lastName"];
        [compareAttrs setObject:[names objectAtIndex:0] forKey:@"firstName"];
    }
    NSMutableDictionary *mainUserAttrs = [[NSMutableDictionary alloc] initWithDictionary:[SportsAppApi sharedInstance].mainUser.attrs];
    [mainUserAttrs removeObjectForKey:@"lastModified"];
    [mainUserAttrs removeObjectForKey:@"longitude"];
    [mainUserAttrs removeObjectForKey:@"latitude"];
    [mainUserAttrs removeObjectForKey:@"rowId"];
    [mainUserAttrs removeObjectForKey:@"status"];
    
    bool update = false;
    if ([mainUserAttrs allValues].count != [compareAttrs allValues].count) {
        update = true;
    }
    else {
        for (int i = 0; i < [compareAttrs allValues].count; ++i) {
            NSString *value1 = [[[mainUserAttrs allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:i];
            value1 = [mainUserAttrs objectForKey:value1];
            NSString *value2 = [[[compareAttrs allKeys]sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:i];
            value2 = [compareAttrs objectForKey:value2];
            if (![value1 isEqualToString:value2]) {
                update = true;
            }
        }
    }
    if (update) {
        [compareAttrs setObject:[[SportsAppApi sharedInstance].mainUser.attrs objectForKey:@"rowId" ]forKey:@"accountId"];
        User *user = [[User alloc] initWithDictionary:compareAttrs];
        [[SportsAppApi sharedInstance] updateUser:user WithCompletionBlock:^(NSError *err, id result) {
            if ([result isEqualToString:@"406"]) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Profile Error" message:@"There was a probem updating your profile. Check your connecction and try again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}
@end
