//
//  SportsAppApi.m
//  SportsApp
//
//  Created by Lucas L. Pena on 12/19/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "SportsAppApi.h"

@implementation SportsAppApi {
    NSString *xAuthToken;
        
    NSMutableArray *catagoryDict;
    NSMutableArray *sportArray;
    NSMutableArray *feedListings;
}

static const NSString* baseURL = @"http://SportsApp.net"; //fake

#pragma mark - Singleton
+(SportsAppApi *) sharedInstance
{
    static SportsAppApi *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Request Execution
- (void)invokeRequest:(NSString*)cmd method:(NSString*)method body:(NSString*)body withCompletionBlock:(void (^)(NSError* error,id result))block
{
    NSString* url = [NSString stringWithFormat:@"%@/%@",baseURL,[cmd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    url = [NSString stringWithFormat:@"%@%ccachebuster=%f",url,([url rangeOfString:@"?"].location == NSNotFound ? '?' : '&'),[[NSDate date] timeIntervalSince1970]];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    
    req.HTTPMethod = method;
    if (xAuthToken != nil)
        [req setValue:(NSString *)xAuthToken forHTTPHeaderField:@"X-Auth-Token"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    req.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* resp,NSData* data,NSError* err)
     {
         NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)resp;
         NSInteger code = [httpResponse statusCode];
         if ((code == 406) && ([str isEqualToString:@""]))
             str = [NSString stringWithFormat:@"406"];
         if (!str) {
             block(err,data);
         }
         else if ([NSArray arrayWithJSONString:str]) { //is JSON
             block(err,[NSArray arrayWithJSONString:str]);
         }
         else
             block(err,str);
     }];
}
- (void)invokeDataRequest:(NSString*)cmd method:(NSString*)method body:(NSData*)bodyData withCompletionBlock:(void (^)(NSError* error,id result))block
{
    NSString* url = [NSString stringWithFormat:@"%@/%@",baseURL,[cmd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //url = [NSString stringWithFormat:@"%@%ccachebuster=%f",url,([url rangeOfString:@"?"].location == NSNotFound ? '?' : '&'),[[NSDate date] timeIntervalSince1970]];
    
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
    
    
    req.HTTPMethod = method;
    if (xAuthToken != nil)
        [req setValue:(NSString *)xAuthToken forHTTPHeaderField:@"X-Auth-Token"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    req.HTTPBody = bodyData;
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* resp,NSData* data,NSError* err)
     {
         NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)resp;
         NSInteger code = [httpResponse statusCode];
         if ((code == 406) && ([str isEqualToString:@""]))
             str = [NSString stringWithFormat:@"406"];
         if (!str) {
             block(err,data);
         }
         else if ([NSArray arrayWithJSONString:str]) { //is JSON
             block(err,[NSArray arrayWithJSONString:str]);
         }
         else
             block(err,str);
     }];
}
#pragma mark - User Calls
-(void)loginUser:(NSString *)user Authentication:(NSString *)authen WithBlock:(void (^)(NSError * err, id result))block; {
    
    NSDictionary* body = @{@"password" : authen, @"username" : user};
    [self invokeRequest:@"api/authenticate/userpass" method:@"POST" body:[body jsonString] withCompletionBlock:^(NSError *error, NSDictionary *result) {
        
        NSString *res = [[NSString alloc] init];
        if ([result objectForKey:@"error"] != nil) {
            res = [result objectForKey:@"error"];
        }
        else {
            xAuthToken = [[NSString alloc] initWithString:[result objectForKey:@"token"]];
            res = @"Correct Login";
            [self getSportsInBackground];
            [self saveUser:user WithCredentials:authen];
            
            [self invokeRequest:@"api/account" method:@"GET" body:nil withCompletionBlock:^(NSError *error, NSDictionary *result2) {
                _mainUser = [[User alloc] initWithDictionary:result2];
                [[SportsAppApi sharedInstance] getUserAvatarById:[_mainUser.attrs objectForKey:@"rowId"] WithCompletionBlock:^(NSError *err, id result3) {
                    if (!err)
                        [_mainUser setAvatar:result3];
                }];
            }];
        }
        block(error, res);
    }];
}
-(void)signupUser:(NSString *)user Authentication:(NSString *)authen WithBlock:(void (^)(NSError * err, id result))block; {
    NSDictionary* body = @{@"password" : authen, @"email" : user};
    [self invokeRequest:@"api/users" method:@"POST" body:[body jsonString] withCompletionBlock:^(NSError *error, NSString *result) {
        block(error, result);
    }];
}
-(void)updateUser:(User *)user WithCompletionBlock:(void (^)(NSError* err,id result))block;
{
    [self invokeRequest:[NSString stringWithFormat:@"api/account/%@",[_mainUser.attrs objectForKey:@"rowId"]]method:@"PUT" body:[user.attrs jsonString] withCompletionBlock:^(NSError* error,NSString* results){
        if ((!error) && (![results isEqualToString:@"406"]) ){
            [self invokeRequest:@"api/account" method:@"GET" body:nil withCompletionBlock:^(NSError *error, NSDictionary *result) {
                _mainUser = [[User alloc] initWithDictionary:result];
            }];
        }
        block(error,results);
    }];
}

-(void)saveUser:(NSString *)user WithCredentials:(NSString *)credential {
    NSDictionary *userDict = [[NSDictionary alloc] initWithObjects:@[user,credential] forKeys:@[@"user",@"credential"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userDict forKey:@"user"];
    [defaults synchronize];
}
-(NSDictionary *)loadUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * user = [[NSDictionary alloc] initWithDictionary:[defaults objectForKey:@"user"]];
    return user;
}
-(void)whipeUser {
    NSDictionary *userDict = [[NSDictionary alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userDict forKey:@"user"];
    [defaults synchronize];
}

-(void)getFriendsById:(NSNumber *)userId WithCompletionBlock:(void (^)(NSError *, id))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/account/%@/friends", userId.stringValue];
    [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError *error, id result) {
        NSMutableArray *mutableResult = [[NSMutableArray alloc] initWithArray:[self convertToUsersFromArray:result]];
        block(error,mutableResult);
    }];
}
-(void)getMessagesById:(NSNumber *)otherUserId WithCompletionBlock:(void (^)(NSError *, id))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/account/%@/messages/%@", [_mainUser.attrs objectForKey:@"rowId" ], otherUserId.stringValue];
    [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError *error, id result) {
        block(error,result);
    }];
}
-(void)addMessagesById:(NSNumber *)otherUserId withMessage:(NSString *)msg WithCompletionBlock:(void (^)(NSError *, id))block; {
    NSDictionary *body = [[NSDictionary alloc] initWithObjects:@[msg] forKeys:@[@"message"]];
    NSString *endingURL = [NSString stringWithFormat:@"api/account/%@/messages/%@", [_mainUser.attrs objectForKey:@"rowId" ], otherUserId.stringValue];
    [self invokeRequest:endingURL method:@"POST" body:[body jsonString] withCompletionBlock:^(NSError *error, id result) {
        block(error,result);
    }];
}

-(void)getUserAvatarById:(NSNumber *)userId WithCompletionBlock:(void (^)(NSError *, id))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/account/%@/avatar", userId.stringValue];
    [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError *error, id result) {
        block(error,result);
    }];
}

-(void)updateAvatar:(NSData *)avatarData WithCompletionBlock:(void (^)(NSError* err,id result))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/account/%@/avatar", [_mainUser.attrs objectForKey:@"rowId"]];
    [self invokeDataRequest:endingURL method:@"PUT" body:avatarData withCompletionBlock:^(NSError *error, id result) {
        if (!error) {
            [[SportsAppApi sharedInstance] getUserAvatarById:[_mainUser.attrs objectForKey:@"rowId"] WithCompletionBlock:^(NSError *err, id result) {
                if (!err)
                    [_mainUser setAvatar:result];
            }];
        }
        block(error,result);
    }];
}
-(void)getSportsById:(NSNumber *)userId WithCompletionBlock:(void (^)(NSError *err, id result))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/account/%@/sports", userId.stringValue];
    [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError *error, id result) {
        block(error,result);
    }];
}
-(void)setSports:(NSArray *)sports ById:(NSNumber *)userId WithCompletionBlock:(void (^)(NSError *err, id result))block {
    NSMutableArray *body = [[NSMutableArray alloc] init];
    for (NSString* spt in sports) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjects:@[spt] forKeys:@[@"sportId"]];
        [body addObject:dict];
    }
    
    NSString *endingURL = [NSString stringWithFormat:@"api/account/%@/sports", userId.stringValue];
    [self invokeRequest:endingURL method:@"PUT" body:[body jsonString] withCompletionBlock:^(NSError *error, id result) {
        block(error,result);
    }];
}
#pragma mark - Listing Calls
-(void)getFeedListingsWithCompletionBlock:(void (^)(NSError* err,id result))block; {
    [self invokeRequest:@"api/listings/feed" method:@"GET" body:nil withCompletionBlock:^(NSError *error, id result) {
        NSMutableArray *mutableResult = [[NSMutableArray alloc] init];
        for (NSMutableDictionary* dict in result) {
            [mutableResult addObject:[self convertToListingsFromDictionary:dict]];
        }
        block(error,mutableResult);
    }];
}
-(void)getListingsById:(NSNumber *)listingId WithCompletionBlock:(void (^)(NSError *, id))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/listings/%@", listingId.stringValue];
    [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError *error, id result) {
        Listing *temp = [[Listing alloc] initWithDictionary:result];
        block(error,temp);
    }];
}
-(void)getListingsByCategory:(NSString *)category WithCompletionBlock:(void (^)(NSError* err,id result))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/listings/category/%@", category];
    [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError *error, id result) {
        NSDictionary *mutableResult = [[NSDictionary alloc] initWithDictionary:[self convertToListingsFromDictionary:result]];
        block(error,mutableResult);
    }];
}
-(void)searchListingsByCategory:(NSString *)category WithFilter:(NSString *)filter WithCompletionBlock:(void (^)(NSError* err,id result))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/listings/category/%@?filter=%@", category,filter];
    [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError *error, id result) {
        NSDictionary *mutableResult = [[NSDictionary alloc] initWithDictionary:[self convertToListingsFromDictionary:result]];
        block(error,mutableResult);
    }];
}
-(void)createListing:(Listing *)listing withCompletionBlock:(void (^)(NSError* err,id result))block;
{
    [self invokeRequest:@"api/listings" method:@"POST" body:[listing.attrs jsonString] withCompletionBlock:^(NSError* error,NSString* results){
        block(error, results);
    }];
}
-(void)getListingsByCreatorId:(NSNumber *)rowId WithCompletionBlock:(void (^)(NSError *, id))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/account/%@/sold", rowId.stringValue];
    [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError *error, NSArray* result) {
        NSArray *returnAble = [self convertToListingsFromArray:result];
        block(error,returnAble);
    }];
}
-(void)getListingsByBuyerId:(NSNumber *)rowId WithCompletionBlock:(void (^)(NSError *, id))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/account/%@/purchased", rowId.stringValue];
    [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError *error, NSArray* result) {
        NSArray *returnAble = [self convertToListingsFromArray:result];
        block(error,returnAble);
    }];
}
-(void)buyListingWithId:(NSNumber *)listingId WithCompletionBlock:(void (^)(NSError* err,id result))block; {
    NSString *endingURL = [NSString stringWithFormat:@"api/listings/%@/buy", listingId.stringValue];
    [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError *error, NSArray* result) {
        
        block(error,result);
    }];
}
#pragma mark - Data Request Calls
-(void)getImageBySport:(NSString *)sport Type:(NSNumber *)type Index:(NSNumber *)index WithCompletionBlock:(void (^)(NSError *, id))block {
    NSData *imageData = [self loadDataForSport:sport Type:type Index:index];
    if (imageData) {
        block(nil, imageData);
    }
    else {
        NSString *endingURL = [NSString stringWithFormat:@"api/sports/imageurl/%@?imgType=%@&index=%@", sport,type.stringValue,index.stringValue];
        [self invokeRequest:endingURL method:@"GET" body:nil withCompletionBlock:^(NSError* error,NSString* results){
            NSString *assetUrl = [results substringFromIndex:1];
            [self invokeRequest:assetUrl method:@"GET" body:nil withCompletionBlock:^(NSError* error2,NSData* results2){
                [self saveData:results2 forSport:sport Type:type Index:index];
                block(error, results2);
            }];
        }];
    }
}
-(void)getSportsInBackground {
    dispatch_queue_t myQueue = dispatch_queue_create("fetchSports",NULL);
    dispatch_async(myQueue, ^{
        [[SportsAppApi sharedInstance] getSportsWithCompletionBlock:^(NSError *err, id result) {
            }];
    });
}
-(void)getSportsWithCompletionBlock:(void (^)(NSError* err,id result))block;
{
    if (!sportArray) {
        sportArray = [[NSMutableArray alloc] init];
        [self invokeRequest:@"api/sports" method:@"GET" body:nil withCompletionBlock:^(NSError* error,NSArray* results){
            for (NSDictionary *object in results) {
                [sportArray addObject:object];
            }
            block(error,sportArray);
        }];
    }
    else
        block(nil,sportArray);
}

#pragma mark - Data Conversion Calls
-(NSDictionary *)convertToListingsFromDictionary:(NSMutableDictionary *)dict {
    NSArray *listingList = [dict objectForKey:@"listings"];
    listingList = [self convertToListingsFromArray:listingList];
    [dict setObject:listingList forKey:@"listings"];
    return dict;
}
-(NSMutableArray *)convertToListingsFromArray:(NSArray *)listingList {
    NSMutableArray *listingArray = [[NSMutableArray alloc] init];
    for (NSDictionary* obj in listingList) {
        Listing *listing = [[Listing alloc] initWithDictionary:obj];
        [listingArray addObject:listing];
    }
    return listingArray;
}
-(NSMutableArray *)convertToUsersFromArray:(NSArray *)returnList {
    NSMutableArray *userArray = [[NSMutableArray alloc] init];
    for (NSDictionary* obj in returnList) {
        User *user = [[User alloc] initWithDictionary:obj];
        [userArray addObject:user];
    }
    return userArray;
}
-(NSString *)convertToDisplayNameWithCatagoryName:(NSString *)category
{
    NSString *temp = [[NSString alloc] init];
    for (NSDictionary *obj in sportArray) {
        NSString *compare = [obj objectForKey:@"rowId"]; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< json structure inconsistency
        if ([category isEqualToString:compare]) {
            temp = [obj objectForKey:@"displayName"];
            break;
        }
        temp = category;
    }
    return temp;
}
-(NSString *)convertToCategoryNameWithDisplayName:(NSString *)category {
    NSString *temp = [[NSString alloc] init];
    for (NSDictionary *obj in sportArray) {
        NSString *compare = [obj objectForKey:@"displayName"]; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< json structure inconsistency
        if ([category isEqualToString:compare]) {
            temp = [obj objectForKey:@"rowId"];
            break;
        }
        temp = category;
    }
    return temp;
}
-(BOOL)checkIfValidDisplayName:(NSString *)category {
    bool returnBool = false;
    for (NSDictionary *obj in sportArray) {
        NSString *compare = [obj objectForKey:@"displayName"]; //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< json structure inconsistency
        if ([category isEqualToString:compare]) {
            returnBool = true;
            break;
        }
    }
    return returnBool;
}
#pragma mark - Document Setting and Getting
-(void)saveData:(NSData*)data forSport:(NSString *)sport Type:(NSNumber *)type Index:(NSNumber *)index
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"sport-%@type-%@index-%@",sport,type.stringValue,index.stringValue]];
    [data writeToFile:path atomically:YES];
}
-(NSData *)loadDataForSport:(NSString *)sport Type:(NSNumber *)type Index:(NSNumber *)index {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"sport-%@type-%@index-%@",sport,type.stringValue,index.stringValue]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}
@end
