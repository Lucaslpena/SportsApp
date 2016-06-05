//
//  ProfileFrameViewController.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/17/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "ProfileFrameViewController.h"

@interface ProfileFrameViewController ()

@end

@implementation ProfileFrameViewController {
    UserProfileView *uPV;
    UIImagePickerController *imagePicker;
    UIImage *avatarImage;
    bool pickerActive;
    bool keyboardActive;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    pickerActive = false;
    keyboardActive = false;
    [self setContents];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated {
    if (!pickerActive) {
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController.navigationBar setHidden:YES];
    }
}
-(void)setContents {
    uPV = [[UserProfileView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width * .8, self.view.frame.size.height-60)];
    [uPV setDelegate:self];
    [self.view addSubview:uPV];
}
-(void)removeContents {
    [uPV removeFromSuperview];
    uPV = nil;
}
#pragma mark - Profile View Delegate Methods
-(void)triggerImagePicker {
    pickerActive = true;
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    [self presentViewController:imagePicker animated:YES completion:nil];
}
-(void)triggerKeyboardAnimate:(BOOL)toggle ToHeight:(CGFloat)height {
    if (toggle){
        keyboardActive = true;
        CGFloat newHeight=65;
        if  (self.view.frame.size.height == 480)
            newHeight = (height * -1)+88;
        else if  (self.view.frame.size.height == 504)
            newHeight = 15;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.35];
        self.view.frame = CGRectMake(0,newHeight,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
    } else if (keyboardActive) {
        keyboardActive = true;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.15];
        self.view.frame = CGRectMake(0,65,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
    }
}
-(void)triggerLogout {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"You Have ben logged out" message:@"Pleas restart the application (segues have not been built yet)" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        avatarImage = [[UIImage alloc] init];
        avatarImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [[SportsAppApi sharedInstance]updateAvatar:UIImagePNGRepresentation(avatarImage) WithCompletionBlock:^(NSError *err, id result) {
            if  (err) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error Changing Avatar" message:@"Please check your connection and try again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Avatar was successfully changed!" message:nil delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        pickerActive = false;
    }];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
@end
