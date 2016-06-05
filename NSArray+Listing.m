//
//  NSArray+Listing.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 1/20/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "NSArray+Listing.h"

@implementation NSArray (Listing)

-(NSArray*)getListingsByCatagory:(NSString *)catagory {
    NSArray *list = [[self getListingTypesByCatagory:catagory] objectForKey:@"listings"];
    if (!list)
        return nil;
    return list;
}

-(NSUInteger)getListingCountByCatagory:(NSString *)catagory {
    NSNumber *count = [[self getListingTypesByCatagory:catagory] objectForKey:@"totalListings"];
    if (!count)
        return 0;
    return count.integerValue;
}

-(NSDictionary *)getListingTypesByCatagory: (NSString *)catagory {
    for (NSDictionary *listings in self) {
        NSString *otherCatagory = [listings objectForKey:@"categoryName"];
        if ([otherCatagory isEqualToString:catagory]) {
            return listings;
        }
    }
    return nil;
}
-(NSArray *)removeEmptyCategories {
    NSMutableArray *mutableSelf = [[NSMutableArray alloc] initWithArray:self];
    for (int i = 0; i < mutableSelf.count; ++i) {
        NSArray *listings = [[mutableSelf objectAtIndex:i] objectForKey:@"listings"];
        if (listings.count == 0) {
            [mutableSelf removeObjectAtIndex:i];
            --i;
        }
    }
    return mutableSelf;
}

//This function assumes that all data given from the server is sorted by ending date...
//This function assumes that all listings that are given are FUTURE listings and not expired...
-(NSDictionary *)sortListingsByDate {
    NSMutableArray *listingsSortedByDate = [[NSMutableArray alloc] initWithCapacity:self.count];
    NSMutableArray *daysSortedByListings = [[NSMutableArray alloc] initWithCapacity:self.count];
    
    NSMutableArray *dayArray = [[NSMutableArray alloc] init];
    NSDate *comparedDate = [NSDate date];
    int dayIndex = 0;
    bool sameDay = false;
    for (Listing *listing in self)
    {
        bool dayFound = false;
        while (!dayFound)
        {
            if ([[NSCalendar currentCalendar] isDate:listing.getStartingDate inSameDayAsDate:comparedDate]) {
                [dayArray addObject:listing];
                dayFound = true;
                sameDay = true;
                if ([[NSCalendar currentCalendar] isDateInToday:comparedDate]) {
                    [daysSortedByListings insertObject:@"Today" atIndex:dayIndex];
                }
                else if ([[NSCalendar currentCalendar] isDateInTomorrow:comparedDate])
                    [daysSortedByListings insertObject:@"Tomorrow" atIndex:dayIndex];
                else {
                    [daysSortedByListings insertObject:listing.getStartingDateString atIndex:dayIndex];
                }
            }
            else {
                comparedDate =[comparedDate dateByAddingTimeInterval:60*60*24];
                sameDay = false;
                if (dayArray.count >= 1) {
                    [listingsSortedByDate insertObject:dayArray atIndex:dayIndex];
                    dayArray = [[NSMutableArray alloc] init];
                    dayIndex++;
                }
            }
        }
    }
    if (dayArray.count >= 1) {
        [listingsSortedByDate insertObject:dayArray atIndex:dayIndex];
        dayArray = nil;
    }
    while (daysSortedByListings.count > dayIndex+1) {
        [daysSortedByListings removeLastObject];
    }
    NSMutableArray *finalDaysByListings = [[NSMutableArray alloc] initWithCapacity:daysSortedByListings.count];
    for (NSString *str in daysSortedByListings) {
        NSRange range = [str rangeOfString:@"at"];
        NSString *key = [[NSString alloc] init];
        if  (range.location != NSNotFound) {
            key = [str substringToIndex:range.location];
        }
        else
            key = str;
        [finalDaysByListings addObject:key];
    }
    NSDictionary *returnDictionay = [[NSDictionary alloc] initWithObjects:@[finalDaysByListings,listingsSortedByDate] forKeys:@[@"dayArray",@"listingArrayPerDay"]];
    return returnDictionay;
}
@end
