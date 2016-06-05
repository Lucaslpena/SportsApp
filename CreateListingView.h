//
//  CreateListingView.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/9/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsAppApi.h"
#import "LevelView.h"
#import "FAImageView.h"
#import "Listing.h"

#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"

@class CreateListingView;
@protocol CreateListingViewDelegate
-(void)animatedForKeyboard:(BOOL)displayed startingAt:(CGFloat)frameOrigin withHeight:(CGFloat)frameHeight;
-(void)submitPressed;
-(void)changeBannerImageForSport:(NSString *)sport;
@end

@interface CreateListingView : UIView <UITextFieldDelegate, UITextViewDelegate>
@property (assign) id <CreateListingViewDelegate> delegate;

- (IBAction)levelButtonAction:(id)sender;
- (IBAction)sportButtonAction:(id)sender;
- (IBAction)submitButtonAction:(id)sender;
@end
