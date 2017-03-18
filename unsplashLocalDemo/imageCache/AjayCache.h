

#import <Foundation/Foundation.h>

@interface AjayCache : NSObject

+ (void) resetCache;

+ (void) setObject:(NSData*)data forKey:(NSString*)key;
+ (id) objectForKey:(NSString*)key;

@end
