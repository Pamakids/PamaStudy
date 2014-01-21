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
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import com.iflytek.speech.*;
import com.iflytek.speech.util.XmlParser;

import java.io.InputStream;
import java.util.Timer;
import java.util.TimerTask;

public class AbnfDemo extends Activity implements OnClickListener{
	private static String TAG = "AbnfDemo";
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
		setContentView(R.layout.abnfdemo);		
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
		findViewById(R.id.isr_recognize).setOnClickListener(this);
		findViewById(R.id.isr_recognize).setEnabled(false);

		findViewById(R.id.isr_lexcion).setOnClickListener(this);

        findViewById(R.id.outputText2).setEnabled(false);
		
		// 初始化缓存对象
		mSharedPreferences = getSharedPreferences(getPackageName(),	MODE_PRIVATE);
		
		mLocalGrammar = readFile("call.bnf", "utf-8");


	}

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
               }else
                   inited=true;
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
        		findViewById(R.id.isr_recognize).setEnabled(true);
        	}
		}
    };

    private String[] slotArr = {"four","five","six"};

    private String getSlots(String[] strArr){
       String str=new String();
       for (int i=0;i<strArr.length-1;i++){
                    if(i==0)
                        str+=strArr[i];
           else
                        str+="\n"+strArr[i];
        }
        System.out.print(str);
        return str;
    }

    private String slotString="";

    private String getInput(){
        String reslut = ((EditText)findViewById(R.id.isr_slot_input)).getText().toString().toLowerCase();
        ((EditText)findViewById(R.id.isr_slot_input)).setText("");
        if(slotString.length()==0)
            slotString+=reslut;
        else
            slotString+=("\n"+reslut);
        return slotString;
    }

	@Override
	public void onClick(View view) {		
		switch(view.getId())
		{
			case R.id.isr_lexcion:
                initRecgnizer();
				mRecognizer.setParameter(SpeechConstant.ENGINE_TYPE, "local");
				mRecognizer.setParameter(SpeechRecognizer.GRAMMAR_LIST, "call");
                String slot = new String();
//                slot = getSlots(slotArr);
                slot = getInput();
                if(slot.length()>0) {
				    mRecognizer.updateLexicon("<move>", slot, lexiconListener);
                }
				break;
			case R.id.isr_recognize:
//				((EditText)findViewById(R.id.isr_result_text)).setText("");
				
				mRecognizer.setParameter(SpeechConstant.ENGINE_TYPE, "local");
				mRecognizer.setParameter(SpeechRecognizer.GRAMMAR_ID, "call");

				int recode = mRecognizer.startListening(mRecognizerListener);
				if(recode != ErrorCode.SUCCESS)
					showTip("语法识别失败：" + recode);
				break;
		}
	}
	
	@Override
	protected void onDestroy() {
		mRecognizer.cancel(mRecognizerListener);
		mRecognizer.destory();
		super.onDestroy();
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

            if(recording){
                if(v==0&&!stopped){
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
                if(v>0&&stopped){
                    stopped=false;
                    recording=true;
                }
            }

            showTip("onVolumeChanged："	+ v);
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

                        ((TextView)findViewById(R.id.outputText2)).setText(text);
		            } else {
		                Log.d(TAG, "recognizer result : null");
		            }	
				}
			});
            
        }
        
        @Override
        public void onError(int errorCode) throws RemoteException {
			showTip("onError Code："	+ errorCode);
            ((TextView)findViewById(R.id.outputText2)).setText("未识别");
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
