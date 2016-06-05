//
//  User.h
//  SportsApp
//
//  Created by Lucas Lorenzo Pena on 2/15/15.
//  Copyright (c) 2015 Lucas Lorenzo Pena All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
-(id)initWithDictionary:(NSDictionary *)dict;
@property (nonatomic, strong) NSMutableDictionary *attrs;
@property (nonatomic, strong) NSData *avatar;

@end
