//
//  ListingHorizontalViewCell.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/9/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsAppApi.h"
#import "LevelView.h"
#import "CostView.h"
#import "Listing.h"

@class ListingHorizontalViewCell;
@protocol ListingHorizontalViewCellDelegate
-(void)listingWasTouched:(Listing *)payload;
@end

@interface ListingHorizontalViewCell : UITableViewCell
@property (assign) id <ListingHorizontalViewCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *subView;
@property (strong, nonatomic) IBOutlet UIView *view;

- (IBAction)pressedAction:(id)sender;
-(void)setData:(Listing *)listing;
@end
