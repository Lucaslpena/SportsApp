//
//  Listing.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 12/20/14.
//  Copyright (c) 2014 SportsApp. All rights reserved.
//

#import "Listing.h"

@implementation Listing 

-(id)init {
    self = [super init];
    if (self) {
        _attrs = [[NSMutableDictionary alloc] init];
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _attrs = [[NSMutableDictionary alloc] initWithDictionary:dict];
    }
    return self;
}
-(NSString *)getCompleteAddress {
    return [NSString stringWithFormat:@"%@\n%@, %@ %@",
            [self.attrs objectForKey:@"location_address1"],
            [self.attrs objectForKey:@"location_city"],
            [self.attrs objectForKey:@"location_state"],
            [self.attrs objectForKey:@"location_zip"]];
}
-(NSDate *)getStartingDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
    NSDate *startingDate = [[NSDate alloc] init];
    startingDate = [dateFormatter dateFromString:[self.attrs objectForKey:@"gameTime"]];
    return startingDate;
}
-(NSString *)getStartingDateString {
    NSDate *startingDate = self.getStartingDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd 'at' h:mm a"];
    return [dateFormatter stringFromDate:startingDate];
}

@end
