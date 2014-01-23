package com.aispeech.sample;

import java.io.File;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioGroup;
import android.widget.RadioGroup.OnCheckedChangeListener;
import android.widget.TextView;

import com.aispeech.AIEngineConfig;
import com.aispeech.AIError;
import com.aispeech.AIResult;
import com.aispeech.common.AIConstant;
import com.aispeech.common.TSStatistics;
import com.aispeech.common.Util;
import com.aispeech.localservice.LocalTTSConfig;
import com.aispeech.param.LocalTTSParams;
import com.aispeech.tts.TTSPlayer;
import com.aispeech.tts.TTSPlayerListener;

public class LocalTTSService extends Activity implements OnClickListener, OnCheckedChangeListener {

	final static String CN_PREVIEW = "苏州今天天气3℃到9℃ 阴，偏北风3到5级，明天5℃到11℃ 多云转晴，后天8℃到15℃";

	final String Tag = this.getClass().getName();
	LocalTTSParams params;

	String resFileName_F_xiaolin = "xiaolin_female.bin";
	String resFileName_F_zhiling = "zhiling_female.bin";
	String zipFileName = "tts.zip.imy";

	TextView tip;
	EditText content;
	Button btnStart, btnPlayerPause, btnPlayerResume, btnPlayerStop;
	RadioGroup resSelect;
	String resDir;
	

	private TTSPlayer ttsPlayer;


	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.local_tts);

		tip = (TextView) findViewById(R.id.tip);
		content = (EditText) findViewById(R.id.content);
		btnStart = (Button) findViewById(R.id.btn_start);
		btnPlayerPause = (Button) findViewById(R.id.btn_pause);
		btnPlayerResume = (Button) findViewById(R.id.btn_resume);
		btnPlayerStop = (Button) findViewById(R.id.btn_stop);
		resSelect = (RadioGroup) findViewById(R.id.resSelect);
		resSelect.setOnCheckedChangeListener(this);
		content.setText(CN_PREVIEW);

		btnStart.setEnabled(false);
		btnPlayerPause.setOnClickListener(this);
		btnPlayerResume.setOnClickListener(this);
		btnPlayerStop.setOnClickListener(this);
		btnStart.setOnClickListener(this);
		
		resDir = Util.getResourceDir(this);
		// 资源拷贝为耗时操作，须放在非UI线程处理，这里未处理
		Util.copyResource(this, zipFileName, true);

		initEngine(resFileName_F_zhiling);
	}

	private void initEngine(String resBinFile) {
		if(ttsPlayer != null){
			ttsPlayer.releaseTTS();
			ttsPlayer = null;
		}
		AIEngineConfig config = new AIEngineConfig(this, false);
		LocalTTSConfig localTTSConfig = new LocalTTSConfig();
		localTTSConfig.setResDir(resDir);
		localTTSConfig.setResBinFile(resBinFile);
		config.setLocalConfig(localTTSConfig);
		config.setAppKey(AppKey.APPKEY);
		config.setSecretKey(AppKey.SECRETKEY);
		config.setUseService(true);

		ttsPlayer = new TTSPlayer(this, config);
		ttsPlayer.setTTSPlayerListener(new TTSListenerImpl());

		params = new LocalTTSParams();

		params.setSpeechRate(LocalTTSParams.NORMAL_SPEED);
	}

	private String savePath;

	@Override
	public void onClick(View v) {
		if (v == btnStart) {
			String refText = content.getText().toString();

			savePath = android.os.Environment.getExternalStorageDirectory()
					.getAbsolutePath()
					+ File.separator
					+ System.currentTimeMillis() + ".wav";
			
			if (!refText.equals("")) {
				if (ttsPlayer != null) {
					params.setRefText(refText);
					// 转存音频
					ttsPlayer.setSavePath(savePath);
					ttsPlayer.startTTS(params);
				}
				tip.setText("正在合成...");
			} else {
				tip.setText("没有合法文本");
			}
		} else if (v == btnPlayerPause) {
			if (ttsPlayer != null) {
				ttsPlayer.pauseTTS();
			}

		} else if (v == btnPlayerResume) {
			if (ttsPlayer != null) {
				ttsPlayer.continueTTS();
			}

		} else if (v == btnPlayerStop) {
			tip.setText("合成已停止");
			if (ttsPlayer != null) {
				ttsPlayer.stopTTS();
			}
		}
	}

	@Override
	public void onCheckedChanged(RadioGroup group, int checkedId) {
		btnStart.setEnabled(false);
		if (checkedId == R.id.male) {
			initEngine(resFileName_F_zhiling);
		} else if (checkedId == R.id.female) {
			initEngine(resFileName_F_xiaolin);
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
			TSStatistics.addTs("onReady");
		}

		@Override
		public void onResults(AIResult result) {
			TSStatistics.addTs("onresult");
		}
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
			Log.i(Tag,"release in LocalTTS");
			ttsPlayer.releaseTTS();
			ttsPlayer = null;
		}
	}

}
