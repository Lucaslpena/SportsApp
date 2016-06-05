//
//  ListingHorizontalViewCell.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/9/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "ListingHorizontalViewCell.h"

@interface ListingHorizontalViewCell() {
    IBOutlet CostView *costView;
    IBOutlet LevelView *levelView;
    IBOutlet UILabel *placeLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UIImageView *sportImage;
}
@end


@implementation ListingHorizontalViewCell  {
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
    [self.view setBackgroundColor:[UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f]];
    self.subView.layer.shadowOffset = CGSizeMake(1, 2);
    self.subView.layer.shadowRadius = 2;
    self.subView.layer.shadowOpacity = 0.3;
    self.subView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [sportImage setClipsToBounds:YES];
    [sportImage setImage:[UIImage imageNamed:@""]];


//    self.subView.layer.borderWidth = .5f;
//    CGRect imageFrame = CGRectMake(sportImage.frame.origin.x, sportImage.frame.origin.y, (self.view.frame.size.width / 3),sportImage.frame.size.height);
//    sportImage.frame = imageFrame;
//    sportImage.bounds = imageFrame;
//    [self layoutIfNeeded];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setData:(Listing*)listing {
//    [self.sportImage setImage:[UIImage imageNamed:[payload objectForKey:@"banner_image_id"]]];
    
    [placeLabel setText:[listing.attrs objectForKey:@"shortName"]];
    //[addressLabel setText:[listing getCompleteAddress]];
#warning TODO - remove this once we have address
    [costView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"listingPrice"]]];
    [costView alignRight];
    [levelView setText:[NSString stringWithFormat:@"%@",[listing.attrs objectForKey:@"skillLevel"]]];
    
    SportsAppApi *apiInstance = [[SportsAppApi alloc] init]; //multipl instances needed because singleton was leading to bugs with concurency
    [apiInstance getImageBySport:[listing.attrs objectForKey:@"sport"] Type:@1 Index:[listing.attrs objectForKey:@"graphicIndex"] WithCompletionBlock:^(NSError *err, id result) {
        [sportImage setImage:[UIImage imageWithData:result]];
    }];
    data = listing;
}
- (IBAction)pressedAction:(id)sender {
    [self.delegate listingWasTouched:data];
}
@end
