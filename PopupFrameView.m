//
//  PopupFrameView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/9/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "PopupFrameView.h"

@implementation PopupFrameView {
    SimpleScrollViewController *ssv;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"PopupFrameView" owner:self options:nil] objectAtIndex:0];
        [xibView setFrame:[self bounds]];
        [self addSubview:xibView];
        [self layoutIfNeeded];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5f;
        self.buttonImage.image = nil;
        [self.buttonImage setDefaultIconIdentifier:@"fa-times-circle-o"];
        [self.buttonImage.defaultView setBackgroundColor:[UIColor lightGrayColor]];
        [self.buttonImage.defaultView setTextColor:[UIColor blackColor]];
        [self.buttonImage.defaultView.layer setCornerRadius:11];
        [self.buttonImage.defaultView setClipsToBounds:YES];
        
        //[self.scrollView setDelegate:self];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"PopupFrameView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:xibView];
    }
    return self;
}
-(void)loadSubViewsForCreateScroll {
    ssv = [SimpleScrollViewController new];
    [ssv setDelegate:self];
    ssv.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [ssv initCreateScroll];
    [self.parentController addChildViewController:ssv];
    [self.view addSubview:ssv.view];
    [self.view sendSubviewToBack:ssv.view];
    [ssv didMoveToParentViewController:self.parentController];
}
-(void)loadSubViewsForDetailView:(Listing *)listing {
    ssv = [SimpleScrollViewController new];
    [ssv setDelegate:self];
    ssv.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [ssv initDetailScrollWithData:listing];
    [self.parentController addChildViewController:ssv];
    [self.view addSubview:ssv.view];
    [self.view sendSubviewToBack:ssv.view];
    [ssv didMoveToParentViewController:self.parentController];
}
- (IBAction)closePopup:(id)sender {
    [self animateClosed];
}
-(void)animateClosed {
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (0% scale)
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self.delegate popupFrameDidOpen:NO];
    }];
}
-(void)animateOpen {
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        [self.delegate popupFrameDidOpen:YES];
    }];
}
#pragma mark -  Delegate Methods
-(void)triggerClose {
    [self animateClosed];
}
@end
