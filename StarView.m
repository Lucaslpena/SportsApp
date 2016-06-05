//
//  StarView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 1/14/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "StarView.h"

@interface StarView() {
    IBOutlet UIView *view;
    NSMutableArray *starLabelArray;
    NSMutableArray *buttonArray;
    int starSize;
    bool triggered;
}
@end

@implementation StarView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [[NSBundle mainBundle] loadNibNamed:@"StarView" owner:self options:nil];
        self.bounds = view.bounds;
        [self addSubview:view];
        [self layoutIfNeeded];
        starLabelArray = [[NSMutableArray alloc] init];
        starSize = 20;
        triggered = false;
    }
    return self;
}
-(void) initializeStars {
    CGFloat xOrgin = 0;
    for (int i = 0; i < 5; ++i) {
        UIImageView *star = [[UIImageView alloc] initWithFrame:CGRectMake(xOrgin, 0, view.frame.size.width/5, view.frame.size.height)];
        [star setImage:[UIImage imageNamed:@"star_unfilled_200"]];
        [star setContentMode:UIViewContentModeScaleAspectFit];
        [view addSubview:star];
        [starLabelArray addObject:star];
        xOrgin += view.frame.size.width/5;
    }
    if (starSize != 20) {
        [self initButtons];
    }
}
-(void)setStars:(float)num {
    if (!triggered) {
        [self initializeStars];
        triggered = true;
    }
    for (UIImageView *star in starLabelArray) {
        [star setImage:[UIImage imageNamed:@"star_unfilled_200"]];
    }
    for ( int i = 0; i < ceil(num); ++i) {
        UIImageView *star = [starLabelArray objectAtIndex:i];
        [star setImage:[UIImage imageNamed:@"star_filled_200"]];
        if( (ceil(num) != num) && (i == (ceil(num)-1)) ) {
            [star setImage:[UIImage imageNamed:@"star_halfFilled_200"]];
        }
    }
}
-(void)setVariableSize:(float)num {
    starSize = num;
}
-(void)initButtons {
    CGFloat xOrgin = 0;
    for (int i = 0; i < 5; ++i) {
        UIButton *starButton = [[UIButton alloc] initWithFrame:CGRectMake(xOrgin, 0, view.frame.size.width/5, view.frame.size.height)];
        [starButton addTarget:self action:@selector(starPress:) forControlEvents:UIControlEventTouchUpInside];
        [starButton setTitle:@"" forState:UIControlStateNormal];
        [starButton setTag:i];
        [view addSubview:starButton];
        [buttonArray addObject:starButton];
        xOrgin += view.frame.size.width/5;
    }
}
- (IBAction)starPress:(id)sender {
    UIButton *button = (UIButton *)sender;
    [self setStars:button.tag + 1];
#warning TODO - handle saving rating
}
@end
