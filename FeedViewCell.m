//
//  FeedViewCell.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "FeedViewCell.h"

@interface FeedViewCell() {
    IBOutlet UIView *view;
    IBOutlet FAImageView *disclosureIndicator;
    NSDictionary *dictionaryPayload;
}
@end

@implementation FeedViewCell {
    ListingSubView *listing1;
    ListingSubView *listing2;
    ListingSubView *listing3;
}

+(CGFloat)returnHeightForListingsWithScreenWidth:(CGFloat)width {
    return (((width - 20)/3) * 1.35) + 10;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
    }
    return self;
}
-(void)resizeViewWidth:(CGFloat) width {
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
    [view layoutIfNeeded];
}
- (IBAction)selectButton:(id)sender {
    [self.delegate categoryTouchPayload:[dictionaryPayload objectForKey:@"categoryName"]];
}
- (void)prepareForReuse
{
    [listing1 removeFromSuperview];
    [listing2 removeFromSuperview];
    [listing3 removeFromSuperview];
}
-(void)initForSubFeeds:(NSArray *)listingArray {
    CGFloat width = (view.frame.size.width - 20)/3;
    CGRect frame = CGRectMake(5, 5, width, width*1.35);
    [self.button setHidden:YES];
    
    if (listingArray.count >= 1) {
    listing1 = [[ListingSubView alloc] initWithFrame:frame];
    [view addSubview:listing1];
    [listing1 setData:[listingArray objectAtIndex:0]];
    [listing1 setDelegate:self];
    frame.origin.x = frame.origin.x + width+5;
    }
    
    if (listingArray.count >=2) {
        listing2 = [[ListingSubView alloc] initWithFrame:frame];
        [view addSubview:listing2];
        [listing2 setData:[listingArray objectAtIndex:1]];
        [listing2 setDelegate:self];
        [listing2 setBackgroundColor:[UIColor redColor]];
        frame.origin.x = frame.origin.x + width+5;
        
        if (listingArray.count >= 3) {
            listing3 = [[ListingSubView alloc] initWithFrame:frame];
            [view addSubview:listing3];
            [listing3 setData:[listingArray objectAtIndex:2]];
            [listing3 setDelegate:self];
        }
    }
    _sportImage.hidden = YES;
    disclosureIndicator.hidden = YES;
    [self setIndentationLevel:0];
    [self setIndentationWidth:0];
}
-(void) initforSport:(NSDictionary *) payload {
    disclosureIndicator.image = nil;
    [disclosureIndicator setDefaultIconIdentifier:@"fa-chevron-right"];
    [disclosureIndicator.defaultView setBackgroundColor:[UIColor clearColor]];
    [disclosureIndicator.defaultView setTextColor:[UIColor lightGrayColor]];
    
    
    self.sportImage.layer.shadowOffset = CGSizeMake(1, 2);
    self.sportImage.layer.shadowRadius = 2;
    self.sportImage.layer.shadowOpacity = 0.5f;
    self.sportImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.sportImage.layer.borderWidth = 0.5f;
    //[self.sportImage setClipsToBounds:YES];
    
    listing1.hidden = YES;
    listing2.hidden = YES;
    listing3.hidden = YES;
    dictionaryPayload = [[NSDictionary alloc] initWithDictionary:payload];
    _sportImage.frame = self.frame;
    [_sportImage setImage:[UIImage imageNamed:[[payload objectForKey:@"categoryName"] lowercaseString]]];
    [_sportImage setImage:[UIImage imageNamed:@""]];
    [[SportsAppApi sharedInstance] getImageBySport:[payload objectForKey:@"categoryName"] Type:@0  Index:@1 WithCompletionBlock:^(NSError *err, id result) {
        [self.sportImage setImage:[UIImage imageWithData:result]];
    }];
    
    [_sportImage setContentMode:UIViewContentModeScaleToFill];
}
- (void)awakeFromNib {
    [view setBackgroundColor:[UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
#pragma mark - Delegate Methods
-(void)listingWasTouched:(id)payload {
    [self.delegate listingTouchPayload:payload];
}
@end
