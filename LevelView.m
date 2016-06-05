//
//  LevelView.m
//  SportsApp
//
//  Created by Lucas L. Pena on 12/10/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "LevelView.h"

@implementation LevelView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [[NSBundle mainBundle] loadNibNamed:@"LevelView" owner:self options:nil];
        self.bounds = self.view.bounds;
        [self addSubview:self.view];
        [self layoutIfNeeded];
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    }
    return self;
}
-(void)setText:(NSString *)text {
    [self.label setText:text];
    [self createCircle];
}
-(void)createCircle {
    [self.view layoutIfNeeded];
    self.label.layer.cornerRadius = self.label.frame.size.height / 2;
    [self.label.layer setBorderWidth:.5];
    [self.label.layer setBorderColor:[UIColor blackColor].CGColor];
    self.label.layer.masksToBounds = YES;
}
-(void)enableHighlight:(BOOL)toggle{
    if (toggle) {
        [self.label setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
        [self.label setTextColor:[UIColor whiteColor]];
    } else {
        [self.label setBackgroundColor:[UIColor whiteColor]];
        [self.label setTextColor:[UIColor blackColor]];
    }
    [self createCircle];
}
@end
