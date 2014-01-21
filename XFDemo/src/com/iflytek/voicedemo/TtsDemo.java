package com.iflytek.voicedemo;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.RemoteException;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.Toast;

import com.iflytek.speech.ErrorCode;
import com.iflytek.speech.ISpeechModule;
import com.iflytek.speech.InitListener;
import com.iflytek.speech.SpeechConstant;
import com.iflytek.speech.SpeechSynthesizer;
import com.iflytek.speech.SynthesizerListener;

public class TtsDemo extends Activity implements OnClickListener{
 	private static String TAG = "TtsDemo"; 	
 	// 语音合成对象
	private SpeechSynthesizer mTts;
	private Toast mToast;
	private RadioGroup mRadioGroup;
	private Button mBtnPerson;     //选择发音人按钮
	private int mNativePerson=0;
	private int mOnlinePerson=0;
	
 	@SuppressLint("ShowToast")
	public void onCreate(Bundle savedInstanceState)
 	{
 		super.onCreate(savedInstanceState);
 		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
 		setContentView(R.layout.ttsdemo);
 		initLayout();
 		 		
 		// 初始化合成对象
 		mTts = new SpeechSynthesizer(this, mTtsInitListener);
 		mToast = Toast.makeText(this,"",Toast.LENGTH_LONG); 		
 	}
 	
 	/**
 	 * 初期化。
 	 */
 	private void initLayout(){
 		findViewById(R.id.tts_play).setOnClickListener(this);
 		findViewById(R.id.tts_play).setEnabled(false);
 		
 		findViewById(R.id.tts_cancel).setOnClickListener(this);
 		findViewById(R.id.tts_pause).setOnClickListener(this);
 		findViewById(R.id.tts_resume).setOnClickListener(this);
 		mBtnPerson=(Button) findViewById(R.id.tts_btn_person_select);
 		mBtnPerson.setOnClickListener(this);
 		mRadioGroup=((RadioGroup) findViewById(R.id.tts_rediogroup));
 		mRadioGroup.setOnCheckedChangeListener(new OnCheckedChangeListener() {
		
			@Override
			public void onCheckedChanged(RadioGroup group, int checkedId) {
				switch (checkedId) {
				case R.id.tts_radiobtn_native:
					/**
					 * 选择本地合成
					 */
					mTts.setParameter(SpeechConstant.ENGINE_TYPE, "local");
					break;
				case R.id.tts_radiobtn_online:
					/**
					 * 选择在线合成
					 */
					mTts.setParameter(SpeechConstant.ENGINE_TYPE, "cloud");
					break;
				default:
					break;
				}
				
			}
		} );
 	}	

 	@Override
 	public void onClick(View view) {
 		switch(view.getId())
 		{
 			case R.id.tts_play:
 				String text = ((EditText)findViewById(R.id.tts_text)).getText().toString();
				// 设置参数
//				mTts.setParameter(SpeechSynthesizer.VOICE_NAME, "vixk");
				mTts.setParameter(SpeechSynthesizer.SPEED, "50");
				mTts.setParameter(SpeechSynthesizer.PITCH, "100");
				int code = mTts.startSpeaking(text, mTtsListener);
				if(code != 0)
				{
					showTip("start speak error : " + code);
				}else
					showTip("start speak success.");
 				break;
 			case R.id.tts_cancel:
 				mTts.stopSpeaking(mTtsListener);
 				break;
 			case R.id.tts_pause:
 				mTts.pauseSpeaking(mTtsListener);
 				break;
 			case R.id.tts_resume:
 				mTts.resumeSpeaking(mTtsListener);
 				break;
 			case R.id.tts_btn_person_select:
 				showPresonSelectDialog();
 				break;
 		}
 	}
 	
	/**
	 * 发音人选择。
	 */
	private void showPresonSelectDialog() {
		switch (mRadioGroup.getCheckedRadioButtonId()) {
		case R.id.tts_radiobtn_native:
			// 选择本地合成，目前只支持小燕一个发音人
			final String[] nativePersons = new String[] { "xiaoyan" };
			new AlertDialog.Builder(this).setTitle("本地合成发音人选项")
					.setSingleChoiceItems(new String[] { "小燕" }, // 单选框有几项,各是什么名字
							mNativePerson, // 默认的选项
							new DialogInterface.OnClickListener() { // 点击单选框后的处理
								public void onClick(DialogInterface dialog,
										int which) { // 点击了哪一项
									mTts.setParameter(SpeechSynthesizer.VOICE_NAME,	nativePersons[which]);
									mNativePerson = which;
									dialog.dismiss();
								}
							}).show();
			break;
		case R.id.tts_radiobtn_online:
			// 选择在线合成
			final String[] onlinePersons = new String[] { "xiaoyan", "vixq", "vixyun", "vixx", "vixl", "vixr" };
			new AlertDialog.Builder(this)
					.setTitle("在线合成发音人选项")
					.setSingleChoiceItems(
							new String[] { "小燕", "小琪", "小芸", "小新", "小莉", "小蓉" }, // 单选框有几项,各是什么名字
							mOnlinePerson, // 默认的选项
							new DialogInterface.OnClickListener() { // 点击单选框后的处理
								public void onClick(DialogInterface dialog,
										int which) { // 点击了哪一项
									mTts.setParameter(SpeechSynthesizer.VOICE_NAME,	onlinePersons[which]);
									mOnlinePerson = which;
									dialog.dismiss();
								}
							}).show();
			break;
		default:
			break;
		}

	}

	/**
     * 初期化监听。
     */
    private InitListener mTtsInitListener = new InitListener() {

		@Override
		public void onInit(ISpeechModule arg0, int code) {
			Log.d(TAG, "InitListener init() code = " + code);
        	if (code == ErrorCode.SUCCESS) {
        		((Button)findViewById(R.id.tts_play)).setEnabled(true);
        	}
		}
    };
        
    /**
     * 合成回调监听。
     */
    private SynthesizerListener mTtsListener = new SynthesizerListener.Stub() {
        @Override
        public void onBufferProgress(int progress) throws RemoteException {
        	 Log.d(TAG, "onBufferProgress :" + progress);
        	 showTip("onBufferProgress :" + progress);
        }

        @Override
        public void onCompleted(int code) throws RemoteException {
            Log.d(TAG, "onCompleted code =" + code);
            showTip("onCompleted code =" + code);
        }

        @Override
        public void onSpeakBegin() throws RemoteException {
            Log.d(TAG, "onSpeakBegin");
            showTip("onSpeakBegin");
        }

        @Override
        public void onSpeakPaused() throws RemoteException {
        	 Log.d(TAG, "onSpeakPaused.");
        	 showTip("onSpeakPaused.");
        }

        @Override
        public void onSpeakProgress(int progress) throws RemoteException {
        	Log.d(TAG, "onSpeakProgress :" + progress);
        	showTip("onSpeakProgress :" + progress);
        }

        @Override
        public void onSpeakResumed() throws RemoteException {
        	Log.d(TAG, "onSpeakResumed.");
        	showTip("onSpeakResumed");
        }
    };
    
    @Override
    protected void onDestroy() {
        super.onDestroy();
        mTts.stopSpeaking(mTtsListener);
        // 退出时释放连接
        mTts.destory();
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
}
