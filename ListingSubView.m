//
//  ListingSubView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "ListingSubView.h"
@implementation ListingSubView {
    Listing *data;
    bool pressed;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"ListingSubView" owner:self options:nil] objectAtIndex:0];
        [xibView setFrame:[self bounds]];
        [self addSubview:xibView];
        [self initContents];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [[NSBundle mainBundle] loadNibNamed:@"ListingSubView" owner:self options:nil];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5f;
        [self addSubview:self.view];
        [self initContents];
    }
    return self;
}
-(void)initContents {
    pressed = false;
    [self.view layoutIfNeeded];
    self.layer.shadowOffset = CGSizeMake(1, 2);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.3;
    [self.view.layer setBorderWidth:.75f];
    [self.view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    self.sportImage.layer.shadowOffset = CGSizeMake(0, 2);
    self.sportImage.layer.shadowRadius = .5;
    self.sportImage.layer.shadowOpacity = .3;
    [self.sportImage setClipsToBounds:YES];
    [self.sportImage setImage:[UIImage imageNamed:@""]];
}
-(void)setData:(Listing *)listing {
    [self.mainLabel setText:[listing.attrs objectForKey:@"shortName"]];
    [self.costView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"listingPrice"]]];
    [self.levelView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"skillLevel"]]];
#warning TODO - see if bug is still peristent with shared instance
    SportsAppApi *apiInstance = [[SportsAppApi alloc] init]; //multipl instances needed because singleton was leading to bugs with concurency
    [apiInstance getImageBySport:[listing.attrs objectForKey:@"sport"] Type:@1 Index:[listing.attrs objectForKey:@"graphicIndex"] WithCompletionBlock:^(NSError *err, id result) {
        [self.sportImage setImage:[UIImage imageWithData:result]];
    }];
    data = listing;
}
- (IBAction)pressedAction:(id)sender {
    if (!pressed) {
        pressed = true;
        [self.delegate listingWasTouched:data];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pressed = false;
    });
    
}
@end
