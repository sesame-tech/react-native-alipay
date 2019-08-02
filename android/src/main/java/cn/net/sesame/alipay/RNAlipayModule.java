package cn.net.sesame.alipay;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;

import java.util.Map;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.content.Context;
import android.view.View;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.widget.Toast;

import com.alipay.sdk.app.PayTask;

public class RNAlipayModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private static final int SDK_PAY_FLAG = 1;

    public RNAlipayModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNAlipay";
    }

    @SuppressLint("HandlerLeak")
  	private Handler mHandler = new Handler(getReactApplicationContext().getMainLooper()) {
  		@SuppressWarnings("unused")
  		public void handleMessage(Message msg) {
  			switch (msg.what) {
  			case SDK_PAY_FLAG: {
  				@SuppressWarnings("unchecked")
  				PayResult payResult = new PayResult((Map<String, String>) msg.obj);
  				/**
  				 * 对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
  				 */
  				String resultInfo = payResult.getResult();// 同步返回需要验证的信息
  				String resultStatus = payResult.getResultStatus();

				if (TextUtils.equals(resultStatus, "9000")) {
					Toast.makeText(getCurrentActivity(), "支付成功", Toast.LENGTH_SHORT).show();
				} else {
					// 判断resultStatus 为非"9000"则代表可能支付失败
					// "8000"代表支付结果因为支付渠道原因或者系统原因还在等待支付结果确认，最终交易是否成功以服务端异步通知为准（小概率状态）
					if (TextUtils.equals(resultStatus, "8000")) {
						Toast.makeText(getCurrentActivity(), "支付结果确认中", Toast.LENGTH_SHORT).show();

					} else {
						// 其他值就可以判断为支付失败，包括用户主动取消支付，或者系统返回的错误
						Toast.makeText(getCurrentActivity(), "支付失败", Toast.LENGTH_SHORT).show();
					}
				}
  				break;
  			}
  			default:
  				break;
  			}
  		};
  	};

	@ReactMethod
	public void pay(final String orderInfo,
					final Promise promise) {

		Runnable payRunnable = new Runnable() {
			@Override
			public void run() {
				try {
					PayTask alipay = new PayTask(getCurrentActivity());
					Map<String, String> result = alipay.payV2(orderInfo, true);

					Message msg = new Message();
					msg.what = SDK_PAY_FLAG;
					msg.obj = result;
					mHandler.sendMessage(msg);

					String resultStatus = result.get("resultStatus");
					if(Integer.valueOf(resultStatus) >= 8000){
						promise.resolve(result);
					}else{
						promise.reject(new RuntimeException(resultStatus));
					}
				} catch (Exception e) {
					promise.reject(e.getLocalizedMessage(), e);
				}
			}
		};

		Thread payThread = new Thread(payRunnable);
		payThread.start();
	}
}
