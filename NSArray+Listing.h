//
//  NSArray+Listing.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 1/20/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Listing.h"
#import "SportsAppApi.h"
@interface NSArray (Listing)
-(NSArray*)getListingsByCatagory:(NSString *)catagoryy;
-(NSUInteger)getListingCountByCatagory:(NSString *)catagory;
-(NSDictionary *)getListingTypesByCatagory: (NSString *)catagory;
-(NSArray *)removeEmptyCategories;
-(NSDictionary *)sortListingsByDate;
@end
