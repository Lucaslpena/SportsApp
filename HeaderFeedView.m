//
//  HeaderFeedView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/8/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "HeaderFeedView.h"

@interface HeaderFeedView() {
    IBOutlet UILabel *sectionLabel;
    IBOutlet UIButton *sectionButton;
    IBOutlet UIView *view;
}
@end

@implementation HeaderFeedView {
    NSString *catagory_id;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderFeedView" owner:self options:nil];
        self.bounds =view.bounds;
        [sectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sectionButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
        [self addSubview:view];
        [view setBackgroundColor:[UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f]];
        sectionButton.layer.shadowOffset = CGSizeMake(1, 2);
        sectionButton.layer.shadowRadius = 2;
        sectionButton.layer.shadowOpacity = .3;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [[NSBundle mainBundle] loadNibNamed:@"HeaderFeedView" owner:self options:nil];
        [self addSubview:view];
    }
    return self;
}
- (IBAction)pressedAction:(id)sender {
    [self.delegate sectionButtonPressed:catagory_id];
}
-(void)setButtonText:(NSUInteger)number {
    if (number > 1)
        [sectionButton setTitle:[NSString stringWithFormat:@"%lu listings",(unsigned long)number] forState:UIControlStateNormal];
    else
        [sectionButton setTitle:[NSString stringWithFormat:@"%lu listing",(unsigned long)number] forState:UIControlStateNormal];
}
-(void)setPressPayload:(NSString *)paylod {
    catagory_id = [[NSString alloc] initWithString:paylod];
}
-(void)setLabelText:(NSString *)text {
    [sectionLabel setText:text];
}
-(void)setButtonHidden {
    [sectionButton setHidden:YES];
}
@end
