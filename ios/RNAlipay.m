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

RCT_REMAP_METHOD(pay,
    order:(NSString *)orderStr
    scheme:(NSString *)schemeStr
    resolver:(RCTPromiseResolveBlock)resolve
    rejecter:(RCTPromiseRejectBlock)reject)
{
    if ([schemeStr isEqualToString:@""]) {
        NSString *error = @"scheme cannot be empty";
        reject(@"10000", error, [NSError errorWithDomain:error code:10000 userInfo:NULL]);
        return;
    }

    _resolve = resolve;
    _reject = reject;

    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:schemeStr callback:^(NSDictionary *resultDic) {
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

+(void) handleCallback:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            [self handleResult:resultDic];
        }];
    }
}

@end
