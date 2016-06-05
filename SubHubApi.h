//
//  SportsAppApi.h
//  SportsApp
//
//  Created by Lucas L. Pena on 12/19/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+json.h"
#import "NSDictionary+json.h"
#import "Listing.h"
#import "User.h"

@interface SportsAppApi : NSObject
+(SportsAppApi *) sharedInstance;
@property (nonatomic, strong) User *mainUser;

//User
-(NSDictionary *)loadUser;
-(void)loginUser:(NSString *)user Authentication:(NSString *)authen WithBlock:(void (^)(NSError * err, id))block;
-(void)signupUser:(NSString *)user Authentication:(NSString *)authen WithBlock:(void (^)(NSError * err, id result))block;
-(void)whipeUser;

-(void)getUserAvatarById:(NSNumber *)userId WithCompletionBlock:(void (^)(NSError* err,id result))block;
-(void)updateUser:(User *)user WithCompletionBlock:(void (^)(NSError* err,id result))block;
-(void)updateAvatar:(NSData *)avatarData WithCompletionBlock:(void (^)(NSError* err,id result))block;

-(void)getFriendsById:(NSNumber *)userId WithCompletionBlock:(void (^)(NSError *, id))block;
-(void)getMessagesById:(NSNumber *)otherUserId WithCompletionBlock:(void (^)(NSError *, id))block;
-(void)addMessagesById:(NSNumber *)otherUserId withMessage:(NSString *)msg WithCompletionBlock:(void (^)(NSError *, id))block;

-(void)getSportsById:(NSNumber *)userId WithCompletionBlock:(void (^)(NSError *err, id result))block;
-(void)setSports:(NSArray *)sports ById:(NSNumber *)userId WithCompletionBlock:(void (^)(NSError *err, id result))block;



//Listings
-(void)getFeedListingsWithCompletionBlock:(void (^)(NSError* err,id result))block;
-(void)getListingsByCategory:(NSString *)category WithCompletionBlock:(void (^)(NSError* err,id result))block;
-(void)searchListingsByCategory:(NSString *)category WithFilter:(NSString *)filter WithCompletionBlock:(void (^)(NSError* err,id result))block;
-(void)getListingsById:(NSNumber *)listingId WithCompletionBlock:(void (^)(NSError* err,id result))block;
-(void)getListingsByCreatorId:(NSNumber *)rowId WithCompletionBlock:(void (^)(NSError *, id))block;
-(void)getListingsByBuyerId:(NSNumber *)rowId WithCompletionBlock:(void (^)(NSError *, id))block;
-(void)buyListingWithId:(NSNumber *)listingId WithCompletionBlock:(void (^)(NSError* err,id result))block;

//Sports
-(void)getImageBySport:(NSString *)sport Type:(NSNumber *)type Index:(NSNumber *)index WithCompletionBlock:(void (^)(NSError* err,id result))block;
-(void)createListing:(Listing *)listing withCompletionBlock:(void (^)(NSError* err,id result))block;
-(void)getSportsWithCompletionBlock:(void (^)(NSError* err,id result))block;
-(void)getSportsInBackground;

//Data Conversion Methods
-(NSString *)convertToDisplayNameWithCatagoryName:(NSString *)category;
-(NSString *)convertToCategoryNameWithDisplayName:(NSString *)category;
-(BOOL)checkIfValidDisplayName:(NSString *)category;

@end
