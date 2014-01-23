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
import com.aispeech.common.AIConstant;
import com.aispeech.common.JSONResultParser;
import com.aispeech.param.CloudASRParams;
import com.aispeech.ui.AIRecognizerDialog;
import com.aispeech.ui.AIRecognizerListener;

public class CloudASRMultiResult extends Activity {

	public static final String TAG = CloudASRMultiResult.class.getCanonicalName();
	
	AIRecognizerDialog mAIRecognizerDialog;
	CloudASRParams params;

	TextView textResult = null;
	Button clickBtn;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.cloudasrui);

		clickBtn = (Button) findViewById(R.id.clickBtn);
		clickBtn.setEnabled(false);

		clickBtn.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				Log.i(TAG,"params:"+params.toString());
				textResult.setText("");
				mAIRecognizerDialog.show(params);
			}
		});

		textResult = (TextView) findViewById(R.id.textResult);

		params = new CloudASRParams();
		// 指定语音云端识别资源名
 		params.setRTMode(AIConstant.RT_MODE_VAD);
		// 不限录音时长
 		params.setMaxSpeechTimeS(0);
 		params.setVolEnable(true);

		// 设置云端识别引擎配置，关闭自动语音端点检测
		AIEngineConfig config = new AIEngineConfig(this, false);
		config.setAppKey(AppKey.APPKEY);
		config.setSecretKey(AppKey.SECRETKEY);
		mAIRecognizerDialog = new AIRecognizerDialog(this, config);

		mAIRecognizerDialog.setListener(new AIRecognizerListener() {

			public void onError(AIError error) {
				textResult.setText(error.toString());
			}

			public void onResults(AIResult results) {
				if (results.getResultType() == AIConstant.AIENGINE_MESSAGE_TYPE_JSON) {
					Log.i(TAG,results.getResultObject().toString());
					JSONResultParser parser = new JSONResultParser(
							(String) results.getResultObject());
					// 当前正在识别的结果/最终结果					
					String rec = parser.getRec();
					// 已经稳定的结果
					String recd = parser.getRecd();
					StringBuilder sb = new StringBuilder();
					sb.append("[recd]:");
					sb.append(recd);
					sb.append("\n");
					sb.append("[rec]:");
					sb.append(rec);
					
					textResult.setText(sb.toString());
				}
			}

			@Override
			public void onInit(int status) {
				if (status == AIConstant.OPT_SUCCESS) {
					textResult.setText("初始化成功!");
					clickBtn.setEnabled(true);
				} else {
					textResult.setText("初始化失败!code:" + status);
					clickBtn.setEnabled(false);
				}
			}


			@Override
			public void onDismiss() {
				// 识别窗口消失时调用

			}

			@Override
			public void onCancel() {
				// 识别窗口被取消时调用
				
			}

		});

	}
	
}
