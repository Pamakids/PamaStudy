package com.iflytek.voicedemo;

import java.util.ArrayList;
import java.util.List;

import com.iflytek.speech.ErrorCode;
import com.iflytek.speech.ISpeechModule;
import com.iflytek.speech.InitListener;
import com.iflytek.speech.RecognizerListener;
import com.iflytek.speech.RecognizerResult;
import com.iflytek.speech.SpeechConstant;
import com.iflytek.speech.SpeechRecognizer;
import com.iflytek.speech.util.JsonParser;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.os.RemoteException;
import android.speech.RecognizerIntent;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.EditText;
import android.widget.Toast;

public class IatDemo extends Activity implements OnClickListener{
	private static String TAG = "IatDemo";
	// 语音识别对象。
	private SpeechRecognizer mIat;
	private Toast mToast;
	private static final String ACTION_INPUT = "com.iflytek.speech.action.voiceinput";
	
	/**外部设置的弹出框完成按钮文字*/
	public static final String TITLE_DONE = "title_done";
	/**外部设置的弹出框取消按钮文字*/
	public static final String TITLE_CANCEL = "title_cancel";
	private static final int REQUEST_CODE_SEARCH = 1099;
	
	@SuppressLint("ShowToast")
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.iatdemo);
		initLayout();
		
		// 初始化识别对象
		mIat = new SpeechRecognizer(this, mInitListener);
		mToast = Toast.makeText(this, "", Toast.LENGTH_LONG);			
	}
	
	/**
	 * 初期化。
	 */
	private void initLayout(){
		findViewById(R.id.iat_recognize_bind).setOnClickListener(this);
		findViewById(R.id.iat_recognize_bind).setEnabled(false);
		findViewById(R.id.iat_recognize_intent).setOnClickListener(this);
		findViewById(R.id.iat_recognize_intent).setEnabled(false);
		
		findViewById(R.id.iat_stop).setOnClickListener(this);
		findViewById(R.id.iat_cancel).setOnClickListener(this);	
	}
	
	@Override
	public void onClick(View view) {				
		switch (view.getId()) {
		case R.id.iat_recognize_intent:
			((EditText)findViewById(R.id.iat_text)).setText("");
			if(isActionSupport(this)){
				Intent intent = new Intent();
				// 指定action名字
				intent.setAction(ACTION_INPUT);
				intent.putExtra(SpeechConstant.PARAMS, "asr_ptt=1");
				intent.putExtra(SpeechConstant.VAD_EOS, "1000");
				// 设置弹出框的两个按钮名称
				intent.putExtra(TITLE_DONE, "确定");
				intent.putExtra(TITLE_CANCEL, "取消");
				startActivityForResult(intent, REQUEST_CODE_SEARCH);
			} else {
				showTip("请先安装讯飞语音+(1.0.1011以上版本)");
			}			
			break;
		case R.id.iat_recognize_bind:
			// 转写会话
			((EditText)findViewById(R.id.iat_text)).setText("");
			mIat.setParameter(SpeechConstant.PARAMS, "asr_ptt=0");
			mIat.startListening(mRecognizerListener);
			break;
		case R.id.iat_stop:
			mIat.stopListening(mRecognizerListener);
			break;
		case R.id.iat_cancel:
			mIat.cancel(mRecognizerListener);
			break;
		default:
			break;
		}
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if(requestCode == REQUEST_CODE_SEARCH && resultCode == RESULT_OK)
		{
			// 取得识别的字符串
			ArrayList<String> results = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
			String res = results.get(0);
			EditText editor = ((EditText)findViewById(R.id.iat_text));
			String text = editor.getText().toString()+res;
			editor.setText(text);			
		}
		super.onActivityResult(requestCode, resultCode, data);
	}
	
    /**
     * 初期化监听器。
     */
    private InitListener mInitListener = new InitListener() {

		@Override
		public void onInit(ISpeechModule module, int code) {
			Log.d(TAG, "SpeechRecognizer init() code = " + code);
        	if (code == ErrorCode.SUCCESS) {
        		findViewById(R.id.iat_recognize_bind).setEnabled(true);
        		findViewById(R.id.iat_recognize_intent).setEnabled(true);
        	}
		}
    };
	
    /**
     * 识别回调。
     */
    private RecognizerListener mRecognizerListener = new RecognizerListener.Stub() {
        
        @Override
        public void onVolumeChanged(int v) throws RemoteException {
            showTip("onVolumeChanged："	+ v);
        }
        
        @Override
        public void onResult(final RecognizerResult result, boolean isLast)
                throws RemoteException {
        	runOnUiThread(new Runnable() {
				@Override
				public void run() {
					if (null != result) {
		            	// 显示
						Log.d(TAG, "recognizer result：" + result.getResultString());
						String iattext = JsonParser.parseIatResult(result.getResultString());
						EditText editor = ((EditText)findViewById(R.id.iat_text));
						String text = editor.getText().toString()+iattext;
						editor.setText(text);
		            } else {
		                Log.d(TAG, "recognizer result : null");
		                showTip("无识别结果");
		            }	
				}
			});
            
        }
        
        @Override
        public void onError(int errorCode) throws RemoteException {
			showTip("onError Code："	+ errorCode);
        }
        
        @Override
        public void onEndOfSpeech() throws RemoteException {
			showTip("onEndOfSpeech");
        }
        
        @Override
        public void onBeginOfSpeech() throws RemoteException {
			showTip("onBeginOfSpeech");
        }
    };
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        // 退出时释放连接
        mIat.cancel(mRecognizerListener);
        mIat.destory();
    }
	
	private void showTip(final String str)
	{
		runOnUiThread(new Runnable() {
			@Override
			public void run() {
				mToast.setText(str);
				mToast.show();
			}
		});
	}
	
	/**
	 * 判断action是否存在。
	 * @param context
	 * @return
	 */
	public boolean isActionSupport(Context context) {
        final PackageManager packageManager = context.getPackageManager();
        final Intent intent = new Intent(ACTION_INPUT);
        // 检索所有可用于给定的意图进行的活动。如果没有匹配的活动，则返回一个空列表。
        List<ResolveInfo> list = packageManager.queryIntentActivities(intent,
                PackageManager.MATCH_DEFAULT_ONLY);
        return list.size() > 0;
    }
}
