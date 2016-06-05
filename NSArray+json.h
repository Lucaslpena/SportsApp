
#import <Foundation/Foundation.h>

@interface NSArray (json)


- (NSString*)jsonString;
+ (NSArray*)arrayWithJSONString:(NSString*)str;

@end
