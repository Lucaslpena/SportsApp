//
//  CostView.m
//  SportsApp
//
//  Created by Lucas L. Pena on 12/10/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "CostView.h"

@interface CostView() {
    IBOutlet UIView *view;
    IBOutlet UILabel *moneySign;
    IBOutlet UILabel *price;
}
@end

@implementation CostView
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [[NSBundle mainBundle] loadNibNamed:@"CostView" owner:self options:nil];
        self.bounds = view.bounds;
        [self addSubview:view];
        [self layoutIfNeeded];
    }
    return self;
}
-(void)setText:(NSString *)text {
    [price setText:text];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@",text] attributes:@{NSFontAttributeName: font}];
    [attributedString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:10], NSBaselineOffsetAttributeName : @5} range:NSMakeRange(0, 1)];
    price.attributedText = attributedString;
}
-(void)alignRight {
    price.textAlignment = NSTextAlignmentRight;
}
-(void)alignCenterWithText:(NSString *)text {
    price.textAlignment = NSTextAlignmentCenter;
    [price setText:text];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:22];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@",text] attributes:@{NSFontAttributeName: font}];
    [attributedString setAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:12], NSBaselineOffsetAttributeName : @6} range:NSMakeRange(0, 1)];
    price.attributedText = attributedString;

}
@end
