#import "RNAlipay.h"

#import <AlipaySDK/AlipaySDK.h>

static RCTPromiseResolveBlock _resolve;
static RCTPromiseRejectBlock _reject;

@implementation RNAlipay

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE()


- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleOpenURL:) name:@"RCTOpenURLNotification" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


RCT_REMAP_METHOD(pay,
    order:(NSString *)orderStr
    resolver:(RCTPromiseResolveBlock)resolve
    rejecter:(RCTPromiseRejectBlock)reject)
{
    _resolve = resolve;
    _reject = reject;

    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:self.appScheme callback:^(NSDictionary *resultDic) {
        [RNAlipay handleResult:resultDic];
    }];
}

+(void) handleResult:(NSDictionary *)resultDic
{
    NSString *status = resultDic[@"resultStatus"];
    if ([status integerValue] >= 8000) {
        _resolve(@[resultDic]);
    } else {
        _reject(status, resultDic[@"memo"], [NSError errorWithDomain:resultDic[@"memo"] code:[status integerValue] userInfo:NULL]);
    }
}

- (BOOL)handleOpenURL:(NSNotification *)aNotification
{
    NSString * aURLString =  [aNotification userInfo][@"url"];
    NSURL * aURL = [NSURL URLWithString:aURLString];
    if ([aURL.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:aURL standbyCallback:^(NSDictionary *resultDic) {
            [RNAlipay handleResult:resultDic];
        }];
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)appScheme {
    NSArray *urlTypes = NSBundle.mainBundle.infoDictionary[@"CFBundleURLTypes"];
    for (NSDictionary *urlType in urlTypes) {
        NSString *urlName = urlType[@"CFBundleURLName"];
        if ([urlName hasPrefix:@"alipay"]) {
            NSArray *schemes = urlType[@"CFBundleURLSchemes"];
            return schemes.firstObject;
        }
    }
    return nil;
}


@end
