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
import com.aispeech.common.JSONResultParser;
import com.aispeech.param.CloudASRParams;
import com.aispeech.speech.BaseSpeechListener;
import com.aispeech.speech.SpeechReadyInfo;

public class CloudASR extends Activity implements View.OnClickListener {

	final String Tag = this.getClass().getName();
	AISpeechEngine engine;
	CloudASRParams params;

	TextView resultText;
	Button btnStart;
	Button btnStop;
	Toast mToast;

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.asr);

		resultText = (TextView) findViewById(R.id.text_result);
		resultText.setText("正在加载资源...");
		btnStart = (Button) findViewById(R.id.btn_start);
		btnStop = (Button) findViewById(R.id.btn_end);

		btnStart.setEnabled(false);
		btnStop.setEnabled(false);
		btnStart.setOnClickListener(this);
		btnStop.setOnClickListener(this);

		// 设置云端识别引擎配置
		AIEngineConfig config = new AIEngineConfig(this, true);
		config.setAppKey(AppKey.APPKEY);
		config.setSecretKey(AppKey.SECRETKEY);
		
		// 创建语音识别引擎，设置语音识别回调
		engine = new AISpeechEngine(new AISpeechListenerImpl(), config);

		params = new CloudASRParams();
		// 设定多候选词最大个数，候选词个数会小于等于最大个数
		params.setNBest(3);
//		params.setUseTxtPost(true);

		Log.i(Tag, "params: =" + params.toString());

		mToast = Toast.makeText(this, "", Toast.LENGTH_LONG);
	}

	@Override
	public void onClick(View v) {
		if (v == btnStart) {
			engine.start(params);
		} else if (v == btnStop) {
			engine.stop();
		}
	}

	private class AISpeechListenerImpl extends BaseSpeechListener {

		@Override
		public void onReadyForSpeech(SpeechReadyInfo params) {
			resultText.setText("请说话...");
		}

		@Override
		public void onBeginningOfSpeech() {
			resultText.setText("检测到说话");
		}

		@Override
		public void onEndOfSpeech() {
			resultText.setText("检测到语音停止，开始识别...\n");
		}

		@Override
		public void onRmsChanged(float rmsdB) {
			showTip("RmsDB = " + rmsdB);
		}

		@Override
		public void onError(AIError error) {
			Log.i(Tag, "error:" + error.toString());
			resultText.setText(error.toString());
		}

		@Override
		public void onResults(AIResult results) {
			if (results.isLast()) {
				if (results.getResultType() == AIConstant.AIENGINE_MESSAGE_TYPE_JSON) {
					Log.i(Tag, "result JSON = " + results.getResultObject().toString());
					// 可以使用JSONResultParser来解析识别结果
					// 结果按概率由大到小排序
					JSONResultParser parser = new JSONResultParser(results.getResultObject().toString());
					for (String s : parser.getNBestRec()) {
						resultText.append("rec:"+ s + "\n");
					}
				}
			}
		}

		@Override
		public void onInit(int status) {
			Log.i(Tag, "Init result " + status);
			if (status == AIConstant.OPT_SUCCESS) {
				resultText.setText("初始化成功!");
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
