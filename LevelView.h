//
//  LevelView.h
//  SportsApp
//
//  Created by Lucas L. Pena on 12/10/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UILabel *label;

-(void)setText:(NSString *)text;
-(void)enableHighlight:(BOOL)toggle;
-(void)enablePending;
@end
