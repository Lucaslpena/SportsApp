//
//  JSChatViewController.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/18/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "JSChatViewController.h"

@interface JSChatViewController ()

@end

@implementation JSChatViewController {
    NSMutableArray *messageArray;
    UIActivityIndicatorView *spinner;
    NSNumber *otherUserId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height/2-60)];
    [self.view addSubview:spinner];
    [spinner startAnimating];

    self.title = @"Chat Message";
    messageArray = [NSMutableArray array];
    self.delegate = self;
    self.dataSource = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setOtherId:(NSNumber *)userId {
    [[SportsAppApi sharedInstance]getMessagesById:userId WithCompletionBlock:^(NSError *err, id result) {
        if (err)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Fetching Messages" message:@"Check connection and try again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
            [alert show];
        }
        messageArray = [NSMutableArray arrayWithArray:result];
        [spinner stopAnimating];
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
    }];
    otherUserId = userId;
}

//- (void)testData{
//    MessageData *message1 = [[MessageData alloc] initWithMsgId:@"0001" text:@"This is a Chat Demo like iMessage.app" date:[NSDate date] msgType:JSBubbleMessageTypeIncoming mediaType:JSBubbleMediaTypeText img:nil];
//    
//    [messageArray addObject:message1];
//    
//    MessageData *message2 = [[MessageData alloc] initWithMsgId:@"0002" text:nil date:[NSDate date] msgType:JSBubbleMessageTypeOutgoing mediaType:JSBubbleMediaTypeImage img:@"demo1.jpg"];
//    
//    [messageArray addObject:message2];
//    
//    MessageData *message3 = [[MessageData alloc] initWithMsgId:@"0003" text:@"Up-to-date for iOS 6.0 and ARC (iOS 5.0+ required) Universal for iPhone Allows arbitrary message (and bubble) sizes Copy & paste text message && Save image message " date:[NSDate date] msgType:JSBubbleMessageTypeOutgoing mediaType:JSBubbleMediaTypeText img:nil];
//    
//    [messageArray addObject:message3];
//}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageArray.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    NSDate *timeStamp = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];

    NSDictionary *message = [[NSDictionary alloc] initWithObjects:@[[[SportsAppApi sharedInstance].mainUser.attrs objectForKey:@"rowId"],otherUserId,text,[dateFormatter stringFromDate:timeStamp]] forKeys:@[@"senderAccountId", @"recipientAccountId",@"message",@"timeStamp"]];
    [messageArray addObject:message];
    [self.tableView reloadData];
    [self finishSend:NO];
    [[SportsAppApi sharedInstance] addMessagesById:otherUserId withMessage:text WithCompletionBlock:^(NSError *err, id result) {
        if (err) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem Fetching Messages" message:@"Check connection and try again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (void)cameraPressed:(id)sender{
    
    [self.inputToolBarView.textView resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Albums", nil];
    [actionSheet showInView:self.view];
}
- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[messageArray[indexPath.row] objectForKey:@"senderAccountId"] isEqualToNumber:[[SportsAppApi sharedInstance].mainUser.attrs objectForKey:@"rowId"]]) {
        return JSBubbleMessageTypeOutgoing;
    }
    else
        return JSBubbleMessageTypeIncoming;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return JSBubbleMediaTypeText;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    /*
     JSMessagesViewTimestampPolicyAll = 0,
     JSMessagesViewTimestampPolicyAlternating,
     JSMessagesViewTimestampPolicyEveryThree,
     JSMessagesViewTimestampPolicyEveryFive,
     JSMessagesViewTimestampPolicyCustom
     */
    return JSMessagesViewTimestampPolicyAlternating;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
    return JSMessagesViewAvatarPolicyNone;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
    return JSAvatarStyleSquare;
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
    return JSInputBarStyleFlat;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [messageArray[indexPath.row] objectForKey:@"message"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    NSDate *startingDate = [[NSDate alloc] init];
    startingDate = [dateFormatter dateFromString:[[messageArray objectAtIndex:indexPath.row] objectForKey:@"timeStamp"]];
    return startingDate;
}
- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}

- (SEL)avatarImageForIncomingMessageAction
{
    return @selector(onInComingAvatarImageClick);
}

- (void)onInComingAvatarImageClick
{
    NSLog(@"__%s__",__func__);
}

- (SEL)avatarImageForOutgoingMessageAction
{
    return @selector(onOutgoingAvatarImageClick);
}

- (void)onOutgoingAvatarImageClick
{
    NSLog(@"__%s__",__func__);
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"demo-avatar-woz"];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
@end
