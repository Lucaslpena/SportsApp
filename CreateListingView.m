//
//  CreateListingView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/9/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "CreateListingView.h"

@interface CreateListingView () {
    IBOutlet LevelView *levelView;
    IBOutlet UIButton *sportButton;
    IBOutlet UITextField *locationNameField;
    IBOutlet UITextView *locationField;
    IBOutlet UITextField *timeField;
    IBOutlet UILabel *requiredLevelLabel;
    IBOutlet UITextView *notesField;
    IBOutlet UITextField *priceField;
    IBOutlet UIButton *postButton;
    Listing *createdListing;
    NSMutableArray *sportsDisplayName;
    NSNumberFormatter *formatter;
}

@end

@implementation CreateListingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"CreateListingView" owner:self options:nil] objectAtIndex:0];
        [xibView setFrame:[self bounds]];
        [self addSubview:xibView];
        [self layoutIfNeeded];
        
        sportsDisplayName = [[NSMutableArray alloc] init];
        [[SportsAppApi sharedInstance] getSportsWithCompletionBlock:^(NSError *err, id result) {
            for (NSDictionary *sport in result) {
                [sportsDisplayName addObject:[sport objectForKey:@"displayName"]];
            }
        }];
        
        sportButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [levelView.label setText:@"?"];
        [levelView enableHighlight:YES];
        
        [postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [postButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
        postButton.layer.shadowOffset = CGSizeMake(1, 2);
        postButton.layer.shadowRadius = 2;
        postButton.layer.shadowOpacity = .3;
        
        [priceField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [priceField.layer setBorderWidth:1.0];
        priceField.layer.cornerRadius = 5;
        priceField.clipsToBounds = YES;
        [priceField setDelegate:self];
        [priceField setTag:2];
        
        [locationNameField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [locationNameField.layer setBorderWidth:1.0];
        locationNameField.layer.cornerRadius = 5;
        locationNameField.clipsToBounds = YES;
        [locationNameField setDelegate:self];
        [locationNameField setDelegate:self];

        [timeField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [timeField.layer setBorderWidth:1.0];
        timeField.layer.cornerRadius = 5;
        timeField.clipsToBounds = YES;
        [timeField setDelegate:self];
        [timeField setTag:1];

        [locationField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [locationField.layer setBorderWidth:1.0];
        locationField.layer.cornerRadius = 5;
        locationField.clipsToBounds = YES;
        [locationField setDelegate:self];
        [locationField setTag:0];
        
        [notesField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
        [notesField.layer setBorderWidth:1.0];
        notesField.layer.cornerRadius = 5;
        notesField.clipsToBounds = YES;
        [notesField setDelegate:self];
        [notesField setTag:1];
        
        createdListing = [[Listing alloc] init];
        
        formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"CreateListingView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:xibView];
    }
    return self;
}

#pragma mark - Text Fields and Text Views below
//Keyboard Dismiss
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self setPlaceHolderForTextView:textView];
    [self.delegate animatedForKeyboard:YES startingAt:textView.frame.origin.y withHeight:textView.frame.size.height];
    return true;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self setPlaceHolderForTextView:textView];
    [self.delegate animatedForKeyboard:NO startingAt:textView.frame.origin.y withHeight:textView.frame.size.height];
    return true;
}
-(void)setPlaceHolderForTextView:(UITextView *)textView {
    //placeholder text
    if ([textView.text isEqualToString:@"location"] || [textView.text isEqualToString:@"notes"]) {
        [textView setTextColor:[UIColor blackColor]];
        [textView setText:@""];
    }
    else if ([textView.text isEqualToString:@""]) {
        switch (textView.tag) {
            case 0:
                [textView setText:@"location"];
                break;
            case 1:
                [textView setText:@"notes"];
                break;
        }
        [textView setTextColor:[UIColor lightGrayColor]];
    }
}
//TextFields~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (BOOL)textFieldShouldReturn:(UITextField *)textfield {
    [textfield resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        [textField resignFirstResponder];
        ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc]
                                             initWithTitle:@""
                                             datePickerMode:UIDatePickerModeDateAndTime
                                             selectedDate:[NSDate dateWithTimeIntervalSinceNow:3600]
                                             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                 [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                                 NSString *timeStamp = [dateFormatter stringFromDate:selectedDate];
                                                 [createdListing.attrs setObject:timeStamp forKey:@"gameTime"];
                                                 
                                                 [dateFormatter setDateFormat:@"MMM dd '@' h:mm a"];
                                                 [timeField setText:[dateFormatter stringFromDate:selectedDate]];
                                             } cancelBlock:^(ActionSheetDatePicker *picker) {
                                                 //
                                             } origin:self];
        [datePicker setMinuteInterval:5];
        [datePicker setMinimumDate:[NSDate date]];
        [datePicker showActionSheetPicker];
    }
    else {
        [self.delegate animatedForKeyboard:YES startingAt:textField.frame.origin.y withHeight:textField.frame.size.height];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.delegate animatedForKeyboard:NO startingAt:textField.frame.origin.y withHeight:textField.frame.size.height];
}
#pragma mark - Buttons Below
- (IBAction)levelButtonAction:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Level"
                                            rows:@[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10]
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, NSNumber* selectedValue) {
                                           [createdListing.attrs setObject:selectedValue forKey:@"skillLevel"];
                                           [levelView.label setText:selectedValue.stringValue];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) { }
                                          origin:sender];
}
- (IBAction)sportButtonAction:(id)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"Select a Sport"
                                            rows:sportsDisplayName
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           [createdListing.attrs setObject:[[SportsAppApi sharedInstance] convertToCategoryNameWithDisplayName:selectedValue] forKey:@"sport"];
                                           [sportButton setTitle:selectedValue forState:UIControlStateNormal];
                                           [self.delegate changeBannerImageForSport:[[SportsAppApi sharedInstance] convertToCategoryNameWithDisplayName:selectedValue]];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) { }
                                          origin:sender];
}
- (IBAction)submitButtonAction:(id)sender {
    [self endEditing:YES];
    if (([self checkPrice]) && ([self checkSport]) && ([self checkShortName]) && ([self checkTime]) && ([self checkLevel])){
        
        [createdListing.attrs setValue:[formatter numberFromString:priceField.text] forKey:@"listingPrice"];
        if ((![locationField.text isEqualToString:@"location"]) && (locationField.text.length > 0) )
            [createdListing.attrs setValue:locationField.text forKey:@"location"];
        if ((![notesField.text isEqualToString:@"notes"]) && (notesField.text.length > 0) )
            [createdListing.attrs setValue:notesField.text forKey:@"notes"];
        [[SportsAppApi sharedInstance] createListing:createdListing withCompletionBlock:^(NSError *err, NSString *result) {
            if ((!err) && (![result isEqualToString:@"406"]) ){
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Listing was successfully posted!" message:nil delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
                [alert show];
                [self.delegate submitPressed];
            }
            else [self  triggerAlertFor:@"Something went wrong, Listing wasn't saved"];
        }];
    }
}
#pragma mark - Error Checking
-(BOOL)checkPrice {
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"^[0-9]+([.][0-9]{2})?$"
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    if ([regex numberOfMatchesInString:priceField.text options:0 range:NSMakeRange(0, priceField.text.length)]) {
        return true;
    }
    [self triggerAlertFor:@"Incorrect Price Entered"];
    return false;
}
-(BOOL)checkSport {
    if  ([sportButton.titleLabel.text isEqualToString:@"Select Sport"]) {
        [self triggerAlertFor:@"Please Select a Sport"];
        return false;
    }
    return true;
}
-(BOOL)checkTime {
    if (timeField.text.length != 0)
        return true;
    [self triggerAlertFor:@"Please Select a Time"];
    return false;
}
-(BOOL)checkLevel {
    if (levelView.label.text.length != 0)
        return true;
    [self triggerAlertFor:@"Please Select a Level"];
    return false;
}
-(BOOL)checkShortName {
    if ([locationNameField.text isEqualToString:@""]) {
        [self triggerAlertFor:@"Please Name Your Listing"];
        return false;
    }
    [createdListing.attrs setValue:locationNameField.text forKey:@"shortName"];
    return true;
}
#pragma mark - Alert
-(void)triggerAlertFor:(NSString *)alertString {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Listing Error" message:alertString delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
    [alert show];
}
@end
