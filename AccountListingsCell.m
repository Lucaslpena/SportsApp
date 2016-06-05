//
//  AccountListingsCell.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/15/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "AccountListingsCell.h"

@interface AccountListingsCell() {
    IBOutlet CostView *costView;
    IBOutlet LevelView *levelView;
    IBOutlet UILabel *placeLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UIImageView *sportImage;
}
@end

@implementation AccountListingsCell {
    Listing *data;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)awakeFromNib {
    self.view.layer.shadowOffset = CGSizeMake(1, 2);
    self.view.layer.shadowRadius = 2;
    self.view.layer.shadowOpacity = 0.3;
    [self.view.layer setBorderWidth:.75f];
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [sportImage setClipsToBounds:YES];
    [costView setText:@"111.11"];
    [levelView setText:@"0"];
    [levelView enableHighlight:NO];
    [placeLabel setNumberOfLines:2];
    [addressLabel setNumberOfLines:3];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)resizeViewWidth:(CGFloat) width {
    CGRect frame = self.view.frame;
    frame.size.width = width;
    self.view.frame = frame;
    [self.view layoutIfNeeded];
    UILabel *disclosureIndicator = [[UILabel alloc] initWithFrame:CGRectMake(width-15, self.view.center.y-30, 50, 35)];
    [self.view addSubview:disclosureIndicator];
    [disclosureIndicator setTextColor:[UIColor lightGrayColor]];
    [disclosureIndicator setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:20]];
    [disclosureIndicator setText:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-chevron-right"]];

    [self.view layoutIfNeeded];
    
    [placeLabel sizeToFit];
    [addressLabel sizeToFit];
}
-(void)setData:(Listing *)listing {
    [[SportsAppApi sharedInstance] getListingsById:[listing.attrs objectForKey:@"listingId"] WithCompletionBlock:^(NSError *err, id result) {
        Listing *resultListing = (Listing *)result;
        [placeLabel setText:[resultListing.attrs objectForKey:@"shortName"]];
        [costView setText:[NSString stringWithFormat:@"%@",[resultListing.attrs objectForKey:@"listingPrice"]]];
        [levelView setText:[NSString stringWithFormat:@"%@",[resultListing.attrs objectForKey:@"skillLevel"]]];
        SportsAppApi *apiInstance = [[SportsAppApi alloc] init]; //multipl instances needed because singleton was leading to bugs with concurency
        [apiInstance getImageBySport:[resultListing.attrs objectForKey:@"sport"] Type:@1 Index:[listing.attrs objectForKey:@"graphicIndex"] WithCompletionBlock:^(NSError *err, id result) {
            [sportImage setImage:[UIImage imageWithData:result]];
        }];
        [timeLabel setText:listing.getStartingDateString];
        data = listing;
    }];
    
//    [placeLabel setText:[listing.attrs objectForKey:@"shortName"]];
//    [costView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"listingPrice"]]];
//    [levelView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"skillLevel"]]];
//    SportsAppApi *apiInstance = [[SportsAppApi alloc] init]; //multipl instances needed because singleton was leading to bugs with concurency
//    [apiInstance getImageBySport:[listing.attrs objectForKey:@"sport"] Type:@1 Index:[listing.attrs objectForKey:@"graphicIndex"] WithCompletionBlock:^(NSError *err, id result) {
//        [sportImage setImage:[UIImage imageWithData:result]];
//    }];
//    [timeLabel setText:listing.getStartingDateString];
//    data = listing;
}
- (IBAction)listingPress:(id)sender {
    [self.delegate listingWasTouched:data];
}
@end
