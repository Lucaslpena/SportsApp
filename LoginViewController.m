//
//  LoginViewController.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/12/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () {
    
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
    IBOutlet UIButton *signInButton;
    IBOutlet UIButton *signUpButton;
    IBOutlet UIImageView *logo;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [backgroundImage setImage:[UIImage imageNamed:@"login_image.jpg"]];
    [backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    
    UIColor *textFieldColor = [[UIColor alloc] initWithWhite:1.0f alpha:.50f];
    [emailField setBackgroundColor:textFieldColor];
    [emailField setDelegate:self];
    [emailField setTag:1];
    
    [passwordField setBackgroundColor:textFieldColor];
    [passwordField setDelegate:self];
    [passwordField setTag:2];
    
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signUpButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
    signUpButton.layer.shadowOffset = CGSizeMake(1, 2);
    signUpButton.layer.shadowRadius = 2;
    signUpButton.layer.shadowOpacity = .3;
    
    [signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signInButton setBackgroundColor:[UIColor colorWithRed:0/255.0f green:53/255.0f blue:95/255.0f alpha:1.0f]];
    signInButton.layer.shadowOffset = CGSizeMake(1, 2);
    signInButton.layer.shadowRadius = 2;
    signInButton.layer.shadowOpacity = .3;

    [logo removeConstraints:logo.constraints];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Button Actions
- (IBAction)signInAction:(id)sender {
    if (![self fieldCheck]) {
        return;
    }
    [[SportsAppApi sharedInstance] loginUser:emailField.text Authentication:passwordField.text WithBlock:^(NSError *err, id result) {
        if ([result isEqualToString:@"Correct Login"])
            [self performSegueWithIdentifier:@"Login" sender:self];
        else
            [self triggerAlertFor:result];
    }];
}
- (IBAction)signUpAction:(id)sender {
    if (![self fieldCheck]) {
        return;
    }
    NSString *user = [[NSString alloc] initWithString:emailField.text];
    NSString *auth = [[NSString alloc] initWithString:passwordField.text];
    [[SportsAppApi sharedInstance] signupUser:user Authentication:auth WithBlock:^(NSError *err, id result) {
        if ([result isEqualToString:@"406"])
            [self triggerAlertFor:@"Improper Email or Password Entered"];
        else if ([result isEqualToString:@"email address already exists!"])
            [self triggerAlertFor:@"Email Already Signed Up"];
        else {
            [[SportsAppApi sharedInstance] loginUser:user Authentication:auth WithBlock:^(NSError *err, id result) {
                if ([result isEqualToString:@"Correct Login"])
                    [self performSegueWithIdentifier:@"Login" sender:self];
                else
                    [self triggerAlertFor:result];
            }];
        }
    }];
}
#pragma mark - Alert
-(void)triggerAlertFor:(NSString *)alertString {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:alertString delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
    [alert show];
}
-(BOOL)checkButton {
    if ([emailField.text isEqualToString:@""])
        return false;
    else if ([passwordField.text isEqualToString:@""])
        return false;
    else
        return true;
}
-(BOOL)fieldCheck {
    if ([self checkButton] == false) {
        [self triggerAlertFor:@"Missing Email or Password"];
        return false;
    }
    if ([self stringIsValidEmail:emailField.text] == false){
        [self triggerAlertFor:@"Invalid Email"];
        return false;
    }
    if (passwordField.text.length <= 5) {
        [self triggerAlertFor:@"Invalid Password - Must be atleast 5 Characters Long"];
        return false;
    }
    return true;
}
-(BOOL)stringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
#pragma mark - Text Field methods
//Keyboard Dismiss
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textfield
{
    [textfield resignFirstResponder];
    if (textfield.tag == 1)
    {
        [self resignFirstResponder];
        [passwordField becomeFirstResponder];
    }
    else if (textfield.tag == 2)
        [self signInAction:self];
    return YES;
}
//-(void)textFieldDidBeginEditing:(UITextField *)textField {
//    if (self.view.frame.size.height < 500) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.01];
//        self.view.frame = CGRectMake(0,-20,320,480);
//        [UIView commitAnimations];
//    }
//}
//-(void)textFieldDidEndEditing:(UITextField *)textField {
//    if (self.view.frame.size.height < 500) {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:0.01];
//        self.view.frame = CGRectMake(0,0,320,480);
//        [UIView commitAnimations];
//    }
//}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
@end
