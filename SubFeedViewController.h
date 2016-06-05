//
//  SubFeedViewController.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "HeaderFeedView.h"
#import "FeedViewCell.h"
#import "PopupFrameView.h"
#import "ListingFeedViewController.h"
#import "SportsAppApi.h"
#import "FAImageView.h"
#import "NSString+FontAwesome.h"
#import "NSArray+Listing.h"

@interface SubFeedViewController : UITableViewController <PopupFrameViewDelegate, FeedViewCellDelegate, HeaderFeedViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@end
