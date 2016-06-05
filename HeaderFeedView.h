//
//  HeaderFeedView.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeaderFeedView;
@protocol HeaderFeedViewDelegate
-(void)sectionButtonPressed:(NSString *)payload;
@end

@interface HeaderFeedView : UIView
@property (assign) id <HeaderFeedViewDelegate> delegate;
-(void)setLabelText:(NSString *)text;
-(void)setPressPayload:(NSString *)payod;
- (IBAction)pressedAction:(id)sender;
-(void)setButtonText:(NSUInteger)number;
-(void)setButtonHidden;
@end
