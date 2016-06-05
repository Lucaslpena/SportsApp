//
//  SellingListingViewController.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/16/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SellingListingView.h"
#import "Listing.h"
#import "SportsAppApi.h"
@interface SellingListingViewController : UIViewController
-(void)setListing:(Listing *)listing;
@end
