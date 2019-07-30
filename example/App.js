/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, {Fragment} from 'react';
import {
    Alert,
  SafeAreaView,
  StyleSheet,
  ScrollView,
  View,
  Text,
  StatusBar,
    TouchableHighlight
} from 'react-native';
import alipay from '@sesame/react-native-alipay';

import {
    Colors
} from 'react-native/Libraries/NewAppScreen';

const onPressPayButton = () => {
    Alert.alert('alert');
    let order="";
    let shceme="";
    alipay.pay(order, scheme).then((resp)=>{
        console.log(`pay resp: ${JSON.stringify(resp)}`);
    }).catch(e=>{
        console.log(`pay error: ${e}`);
    });
};

const App = () => {
  return (
    <Fragment>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView>
        <View style={styles.payContainerView}>
            <TouchableHighlight onPress={onPressPayButton}>
                <Text>支付一分钱</Text>
            </TouchableHighlight>
        </View>
      </SafeAreaView>
    </Fragment>
  );
};

const styles = StyleSheet.create({
    payContainerView: {
        width: '100%',
        height: '100%',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center'
    }
});

export default App;
