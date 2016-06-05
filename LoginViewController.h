//
//  LoginViewController.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/12/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportsAppApi.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>
- (IBAction)signInAction:(id)sender;
- (IBAction)signUpAction:(id)sender;
@end
