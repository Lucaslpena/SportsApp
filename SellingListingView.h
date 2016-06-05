//
//  SellingListingView.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/16/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsAppApi.h"
#import "CostView.h"
#import "Listing.h"

@interface SellingListingView : UIView <UITextViewDelegate>
- (IBAction)removeAction:(id)sender;
-(void)setData:(Listing *)listing;
@end
