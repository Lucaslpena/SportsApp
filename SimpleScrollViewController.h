//
//  SimpleScrollViewController.h
//  Sample
//
//  Created by Peter Paulis on 09/08/14.
//  Copyright (c) 2014 min60 s.r.o. - Peter Paulis. All rights reserved.
//

#import "M6UniversalParallaxViewController.h"
#import "ListingDetailView.h"
#import "CreateListingView.h"

@class SimpleScrollViewController;
@protocol SimpleScrollViewControllerDelegate
-(void)triggerClose;
@end

@interface SimpleScrollViewController : M6UniversalParallaxViewController <CreateListingViewDelegate, ListingDetailViewDelegate>
@property (assign) id <SimpleScrollViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *scrollViewContent;
@property (strong, nonatomic) IBOutlet UIImageView *sportImage;
@property (strong, nonatomic) ListingDetailView *ldv;
@property (strong, nonatomic) CreateListingView *clv;
-(void)initDetailScrollWithData:(Listing *)listing;
-(void)initCreateScroll;

@end
