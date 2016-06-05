//
//  ListingSubView.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsAppApi.h"
#import "LevelView.h"
#import "CostView.h"
#import "Listing.h"

@class ListingSubView;
@protocol ListingSubViewDelegate
-(void)listingWasTouched:(Listing *)payload;
@end

@interface ListingSubView : UIView
@property (assign) id <ListingSubViewDelegate> delegate;

@property float rectRatio;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UIImageView *sportImage;
@property (strong, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) IBOutlet LevelView *levelView;
@property (strong, nonatomic) IBOutlet CostView *costView;
- (IBAction)pressedAction:(id)sender;
-(void)setData:(Listing *)listing;

@end
