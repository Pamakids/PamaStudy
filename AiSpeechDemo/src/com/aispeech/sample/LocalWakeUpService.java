/*******************************************************************************
 * Copyright 2013 aispeech
 ******************************************************************************/
package com.aispeech.sample;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.aispeech.AIEngineConfig;
import com.aispeech.AIError;
import com.aispeech.AIResult;
import com.aispeech.client.AISpeechEngine;
import com.aispeech.common.AIConstant;
import com.aispeech.common.Util;
import com.aispeech.localservice.LocalWakeupConfig;
import com.aispeech.param.LocalWakeupParams;
import com.aispeech.speech.BaseSpeechListener;
import com.aispeech.speech.SpeechReadyInfo;

public class LocalWakeUpService extends Activity implements View.OnClickListener {

	final String Tag = this.getClass().getName();
	AISpeechEngine engine;
	LocalWakeupParams params;
	TextView resultText;
	Button btnStart;
	Button btnStop;

	String netFileName = "wakeup.net.bin.imy"; // 唤醒解码网络文件名
	String resFileName = "wakeup.res.bin.imy"; // 唤醒资源文件名
	
	Toast mToast;
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.asr);

		resultText = (TextView) findViewById(R.id.text_result);
		resultText.setText("语音唤醒演示:唤醒词是：思必驰科技");
		btnStart = (Button) findViewById(R.id.btn_start);
		btnStop = (Button) findViewById(R.id.btn_end);
		String wakeUpResDir = Util.getResourceDir(this);
		// 资源拷贝为耗时操作，须放在非UI线程处理，这里未处理
		Util.copyResource(this, netFileName);
		Util.copyResource(this, resFileName);

		btnStart.setEnabled(false);
		btnStop.setEnabled(false);
		btnStart.setOnClickListener(this);
		btnStop.setOnClickListener(this);

		AIEngineConfig config = new AIEngineConfig(this, false);
		// 配置唤醒引擎所用的资源
		LocalWakeupConfig subConfig = new LocalWakeupConfig();
		subConfig.setNetBinFile(netFileName);
		subConfig.setResBinFile(resFileName);
		subConfig.setResDir(wakeUpResDir);
		config.setLocalConfig(subConfig);
		config.setAppKey(AppKey.APPKEY);
		config.setSecretKey(AppKey.SECRETKEY);
		config.setUseService(true);

		// 创建语音唤醒引擎，注册语音唤醒引擎回调监听接口AISpeechListenerImpl
		engine = new AISpeechEngine(new AISpeechListenerImpl(), config);
		params = new LocalWakeupParams();
		
		mToast = Toast.makeText(this, "", Toast.LENGTH_LONG);
	}

	@Override
	public void onClick(View v) {
		if (v == btnStart) {
			engine.start(params);
		} else if (v == btnStop) {
			engine.stop();
			resultText.setText("已取消！");
		}
	}

	private class AISpeechListenerImpl extends BaseSpeechListener {
		@Override
		public void onReadyForSpeech(SpeechReadyInfo params) {
			resultText.setText("请说话...\n");
		}
		
		@Override
		public void onBeginningOfSpeech(){
			resultText.setText("检测到开始说话\n");
		}

		@Override
		public void onError(AIError error) {
			showTip(error.toString());
		}
		
		@Override
		public void onEndOfSpeech() {
			resultText.append("检测到语音停止\n");
		}

		@Override
		public void onResults(AIResult results) {
			Log.i(Tag,"result:"+results.getResultObject().toString());
			if (results.isLast()) {
				if (results.getResultType() == AIConstant.AIENGINE_MESSAGE_TYPE_JSON) {
					resultText.append(results.getResultObject().toString()+"\n");
				}
			}
		}
		
		

		@Override
		public void onInit(int status) {
			Log.i(Tag, "Init result " + status);
			if (status == AIConstant.OPT_SUCCESS) {
				resultText.setText("初始化成功!(唤醒词为：思必驰科技)");
				btnStart.setEnabled(true);
				btnStop.setEnabled(true);
			} else {
				resultText.setText("初始化失败!code:" + status);
			}
		}
	}
	
	private void showTip(final String str) {
		runOnUiThread(new Runnable() {
			@Override
			public void run() {
				mToast.setText(str);
				mToast.show();
			}
		});
	}


	@Override
	public void onStop() {
		super.onStop();
		if (engine != null) {
			engine.cancel();
		}
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		if (engine != null) {
			engine.release();
			engine = null;
		}
	}

}
