//
//  PurchasedListingView.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/16/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Listing.h"
#import "CostView.h"
#import "LevelView.h"
#import "SportsAppApi.h"
#import "Listing.h"
#import "StarView.h"

@interface PurchasedListingView : UIView
-(void)setData:(Listing *)listing;
@end
