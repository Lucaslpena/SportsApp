//
//  FeedViewCell.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListingSubView.h"
#import "Listing.h"
#import "FAImageView.h"

@class FeedViewCell;
@protocol FeedViewCellDelegate
-(void)listingTouchPayload:(NSDictionary *)payload;
-(void)categoryTouchPayload:(NSString *)payload;
@end

@interface FeedViewCell : UITableViewCell <ListingSubViewDelegate>
@property (assign) id <FeedViewCellDelegate> delegate;

+(CGFloat)returnHeightForListingsWithScreenWidth:(CGFloat) width;
@property (strong, nonatomic) IBOutlet UIImageView *sportImage;
- (IBAction)selectButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *button;
-(void)initForSubFeeds:(NSArray *)listingArray;
-(void) initforSport:(NSDictionary *) payload;
-(void)resizeViewWidth:(CGFloat) width;
@end
