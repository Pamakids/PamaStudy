package com.iflytek.voicedemo;

import android.app.Activity;
import android.app.Dialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

public class MainActivity extends Activity implements OnClickListener{
	private Toast mToast;
//	private Handler mHandler;
	private Dialog mLoadDialog;
	
	public void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		// 设置标题栏（无标题）
		this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		setContentView(R.layout.main);
		
		SimpleAdapter listitemAdapter = new SimpleAdapter();		
        ((ListView)findViewById(R.id.listview_main)).setAdapter(listitemAdapter);
//        mHandler=new Myhandler();
	}
	@Override
	public void onClick(View view) {
		if(view.getTag() == null)
		{
			showTip("未知错误");
			return;
		}

		// 设置你申请的应用appid
//		SpeechUtility.getUtility(MainActivity.this).setAppid("appid=52b7d6b1");
		int tag = Integer.parseInt(view.getTag().toString());
		Intent intent = null;
		if(tag == 0)
		{
			intent = new Intent(this, AbnfDemoAnimation.class);
		}else if(tag == 1)
		{
			intent = new Intent(this, AbnfDemo.class);
		}
        else if(tag == 2)
        {
            intent = new Intent(this, AbnfDemoVoice.class);
        }

		startActivity(intent);		
	}
	
	private class SimpleAdapter extends BaseAdapter{

	   	  public SimpleAdapter() 
	   	  {
	   	       super();
	   	  }
	   	  public View getView(int position, View convertView, ViewGroup parent) 
	   	  {	   		  
	   		  if(null == convertView){
	   			  LayoutInflater factory = LayoutInflater.from(MainActivity.this);
	  			  View mView = factory.inflate(R.layout.list_items, null);
	  			  convertView = mView;
	   		  }
	   		  Button btn = (Button)convertView.findViewById(R.id.btn);
	   		  btn.setOnClickListener(MainActivity.this);
	   		  btn.setTag(position);
	   		  
	   		  if(position == 0)
	   		  {
	   			btn.setText("STOP&GO动作识别");
	   		  }else if(position == 1)
	   		  {
	   			btn.setText("自定义单词识别");
	   		  }
              else if(position == 2)
              {
                  btn.setText("GoodBye&&How 语音识别");
              }
	   		  return convertView;
	   	  }

	   	@Override
		public int getCount() {
  	  		return 3;
		}
  	  	
  	  	@Override
		public Object getItem(int position) {
			return null;
		}
	
		@Override
		public long getItemId(int position) {
			return 0;
		}
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
	/**
	 * 如果服务组件没有安装，有两种安装方式。
	 * 1.直接打开语音服务组件下载页面，进行下载后安装。
	 * 2.把服务组件apk安装包放在assets中，为了避免被编译压缩，修改后缀名为mp3，然后copy到SDcard中进行安装。
	 */
//	private boolean processInstall(Context context ,String url,String assetsApk){
//		// 直接下载方式
////		ApkInstaller.openDownloadWeb(context, url);
//		// 本地安装方式
//		if(!ApkInstaller.installFromAssets(context, assetsApk)){
//		    Toast.makeText(MainActivity.this, "安装失败", Toast.LENGTH_SHORT).show();
//		    return false;
//		}
//		return true;
//	}
//	 class Myhandler extends Handler{
//		@Override
//		public void handleMessage(Message msg) {
//			switch (msg.what) {
//			case 0:
//				String url = SpeechUtility.getUtility(MainActivity.this).getComponentUrl();
//				String assetsApk="SpeechService.apk";
//				if(processInstall(MainActivity.this, url,assetsApk)){
//					Message message=new Message();
//					message.what=1;
//					mHandler.sendMessage(message);
//				}
//				break;
//			case 1:
//				if(mLoadDialog!=null){
//					mLoadDialog.dismiss();
//				}
//				break;
//			default:
//				break;
//			}
//			super.handleMessage(msg);
//		}
//
//	 }
}
