//
//  PopupFrameView.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/9/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateListingView.h"
#import "ListingDetailView.h"
#import "FAImageView.h"


#import "SimpleScrollViewController.h"

@class PopupFrameView;
@protocol PopupFrameViewDelegate
-(void)popupFrameDidOpen:(bool)open;
@end

@interface PopupFrameView : UIView <UIScrollViewDelegate, SimpleScrollViewControllerDelegate>

@property (assign) id <PopupFrameViewDelegate> delegate;
@property (strong, nonatomic) ListingDetailView *ldv;
@property (strong, nonatomic) CreateListingView *clv;
@property (strong, nonatomic) UIViewController *parentController;
@property (strong, nonatomic) IBOutlet UIView *view;
- (IBAction)closePopup:(id)sender;
@property (strong, nonatomic) IBOutlet FAImageView *buttonImage;

-(void)loadSubViewsForCreateScroll;
-(void)loadSubViewsForDetailView:(Listing *)listing;
-(void)animateOpen;

@end
