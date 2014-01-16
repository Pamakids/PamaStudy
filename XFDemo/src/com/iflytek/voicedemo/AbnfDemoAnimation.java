package com.iflytek.voicedemo;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.graphics.drawable.AnimationDrawable;
import android.os.Bundle;
import android.os.RemoteException;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import com.iflytek.speech.*;
import com.iflytek.speech.util.XmlParser;

import java.io.InputStream;
import java.util.Timer;
import java.util.TimerTask;

public class AbnfDemoAnimation extends Activity implements OnClickListener{
	private static String TAG = "AbnfDemoAnimation";
	// 语音识别对象
	private SpeechRecognizer mRecognizer;
	private Toast mToast;	
	// 缓存
	private SharedPreferences mSharedPreferences;
	private String mLocalGrammar = null;
	private static final String KEY_GRAMMAR_ABNF_ID = "grammar_abnf_id";
	private static final String GRAMMAR_TYPE = "abnf";
	
	@SuppressLint("ShowToast")
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.abnfdemoanimation);
		initLayout();
		
		// 初始化识别对象
		mRecognizer = new SpeechRecognizer(this, mInitListener);		
		mToast = Toast.makeText(this,"",Toast.LENGTH_LONG);


        new Timer().schedule(new TimerTask() {
            @Override
            public void run() {
                initRecgnizer();
            }
        },1000);

	}
	
	/**
	 * 初期化。
	 */
	private void initLayout(){
		findViewById(R.id.isr_animation).setOnClickListener(this);
		findViewById(R.id.isr_animation).setEnabled(false);
        findViewById(R.id.outputText).setEnabled(false);

        animation = ((ImageView)findViewById(R.id.animationIV));
        animationDrawable = (AnimationDrawable) animation.getDrawable();
		
		// 初始化缓存对象
		mSharedPreferences = getSharedPreferences(getPackageName(),	MODE_PRIVATE);
		
		mLocalGrammar = readFile("call.bnf", "utf-8");
	}

    private ImageView animation;
    private AnimationDrawable animationDrawable;

    private boolean inited;

    private void initRecgnizer(){
           if(!inited){
               String grammarContent;

               grammarContent = new String(mLocalGrammar);
               mRecognizer.setParameter(SpeechRecognizer.GRAMMAR_ENCODEING,"utf-8");
               //本地语法构建需要指定

               mRecognizer.setParameter("local_scn", "call");
               mRecognizer.setParameter(SpeechConstant.ENGINE_TYPE, "local");

               int ret = mRecognizer.buildGrammar(GRAMMAR_TYPE, grammarContent, grammarListener);
               if(ret != ErrorCode.SUCCESS) {
                   showTip("语法构建失败：" + ret);
                   inited=false;
               }else   {
                   inited=true;
                   if(animationDrawable!=null)
                       animationDrawable.start();
               }
           }
    }
	
	/**
     * 初期化监听器。
     */
    private InitListener mInitListener = new InitListener() {

		@Override
		public void onInit(ISpeechModule arg0, int code) {
			Log.d(TAG, "SpeechRecognizer init() code = " + code);
        	if (code == ErrorCode.SUCCESS) {
        		findViewById(R.id.isr_animation).setEnabled(true);
        	}
		}
    };

	@Override
	public void onClick(View view) {		
		switch(view.getId())
		{
			case R.id.isr_animation:
                initRecgnizer();

                if(!recording&&stopped)
                {
				mRecognizer.setParameter(SpeechConstant.ENGINE_TYPE, "local");
				mRecognizer.setParameter(SpeechRecognizer.GRAMMAR_ID, "call");

				int recode = mRecognizer.startListening(mRecognizerListener);
				if(recode != ErrorCode.SUCCESS)
					showTip("语法识别失败：" + recode);
                    else{
//                    listening=true;
                }
                }
//                else
                {
//                mRecognizer.stopListening(mRecognizerListener);
//                    listening=false;
                }
				break;
		}
	}

	
	@Override
	protected void onDestroy() {
		mRecognizer.cancel(mRecognizerListener);
		mRecognizer.destory();
		super.onDestroy();
	}
	
	private GrammarListener grammarListener = new GrammarListener.Stub() {
		
		@Override
		public void onBuildFinish(String grammarId, int errorCode) throws RemoteException {
			if(errorCode == ErrorCode.SUCCESS){
				String grammarID = new String(grammarId);
				Editor editor = mSharedPreferences.edit();
				if(!TextUtils.isEmpty(grammarId))
					editor.putString(KEY_GRAMMAR_ABNF_ID, grammarID);
				editor.commit();				
				showTip("语法构建成功：" + grammarId);
			}else{
				showTip("语法构建失败，错误码：" + errorCode);
			}
		}
	};

    private boolean recording;
    private boolean stopped=true;

    private void stopListener(){
        if(!stopped){
            mRecognizer.stopListening(mRecognizerListener);
        }
        stopped=true;
    }
	
	/**
     * 识别回调。
     */
    private RecognizerListener mRecognizerListener = new RecognizerListener.Stub() {
        
        @Override
        public void onVolumeChanged(int v) throws RemoteException {
            vol=v;
            if(recording){
                 if(vol==0&&!stopped){
                     recording=false;
                     new Timer().schedule(new TimerTask() {
                         @Override
                         public void run() {
                             stopListener();
                         }
                     },500);
                 }
            }
            else{
                  if(vol>0&&stopped){
                      stopped=false;
                      recording=true;
                  }
            }
            showTip("onVolumeChanged："	+ v);

            Log.d("vol++++++++++++",v+"");
        }

        @Override
        public void onResult(final RecognizerResult result, boolean isLast)
                throws RemoteException {
        	runOnUiThread(new Runnable() {
				@Override
				public void run() {
					if (null != result) {
						
						Log.i(TAG, "recognizer result：" + result.getResultString());
						String text = XmlParser.parseNluResult(result.getResultString());
//						String text = result.getResultString();
		            	// 显示

                        ((TextView)findViewById(R.id.outputText)).setText(text);

                        if(text.indexOf("stop")>=0)
                            animationDrawable.stop();
                        else if(text.indexOf("go")>=0)
                            animationDrawable.start();
		            } else {
		                Log.d(TAG, "recognizer result : null");
		            }	
				}
			});
            
        }
        
        @Override
        public void onError(int errorCode) throws RemoteException {
			showTip("onError Code："	+ errorCode);
            recording=false;
            stopped=true;
            ((TextView)findViewById(R.id.outputText)).setText("未识别");
        }
        
        @Override
        public void onEndOfSpeech() throws RemoteException {
			showTip("onEndOfSpeech");
            recording=false;
            stopped=true;
        }
        
        @Override
        public void onBeginOfSpeech() throws RemoteException {
			showTip("onBeginOfSpeech");
        }
    };

    private double vol=0;
    
	/**
	 * 读取语法文件。
	 * @return
	 */
	private String readFile(String file,String code)
	{
		int len = 0;
		byte []buf = null;
		String grammar = "";
		try {
			InputStream in = getAssets().open(file);			
			len  = in.available();
			buf = new byte[len];
			in.read(buf, 0, len);
			
			grammar = new String(buf,code);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return grammar;
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
