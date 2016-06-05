//
//  ListingFeedViewController.h
//  SportsApp
//
//  Created by Lucas L. Pena on 12/11/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsAppApi.h"
#import "ListingHorizontalViewCell.h"
#import "PopupFrameView.h"
#import "Listing.h"
#import "NSString+FontAwesome.h"
#import "HeaderFeedView.h"
#import "NSArray+Listing.h"

@interface ListingFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,ListingHorizontalViewCellDelegate, PopupFrameViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSDictionary *listingsHolder;
- (IBAction)searchTrigger:(id)sender;
-(void)initWithCategory:(NSString *)category;
@end
