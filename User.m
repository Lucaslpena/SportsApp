//
//  User.m
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/15/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import "User.h"

@implementation User
-(id)init {
    self = [super init];
    if (self) {
        _attrs = [[NSMutableDictionary alloc] init];
        _avatar = nil;
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        _attrs = [[NSMutableDictionary alloc] initWithDictionary:dict];
        _avatar = nil;
    }
    return self;
}
@end
