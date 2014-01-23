/*******************************************************************************
 * Copyright 2013 aispeech
 ******************************************************************************/
package com.aispeech.sample;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleAdapter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class Main extends Activity implements AdapterView.OnItemClickListener {
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        ListView listView = (ListView) findViewById(R.id.activity_list);
        ArrayList<HashMap<String, Object>> listItems = new ArrayList<HashMap<String, Object>>();

        HashMap<String, Object> item = new HashMap<String, Object>();

        item = new HashMap<String, Object>();
        item.put("activity_name", "云端语音识别");
        item.put("activity_class", CloudASR.class);
        listItems.add(item);
        
        item = new HashMap<String, Object>();
        item.put("activity_name", "云端语音识别-实时输出结果");
        item.put("activity_class", CloudASRMultiResult.class);
        listItems.add(item);

        item = new HashMap<String, Object>();
        item.put("activity_name", "云端语音合成");
        item.put("activity_class", CloudTTS.class);
        listItems.add(item);
        
        item = new HashMap<String, Object>();
        item.put("activity_name", "云端语音识别-弹出框UI");
        item.put("activity_class", CloudASRUI.class);
        listItems.add(item);

        item = new HashMap<String, Object>();
        item.put("activity_name", "(服务)本地语音识别");
        item.put("activity_class", LocalASRService.class);
        listItems.add(item);

        item = new HashMap<String, Object>();
        item.put("activity_name", "(服务)本地语音唤醒");
        item.put("activity_class", LocalWakeUpService.class);
        listItems.add(item);
        
        item = new HashMap<String, Object>();
        item.put("activity_name", "(服务)本地合成");
        item.put("activity_class", LocalTTSService.class);
        listItems.add(item);
 
        SimpleAdapter adapter = new SimpleAdapter(this, listItems, R.layout.list_item,
                new String[]{"activity_name"},
                new int[]{R.id.text_item});

        listView.setAdapter(adapter);
        listView.setDividerHeight(2);

        listView.setOnItemClickListener(this);
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {

        Map<?, ?> map = (HashMap<?, ?>) parent.getAdapter().getItem(position);
        Class<?> clazz = (Class<?>) map.get("activity_class");
        Intent it = new Intent(this, clazz);
        this.startActivity(it);
    }
}
