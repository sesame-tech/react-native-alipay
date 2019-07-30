#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>

@interface RNAlipay : NSObject <RCTBridgeModule>

+(void) handleCallback:(NSURL *)url;

@end
