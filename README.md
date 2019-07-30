# @sesame/react-native-wechat

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

to be done
           
    

## API Documentation

to be done

## Todo

- [ ] test each api
- [ ] add api usage in example project

## License

MIT
