#import "NSArray+json.h"

@implementation NSArray (json)

- (NSString*)jsonString
    {
    NSError* err;
    NSString* ret = @"";
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&err];
 
    if(jsonData)
        ret = [[NSString alloc] initWithBytes:[jsonData bytes] length:[jsonData length] encoding:NSUTF8StringEncoding];

    return ret;
    }
+ (NSArray*)arrayWithJSONString:(NSString*)str
    {
    NSError* err;
    NSData* jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    }

@end
