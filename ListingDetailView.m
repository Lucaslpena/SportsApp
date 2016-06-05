//
//  ListingDetailView.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/9/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "ListingDetailView.h"

@interface ListingDetailView() {
    IBOutlet UIView *view;
    IBOutlet UIButton *buyButton;
    IBOutlet CostView *costView;
    IBOutlet LevelView *levelView;
    IBOutlet UILabel *sport;
    IBOutlet UILabel *locationName;
    IBOutlet UILabel *locationAddress;
    IBOutlet UILabel *startingTime;
    IBOutlet UILabel *notes;
    IBOutlet GMSMapView *mapView;
    IBOutlet StarView *starView;
    IBOutlet UIView *mapPlaceholder;
    IBOutlet UILabel *locationLabel;
}
@end

@implementation ListingDetailView {
    NSDictionary *data;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"ListingDetailView" owner:self options:nil] objectAtIndex:0];
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
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"ListingDetailView" owner:self options:nil] objectAtIndex:0];
        [self addSubview:xibView];
    }
    return self;
}
-(void) initContents {
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
    buyButton.layer.shadowOffset = CGSizeMake(1, 2);
    buyButton.layer.shadowRadius = 2;
    buyButton.layer.shadowOpacity = .3;
}
-(void)setData:(Listing *)listing {
    data = [[NSDictionary alloc] initWithDictionary:listing.attrs];
    [costView alignCenterWithText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"listingPrice"]]];
    [levelView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"skillLevel"] ]];
    [levelView enableHighlight:YES];
    [locationName setText:[listing.attrs objectForKey:@"shortName"]];
    [startingTime setText:listing.getStartingDateString];
    
    NSString *noteString = [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"description"]]];
    if ([noteString isEqualToString:@"(null)"])
        [notes setText:@" "];
    else
        [notes setText:noteString];
    
#warning TODO - get User rating number!
    [starView setStars:0];
    
    [sport setText:[[SportsAppApi sharedInstance] convertToDisplayNameWithCatagoryName:[listing.attrs objectForKey:@"sport"]]];
    
    
    NSString *address = [[NSString alloc] initWithString:[listing getCompleteAddress]];
    //if (address == nil) {
        address = @"";
    //}
    [locationAddress setText:address];
    [self layoutIfNeeded];
    
    bool customLocation = false;
    if ([listing.attrs objectForKey:@"locLongitude"]) {
        NSNumber *number = [listing.attrs objectForKey:@"locLongitude"];
        float lon = number.floatValue;
        number = [listing.attrs objectForKey:@"locLatitude"];
        float lat = number.floatValue;
        customLocation = true;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:10];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = camera.target;
        marker.appearAnimation = kGMSMarkerAnimationPop;
        marker.map = mapView;
        [mapView setDelegate:self];
        [mapView setCamera:camera];
        [mapView.settings setScrollGestures:FALSE];
        [mapView.settings setZoomGestures:FALSE];
        [mapView.settings setTiltGestures:FALSE];
        [mapView.settings setConsumesGesturesInView:FALSE];
    }
    else {
        [mapView setHidden:YES];
        [locationLabel setText:@"No Location Given"];
    }
    [self.delegate mapWasHidden:!customLocation];
    [self layoutIfNeeded];
}
- (IBAction)buyAction:(id)sender {
    [[SportsAppApi sharedInstance] buyListingWithId:[data objectForKey:@"rowId"] WithCompletionBlock:^(NSError *err, id result) {
    
    }];
}
@end
