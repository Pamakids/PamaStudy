package com.aispeech.sample;

import android.app.Activity;
import android.os.Bundle;
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

public class CloudASRUI extends Activity {

	AIRecognizerDialog mAIRecognizerDialog;
	CloudASRParams params;

	TextView textResult;
	Button clickBtn;

	boolean flag;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.cloudasrui);

		clickBtn = (Button) findViewById(R.id.clickBtn);
		clickBtn.setEnabled(false);

		clickBtn.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				mAIRecognizerDialog.setStyle(flag ? AIConstant.STYLE_DARK : AIConstant.STYLE_LIGHT);
				flag = !flag;
				mAIRecognizerDialog.show(params);
			}
		});

		textResult = (TextView) findViewById(R.id.textResult);

		params = new CloudASRParams();
		params.setNBest(3);

		// 设置云端识别引擎配置
		AIEngineConfig config = new AIEngineConfig(this, true);
		config.setAppKey(AppKey.APPKEY);
		config.setSecretKey(AppKey.SECRETKEY);
		if (mAIRecognizerDialog == null) {
			mAIRecognizerDialog = new AIRecognizerDialog(this, config);
		}

		mAIRecognizerDialog.setListener(new AIRecognizerListener() {

			public void onError(AIError error) {
				textResult.setText(error.toString());
			}

			public void onResults(AIResult results) {
				if (results.getResultType() == AIConstant.AIENGINE_MESSAGE_TYPE_JSON) {
					JSONResultParser parser = new JSONResultParser((String) results.getResultObject());
					String[] recs = parser.getNBestRec();
					if (recs != null && recs.length > 0) {
						StringBuffer sb = new StringBuffer();
						for (String s : recs) {
							sb.append(s + "\n");
						}
						textResult.setText(sb.toString());
					}
				}
			}

			@Override
			public void onInit(int status) {
				if (status == AIConstant.OPT_SUCCESS) {
					textResult.setText("初始化成功!请点击【开始说话】");
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

	@Override
	protected void onDestroy() {
		if (mAIRecognizerDialog != null) {
			mAIRecognizerDialog.release();
		}
		super.onDestroy();
	}

}
