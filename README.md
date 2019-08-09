# @sesame/react-native-alipay

Alipay SDK wrapper for react native 0.60+, support iOS and android


## Table of Contents

- [Installation](#installation)
- [API Documentation](#api-documentation)
- [TODO](#todo)
- [License](#license)


## Installation

#### install package 
```sh
$ yarn add @sesame/react-native-alipay --save
$ cd ios && pod install && cd ..
```

#### configure iOS project
    
reference: [alipay sdk ios integrate guide](https://docs.open.alipay.com/204/105295/)

- ios/YOUR-APP-NAME/AppDelegate.m

  add following code(to be verified):
    ```
    #import <React/RCTLinkingManager.h>
    
    @implementation AppDelegate
    
    // ...
    
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
      sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    {
      return [RCTLinkingManager application:application openURL:url
                          sourceApplication:sourceApplication annotation:annotation];
    }
    
    // NOTE: 9.0以后使用新API接口
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
                options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
    {
      return [RCTLinkingManager application:application openURL:url options:options];
    }
    
    @end

    ```
- TARGETS->Info->URL Types

  1. create URL Type By Click '+'
  
  2. **Identifier**, input "alipay"
  
  3. **URL Schemes**, input any string can distinguish your app from other app,
    for example, use your app's bundle id
        

#### configure android project

reference: [alipay sdk android integrate guide](https://docs.open.alipay.com/204/105296/)

- copy alipaySdk.aar file

  from: node_modules/@sesame/react-native-alipay/android/lib/alipaySdk-15.6.5-20190718211148.aar
  
  to: YOUR-PROJECT/android/app/lib/alipaySdk-15.6.5-20190718211148.aar
  
- YOUR-PROJECT/android/build.gradle
  
  add flatDir
  
  ```
    allprojects {
        repositories {
            // ...
            
            flatDir {
                dirs "lib"
            }
        }
    }
  ```
  
           
    

## API Documentation

### Alipay.pay(orderStr)

- `orderStr` {String} Order info in query string format. Must be signed before use. See [App payment request params description](https://docs.open.alipay.com/204/105465/).

Returns object with following fields:

|field|type|description|
|:----|:---|:----------|
|`resultStatus`|String|See [Response code description](#response-code-description)|
|`result`|String|Result data in json string format|
|`memo`|String|Reserved field, nothing|

The `result` data has following fields:

|field|type|description|
|:----|:---|:----------|
|`code`|String|结果码，具体见[公共错误码](https://docs.open.alipay.com/common/105806)|
|`msg`|String|处理结果的描述，信息来自于code返回结果的描述|
|`app_id`|String|支付宝分配给开发者的应用Id|
|`out_trade_no`|String|商户网站唯一订单号|
|`trade_no`|String|该交易在支付宝系统中的交易流水号|
|`total_amount`|String|该笔订单的资金总额，单位为RMB-Yuan|
|`seller_id`|String|收款支付宝账号对应的支付宝唯一用户号|
|`charset`|String|编码格式|
|`timestamp`|String|时间|

Example code:

```javascript
import Alipay from '@sesame/react-native-alipay';

// APP支付
try {
  // get from server, signed
  let orderStr = 'app_id=xxxx&method=alipay.trade.app.pay&charset=utf-8&timestamp=2014-07-24 03:07:50&version=1.0&notify_url=https%3A%2F%2Fapi.xxx.com%2Fnotify&biz_content=%7B%22subject%22%3A%22%E5%A4%A7%E4%B9%90%E9%80%8F%22%2C%22out_trade_no%22%3A%22xxxx%22%2C%22total_amount%22%3A%229.00%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&sign_type=RSA2&sign=xxxx';
  let resultStatus = await Alipay.pay(orderStr);
  console.info(resultStatus);

} catch (error) {
  console.error(error);
}
```

### Response code description

|code|description|
|:-----------|:----------|
|9000|操作成功|
|8000|正在处理中|
|4000|操作失败|
|5000|重复请求|
|6001|用户中途取消|
|6002|网络连接出错|


## Todo

- [ ] test each api
- [ ] add api usage in example project

## License

MIT
