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

import com.aispeech.AIEngineConfig;
import com.aispeech.AIError;
import com.aispeech.AIResult;
import com.aispeech.client.AISpeechEngine;
import com.aispeech.common.AIConstant;
import com.aispeech.common.Util;
import com.aispeech.localservice.LocalASRConfig;
import com.aispeech.param.LocalASRParams;
import com.aispeech.speech.BaseSpeechListener;
import com.aispeech.speech.SpeechReadyInfo;

public class LocalASRService extends Activity implements View.OnClickListener {

	final String Tag = this.getClass().getName();
	AISpeechEngine engine = null;
	LocalASRParams params = null;
	TextView resultText;
	Button btnStart;
	Button btnStop;

	String netFileName = "asr.net.bin.imy"; // 解码网络文件名;
	String resFileName = "asr.res.bin.imy"; // 识别资源文件名;

	@Override
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


		// 加载本地识别引擎
		String asrDir = Util.getResourceDir(this);
		// 资源拷贝为耗时操作，须放在非UI线程处理，这里未处理
		Util.copyResource(this, netFileName);
		Util.copyResource(this, resFileName);

		AIEngineConfig config = new AIEngineConfig(this, true);
		// 配置本地识别引擎所用的资源
		LocalASRConfig asrConfig = new LocalASRConfig();
		asrConfig.setNetBinFile(netFileName);
		asrConfig.setResBinFile(resFileName);
		asrConfig.setResDir(asrDir);
		config.setLocalConfig(asrConfig);
		config.setUseService(true);

		// 创建语音识别引擎，注册语音识别引擎回调监听接口AISpeechListenerImpl
		engine = new AISpeechEngine(new AISpeechListenerImpl(), config);
		// 使用本地引擎参数
		params = new LocalASRParams();
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

		public void onReadyForSpeech(SpeechReadyInfo params) {
			resultText.setText("请说话...");
		}

		public void onBeginningOfSpeech() {
			resultText.setText("检测到说话");
		}

		public void onEndOfSpeech() {
			resultText.setText("检测到语音停止，开始识别...");
		}

		public void onError(AIError error) {
			resultText.setText("错误：" + error.toString());
		}

		public void onResults(AIResult results) {
			Log.i(Tag, "onResults:" + (String) results.getResultObject());
			if (results.isLast()) {

				if (results.getResultType() == AIConstant.AIENGINE_MESSAGE_TYPE_JSON) {
					resultText.setText((String) results.getResultObject());
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
