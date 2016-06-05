//
//  AccountListingsCell.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/15/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "CostView.h"
#import "LevelView.h"
#import "FAImageView.h"
#import "UIFont+FontAwesome.h"
#import "SportsAppApi.h"

@class AccountListingsCell;
@protocol AccountListingsCellDelegate
-(void)listingWasTouched:(Listing *)payload;
@end


@interface AccountListingsCell : UITableViewCell
@property (assign) id <AccountListingsCellDelegate> delegate;

- (IBAction)listingPress:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *view;
-(void)resizeViewWidth:(CGFloat) width;
-(void)setData:(Listing *)listing;
@end
