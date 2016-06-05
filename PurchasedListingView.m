//
//  PurchasedListingView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/16/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "PurchasedListingView.h"

@interface PurchasedListingView() {
    IBOutlet CostView *costView;
    IBOutlet LevelView *levelView;
    IBOutlet UILabel *placeLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UIImageView *sportImage;
    IBOutlet UIView *view;
    IBOutlet UIButton *problemButton;
    IBOutlet StarView *starView;
}
@end

@implementation PurchasedListingView {
    Listing *data;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"PurchasedListingView" owner:self options:nil] objectAtIndex:0];
        [xibView setFrame:[self bounds]];
        [self addSubview:xibView];
        [self layoutIfNeeded];
        [self initContents];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"PurchasedListingView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:xibView];
    }
    return self;
}
-(void)initContents {
    [problemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [problemButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
    problemButton.layer.shadowOffset = CGSizeMake(1, 2);
    problemButton.layer.shadowRadius = 2;
    problemButton.layer.shadowOpacity = .3;
    [starView setVariableSize:50];
}
-(void)setData:(Listing *)listing {
    [placeLabel setText:[listing.attrs objectForKey:@"shortName"]];
    [costView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"listingPrice"]]];
    [levelView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"skillLevel"]]];
    SportsAppApi *apiInstance = [[SportsAppApi alloc] init]; //multipl instances needed because singleton was leading to bugs with concurency
    [apiInstance getImageBySport:[listing.attrs objectForKey:@"sport"] Type:@0 Index:[listing.attrs objectForKey:@"graphicIndex"] WithCompletionBlock:^(NSError *err, id result) {
        [sportImage setImage:[UIImage imageWithData:result]];
    }];
    data = listing;
    [starView setStars:0];
}
@end
