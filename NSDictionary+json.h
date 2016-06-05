#import <Foundation/Foundation.h>

@interface NSDictionary (json)


- (NSString*)jsonString;
+ (NSDictionary*)dictionaryWithJSONString:(NSString*)str;

@end
