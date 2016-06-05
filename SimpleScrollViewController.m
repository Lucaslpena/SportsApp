//
//  SimpleScrollViewController.m
//  Sample
//
//  Created by Peter Paulis on 09/08/14.
//  Copyright (c) 2014 min60 s.r.o. - Peter Paulis. All rights reserved.
//

#import "SimpleScrollViewController.h"

@interface SimpleScrollViewController ()

@end

@implementation SimpleScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setBounces:NO];
    [self.sportImage setImage:[UIImage imageNamed:@""]];
    [self.sportImage setContentMode:UIViewContentModeScaleAspectFill];
}
-(void)viewDidAppear:(BOOL)animated {
}
- (void)dealloc{
    self.scrollView.delegate = nil;
}

-(void)scrollToBottomWithAnimation:(BOOL)toggle {
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:bottomOffset animated:toggle];
}
#pragma mark - Contents Below

//Create Listing Below
-(void)initCreateScroll {
    [self.view layoutIfNeeded];
    self.clv = [[CreateListingView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 450)];
    [self.clv setDelegate:self];
    [self.scrollView addSubview:self.clv];
    self.scrollView.contentSize = self.clv.frame.size;

    //[self scrollToBottomWithAnimation:YES];
}
-(void)animatedForKeyboard:(BOOL)displayed startingAt:(CGFloat)frameOrigin withHeight:(CGFloat)frameHeight {
    if (displayed)
    {
        CGFloat y;
        CGFloat offsetHeight = self.scrollView.contentOffset.y;
        y = (offsetHeight + frameOrigin)*2;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        if ((frameOrigin > 110) && (frameOrigin < 280) ){
            self.scrollView.contentSize = CGSizeMake(self.clv.frame.size.width, (self.clv.frame.size.height+frameOrigin/2));
            [self.scrollView setContentOffset:CGPointMake(0, frameOrigin + 10) animated:YES];
        }
        if (frameOrigin > 280){
            if (self.view.frame.size.height < 494)
                self.scrollView.contentSize = CGSizeMake(self.clv.frame.size.width, (self.clv.frame.size.height+frameOrigin/2 + frameHeight-40));
            else
                self.scrollView.contentSize = CGSizeMake(self.clv.frame.size.width, (self.clv.frame.size.height+frameOrigin/2 + frameHeight-5));
            [self.scrollView setContentOffset:CGPointMake(0, frameOrigin) animated:YES];
        }
        [self scrollToBottomWithAnimation:NO];
        [self.scrollView setScrollEnabled:NO];
    }
    else {
        self.scrollView.contentSize = self.clv.frame.size;
        [self.scrollView setScrollEnabled:YES];
        [self scrollToBottomWithAnimation:YES];
    }
}
//View Listing Below
-(void)initDetailScrollWithData:(Listing *)listing {
    [self.view layoutIfNeeded];
    self.ldv = [[ListingDetailView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, 670)];
    [self.ldv setDelegate:self];
    [[SportsAppApi sharedInstance] getImageBySport:[listing.attrs objectForKey:@"sport"] Type:@2 Index:[listing.attrs objectForKey:@"graphicIndex"] WithCompletionBlock:^(NSError *err, id result) {
        [self.sportImage setImage:[UIImage imageWithData:result]];
    }];
    [self.scrollView addSubview:self.ldv];
    [self.ldv setData:listing];
}
-(void)mapWasHidden:(BOOL)trigger {
    if (trigger) {
        self.scrollView.contentSize = CGSizeMake(self.ldv.frame.size.width, self.ldv.frame.size.height-380);
    }
    else {
        self.scrollView.contentSize = self.ldv.frame.size;
    }
}
#pragma mark - Delegate Methods Below
-(void)changeBannerImageForSport:(NSString *)sport {
    [[SportsAppApi sharedInstance] getImageBySport:sport Type:@2 Index:@1 WithCompletionBlock:^(NSError *err, id result) {
        [self.sportImage setImage:[UIImage imageWithData:result]];
    }];
}

-(void)submitPressed {
    [self.delegate triggerClose];
}
@end
