package com.iflytek.voicedemo;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.os.RemoteException;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.TextView;
import android.widget.Toast;
import com.iflytek.speech.*;
import com.iflytek.speech.util.XmlParser;

import java.io.InputStream;
import java.util.Timer;
import java.util.TimerTask;

public class AbnfDemoVoice extends Activity implements OnClickListener{
	private static String TAG = "AbnfDemoVoice";
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
		setContentView(R.layout.abnfdemovoice);
		initLayout();
		
		// 初始化识别对象
		mRecognizer = new SpeechRecognizer(this, mInitListener);
        mTts = new SpeechSynthesizer(this, mTtsInitListener);
		mToast = Toast.makeText(this,"",Toast.LENGTH_LONG);


        new Timer().schedule(new TimerTask() {
            @Override
            public boolean cancel() {
                return super.cancel();    //To change body of overridden methods use File | Settings | File Templates.
            }

            @Override
            public void run() {
                initRecgnizer();
            }
        },1000);
	}

    private String[] slotArr={"good morning","good afternoon","good evening",
            "How are you","are you hungry","Have a cookie","have an apple","have a drink",
            "What's your name","What's this"};

    private String[] responseArr={"good morning","good afternoon","good evening",
            "fine thank you","yes i am hungry","thank you","thank you","thank you",
            "I am Molly","it's my nose"};

    private String getSlots(){
        String str="";
        for (int i=0;i<slotArr.length;i++)
        {
            String slot= slotArr[i].toLowerCase();
             if(i==0)
                 str+=slot ;
             else
                 str+=("\n"+ slot);
            slotArr[i]=slot;
        }
        return str;
    }

    private SpeechSynthesizer mTts;

    /**
     * 初期化监听。
     */
    private InitListener mTtsInitListener = new InitListener() {

        @Override
        public void onInit(ISpeechModule arg0, int code) {
            Log.d(TAG, "InitListener init() code = " + code);
        }
    };
	
	/**
	 * 初期化。
	 */
	private void initLayout(){
		findViewById(R.id.isr_voice).setOnClickListener(this);
		findViewById(R.id.isr_voice).setEnabled(false);
        findViewById(R.id.outputTextVoice).setEnabled(false);

		
		// 初始化缓存对象
		mSharedPreferences = getSharedPreferences(getPackageName(),	MODE_PRIVATE);
		
		mLocalGrammar = readFile("voice.bnf", "utf-8");
	}

    /**
     * 合成语音。
     */
    private void playVoice(String text){
        // 设置参数
        ((TextView)findViewById(R.id.responceText)).setText(text);
        mTts.setParameter(SpeechSynthesizer.SPEED, "50");    //语速
        mTts.setParameter(SpeechSynthesizer.PITCH, "50");    //音调
        int code = mTts.startSpeaking(text, mTtsListener);
        if(code != 0)
        {
            showTip("start speak error : " + code);
        }else
            showTip("start speak success.");
    }

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
            findViewById(R.id.isr_voice).setEnabled(true);
            recording=false;
            stopped=true;
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


    private boolean inited;

    private void initRecgnizer(){
           if(!inited){
               String grammarContent;

               grammarContent = new String(mLocalGrammar);
               mRecognizer.setParameter(SpeechRecognizer.GRAMMAR_ENCODEING,"utf-8");
               //本地语法构建需要指定

               mRecognizer.setParameter("local_scn", "voice");
               mRecognizer.setParameter(SpeechConstant.ENGINE_TYPE, "local");

               int ret = mRecognizer.buildGrammar(GRAMMAR_TYPE, grammarContent, grammarListener);
               if(ret != ErrorCode.SUCCESS) {
                   showTip("语法构建失败：" + ret);
                   inited=false;
               }else   {
                   inited=true;
               }

               mRecognizer.setParameter(SpeechConstant.ENGINE_TYPE, "local");
               mRecognizer.setParameter(SpeechRecognizer.GRAMMAR_LIST, "voice");
               String slot = new String();
               slot = getSlots();
               if(slot.length()>0) {
                   mRecognizer.updateLexicon("<chat>", slot, lexiconListener);
               }

               mTts.setParameter(SpeechConstant.ENGINE_TYPE, "local");
               mTts.setParameter(SpeechSynthesizer.VOICE_NAME,"xiaoyan");
           }
    }

    private LexiconListener lexiconListener = new LexiconListener.Stub() {

        @Override
        public void onLexiconUpdated(String arg0, int arg1) throws RemoteException {
            if(ErrorCode.SUCCESS == arg1)
                showTip("词典更新成功");
            else
                showTip("词典更新失败，错误码："+arg1);
        }
    };
	
	/**
     * 初期化监听器。
     */
    private InitListener mInitListener = new InitListener() {

		@Override
		public void onInit(ISpeechModule arg0, int code) {
			Log.d(TAG, "SpeechRecognizer init() code = " + code);
        	if (code == ErrorCode.SUCCESS) {
        		findViewById(R.id.isr_voice).setEnabled(true);
        	}
		}
    };

	@Override
	public void onClick(View view) {		
		switch(view.getId())
		{
			case R.id.isr_voice:
//                findViewById(R.id.isr_voice).setEnabled(false);
                initRecgnizer();

                if(!recording&&stopped)
                {
				mRecognizer.setParameter(SpeechConstant.ENGINE_TYPE, "local");
				mRecognizer.setParameter(SpeechRecognizer.GRAMMAR_ID, "voice");

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

    private int checkResult(String reslut){
        for(int i=0; i<slotArr.length;i++){
            String slot =  slotArr[i].toLowerCase();
            if(slot.indexOf(reslut.toLowerCase())>=0)
                return i;
        }
        return -1;
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
		            	// 显示

                        ((TextView)findViewById(R.id.outputTextVoice)).setText(text);

                        int index = checkResult(text);
                        if(index>=0)
                            playVoice(responseArr[index]);
                        else {
                            ((TextView)findViewById(R.id.responceText)).setText("未识别");
                            findViewById(R.id.isr_voice).setEnabled(true);
                        }

		            } else {
		                Log.d(TAG, "recognizer result : null");
                        findViewById(R.id.isr_voice).setEnabled(true);
		            }	
				}
			});
            
        }
        
        @Override
        public void onError(int errorCode) throws RemoteException {
            findViewById(R.id.isr_voice).setEnabled(true);
			showTip("onError Code："	+ errorCode);
            recording=false;
            stopped=true;
            ((TextView)findViewById(R.id.outputTextVoice)).setText("未识别");
        }
        
        @Override
        public void onEndOfSpeech() throws RemoteException {
            findViewById(R.id.isr_voice).setEnabled(true);
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
