//
//  ListingDetailView.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/9/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsAppApi.h"
#import <GoogleMaps/GoogleMaps.h>
#import "CostView.h"
#import "LevelView.h"
#import "Listing.h"
#import "StarView.h"

@class ListingDetailView;
@protocol ListingDetailViewDelegate
-(void)mapWasHidden:(BOOL)trigger;
@end

@interface ListingDetailView : UIView <GMSMapViewDelegate>
@property (assign) id <ListingDetailViewDelegate> delegate;
- (IBAction)buyAction:(id)sender;

-(void)setData:(Listing *)listing;
@end
