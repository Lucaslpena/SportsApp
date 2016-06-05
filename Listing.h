//
//  Listing.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/20/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Listing : NSObject
-(id)initWithDictionary:(NSDictionary *)dict;
-(NSString *)getCompleteAddress;
@property (nonatomic, strong) NSMutableDictionary *attrs;
-(NSDate *)getStartingDate;
-(NSString *)getStartingDateString;
@end
