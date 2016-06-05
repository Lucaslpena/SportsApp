//
//  SellingListingView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/16/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "SellingListingView.h"

@interface SellingListingView() {
    IBOutlet CostView *costView;
    IBOutlet UILabel *placeLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UIImageView *sportImage;
    IBOutlet UIView *view;
    IBOutlet UITextView *notesView;
    IBOutlet UIButton *removeButton;
}

@end

@implementation SellingListingView {
    Listing *data;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"SellingListingView" owner:self options:nil] objectAtIndex:0];
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
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"SellingListingView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:xibView];
    }
    return self;
}
-(void)initContents {
    [removeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [removeButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
    removeButton.layer.shadowOffset = CGSizeMake(1, 2);
    removeButton.layer.shadowRadius = 2;
    removeButton.layer.shadowOpacity = .3;
    [notesView setDelegate:self];
    [notesView setEditable:NO];
}
- (IBAction)removeAction:(id)sender {
#warning TODO - handle This action
}

-(void)setData:(Listing *)listing {
    [placeLabel setText:[listing.attrs objectForKey:@"shortName"]];
    [costView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"listingPrice"]]];
    [costView alignRight];
    
    if ([listing.attrs objectForKey:@"notes"] != nil) {
            [notesView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"notes"]]];
    }
    SportsAppApi *apiInstance = [[SportsAppApi alloc] init]; //multipl instances needed because singleton was leading to bugs with concurency
    [apiInstance getImageBySport:[listing.attrs objectForKey:@"sport"] Type:@0 Index:[listing.attrs objectForKey:@"graphicIndex"] WithCompletionBlock:^(NSError *err, id result) {
        [sportImage setImage:[UIImage imageWithData:result]];
    }];
    data = listing;
}
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    
}
@end

