/*******************************************************************************
 * Copyright 2013 aispeech
 ******************************************************************************/
package com.aispeech.sample;

import java.io.ByteArrayOutputStream;
import java.io.File;

import android.app.Activity;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemSelectedListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;

import com.aispeech.AIEngineConfig;
import com.aispeech.AIError;
import com.aispeech.AIResult;
import com.aispeech.common.AIConstant;
import com.aispeech.param.CloudTTSParams;
import com.aispeech.tts.TTSPlayer;
import com.aispeech.tts.TTSPlayerListener;
import com.aispeech.util.Tools;

public class CloudTTS extends Activity implements View.OnClickListener,
		OnItemSelectedListener {

	final static String CN_PREVIEW = "苏州今天天气3℃到9℃ 阴,偏北风3到5级,明天5℃到11℃ 多云转晴，后天8℃到15℃";
	final static String EN_PREVIEW = "I want know the past and present of HongKong";

	final String Tag = this.getClass().getName();
	CloudTTSParams params;
	
	TTSPlayer ttsPlayer;

	TextView tip;
	EditText content;
	Button btnStart, btnStop, btnClear;
	Spinner spinner_coretype, spinner_res;

	File lastAudioFile;
	File audioPath;
	ByteArrayOutputStream bos = new ByteArrayOutputStream();

	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.cloud_tts);

		tip = (TextView) findViewById(R.id.tip);
		content = (EditText) findViewById(R.id.content);
		btnStart = (Button) findViewById(R.id.btn_start);
		btnStop = (Button) findViewById(R.id.btn_end);
		btnClear = (Button) findViewById(R.id.btn_clear);
		spinner_coretype = (Spinner) findViewById(R.id.spinner_type);
		spinner_res = (Spinner) findViewById(R.id.spinner_res);

		content.setText(CN_PREVIEW);

		btnStart.setEnabled(false);
		btnStop.setEnabled(false);
		btnStart.setOnClickListener(this);
		btnStop.setOnClickListener(this);
		btnClear.setOnClickListener(this);
		spinner_coretype.setOnItemSelectedListener(this);
		spinner_res.setOnItemSelectedListener(this);

		AIEngineConfig config = new AIEngineConfig(this, false);
		
		config.setAppKey(AppKey.APPKEY);
		config.setSecretKey(AppKey.SECRETKEY);
		// 创建云端合成播放器
		ttsPlayer = new TTSPlayer(this, config,true);
		ttsPlayer.setTTSPlayerListener(new TTSListenerImpl());

		params = new CloudTTSParams();
		
		// 指定默认中文合成
		params.setTTSLanguage(AIConstant.CN_TTS);
		
		// 默认女声
		params.setRes(spinner_res.getSelectedItem().toString());
		
	}

	@Override
	public void onClick(View v) {
		if (v == btnStart) {
			String refText = content.getText().toString();
			if (spinner_coretype.getSelectedItem().toString()
					.equals(CloudTTSParams.CORE_TYPE_EN)) {
				refText = Tools.enFormat(refText);
				params.setTTSLanguage(AIConstant.EN_TTS);
			} else {
				params.setTTSLanguage(AIConstant.CN_TTS);
			}
			if (!TextUtils.isEmpty(refText)) {
				params.setRefText(refText);
				ttsPlayer.startTTS(params);
				tip.setText("正在合成...");
			} else {
				tip.setText("没有合法文本");
			}

		} else if (v == btnStop) {
			ttsPlayer.stopTTS();
			tip.setText("已取消！");

		} else if (v == btnClear) {
			content.setText("");
		}
	}

	@Override
	public void onItemSelected(AdapterView<?> view, View arg1, int arg2,
			long arg3) {
		if (view == spinner_coretype) {
			String type = spinner_coretype.getSelectedItem().toString();
			if (type.equals(CloudTTSParams.CORE_TYPE_CN_SENT)) {
				content.setText(CN_PREVIEW);
				params.setTTSLanguage(AIConstant.CN_TTS);
				ArrayAdapter<String> spinnerArrayAdapter = new ArrayAdapter<String>(
						this, android.R.layout.simple_spinner_dropdown_item,
						getResources().getStringArray(R.array.tts_cn_res));
				spinner_res.setAdapter(spinnerArrayAdapter);
			} else if (type.equals(CloudTTSParams.CORE_TYPE_EN)) {
				content.setText(EN_PREVIEW);
				params.setTTSLanguage(AIConstant.EN_TTS);
				ArrayAdapter<String> spinnerArrayAdapter = new ArrayAdapter<String>(
						this, android.R.layout.simple_spinner_dropdown_item,
						getResources().getStringArray(R.array.tts_en_res));
				spinner_res.setAdapter(spinnerArrayAdapter);
			}
		}
		if (view == spinner_res) {
			params.setRes(spinner_res.getSelectedItem().toString());
		}
	}
	
	private class TTSListenerImpl implements TTSPlayerListener {


		public void onError(AIError error) {
			tip.setText("检测到错误");
			content.setText(content.getText() + "\nError:\n" + error.toString());
		}

		@Override
		public void onInit(int status) {
			Log.i(Tag, "初始化完成，返回值：" + status);
			if (status == AIConstant.OPT_SUCCESS) {
				tip.setText("初始化成功!");
				btnStart.setEnabled(true);
				btnStop.setEnabled(true);
			} else {
				tip.setText("初始化失败!code:" + status);
			}

		}

		@Override
		public void onCompletion() {
			tip.setText("合成完成");
		}

		@Override
		public void onReady() {

		}

		@Override
		public void onResults(AIResult result) {
			
		}
	}

	@Override
	public void onNothingSelected(AdapterView<?> arg0) {

	}

	@Override
	public void onStop() {
		super.onStop();
		if (ttsPlayer != null) {
			ttsPlayer.stopTTS();
		}
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
		if (ttsPlayer != null) {
			ttsPlayer.releaseTTS();
			ttsPlayer = null;
		}
	}

}
