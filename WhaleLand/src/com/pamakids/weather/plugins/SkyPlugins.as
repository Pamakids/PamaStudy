package com.pamakids.weather.plugins
{
	import com.gslib.net.hires.debug.Stats;
	import com.pamakids.core.IPlugin;
	import com.pamakids.core.msgs.CreatNewCloudMsg;
	import com.pamakids.core.msgs.DayMsg;
	import com.pamakids.core.msgs.DelAllMsg;
	import com.pamakids.core.msgs.LightIconMsg;
	import com.pamakids.core.msgs.LoadMarineMsg;
	import com.pamakids.core.msgs.LoadSkyOtherItem;
	import com.pamakids.core.msgs.NightMsg;
	import com.pamakids.core.msgs.PigHappyMsg;
	import com.pamakids.core.msgs.PigThinkMsg;
	import com.pamakids.core.msgs.SnowEndMsg;
	import com.pamakids.core.msgs.SnowStopMsg;
	import com.pamakids.core.msgs.StartUIMsg;
	import com.pamakids.core.msgs.SunEnergyMsg;
	import com.pamakids.core.msgs.WorldEndMsg;
	import com.pamakids.core.msgs.WorldPeaceMsg;
	import com.pamakids.core.PluginControl;
	import com.pamakids.core.PluginsID;
	import com.pamakids.core.msgs.DarkCloudMsg;
	import com.pamakids.core.msgs.LoadIsLandMsg;
	import com.pamakids.core.msgs.MoonMsg;
	import com.pamakids.core.msgs.MsgBase;
	import com.pamakids.core.msgs.PlayLighting;
	import com.pamakids.core.msgs.SnowMsg;
	import com.pamakids.core.msgs.StartMoonMsg;
	import com.pamakids.core.msgs.StartSunMsg;
	import com.pamakids.core.msgs.SunMsg;
	import com.pamakids.uimanager.UIGlobal;
	import com.pamakids.uimanager.UIManager;
	import com.pamakids.weather.items.CloudItem;
	import com.pamakids.weather.items.LeavesItem;
	import com.pamakids.weather.items.SnowItem;
	import com.pamakids.weather.items.StarItem;
	import com.pamakids.weather.items.SkyItem;
	import com.pamakids.weather.items.SunItem;
	import com.pamakids.weather.items.MoonItem;
	import com.pamakids.weather.items.TipItem;
	import com.pamakids.weather.model.GameData;
	import com.pamakids.weather.model.SoundManager;
	import com.urbansquall.metronome.Ticker;
	import com.urbansquall.metronome.TickerEvent;
	import flash.system.System;
	
	import flash.sampler.*;
	
	public class SkyPlugins implements IPlugin
	{
		private var sun : SunItem;
		private var sky : SkyItem;
		private var moon : MoonItem;
		private var cloud : CloudItem;
		private var snow : SnowItem;
		private var star : StarItem;
		private var leaves : LeavesItem;
		private var allIsOk : Boolean = false;
		private var ticker : Ticker;
		
		
		private var isActive : Boolean = true;
		public function SkyPlugins()
		{
			
		}
		
		public function Init():void
		{
			sky = new SkyItem();
			sun = new SunItem();
			
			//sky.touchable = false;
			sky.callBack = loadSun;
			sky.init();
			
			
			moon = new MoonItem();
			
			
			cloud = new CloudItem();
			cloud.callBack = loadMarine;
			
			snow = new SnowItem();
			snow.init();
			snow.touchable = false;
			

			
			leaves = new LeavesItem();
			leaves.touchable = false;
			leaves.init();
			UIManager.AddUiToLayer(leaves,UIGlobal.BACKGROUND2_LAYER);
			star = new StarItem();
			star.touchable = false;
			
			

			
			
			UIManager.AddUiToLayer(sky, UIGlobal.BACKGROUND0_LAYER);
			UIManager.AddUiToLayer(sun, UIGlobal.BACKGROUND0_LAYER);
			UIManager.AddUiToLayer(star, UIGlobal.BACKGROUND0_LAYER);
			UIManager.AddUiToLayer(moon, UIGlobal.BACKGROUND0_LAYER);
			UIManager.AddUiToLayer(cloud, UIGlobal.BACKGROUND2_LAYER);
			UIManager.AddUiToLayer(snow, UIGlobal.BACKGROUND2_LAYER);
			
		}
		
		//加载海洋素材
		private function loadMarine():void 
		{
			trace("广播开始加载海洋素材 : " + Stats.tFps);
			PluginControl.BroadcastMsg(new LoadMarineMsg());
		}
		
		private function loadIsland():void 
		{
			trace("云彩加载完了 : " + Stats.tFps);
			//PluginControl.BroadcastMsg(new LoadIsLandMsg());
		}
		
		private function loadCloud():void 
		{
			
		}
		
		private function loadOther():void 
		{	
			
		}
		
		private function onTickHandler(e:TickerEvent):void 
		{
			
		}
		
		private function loadSun():void 
		{
			trace("太阳加载中 : " + Stats.tFps);
			sun.callBack = loadMoon;
			sun.init();
			
		}
		
		private function loadMoon():void 
		{
			moon.init();
			trace("月亮加载完毕了 : " + Stats.tFps);
			cloud.init();
			
		}
		
		public function Release():void
		{
			
		}
		
		public function ReStart():void {
			sun.start();
			star.reStart();
			moon.reStart();
			cloud.reStart();
			snow.reStart();
			leaves.reStart();
			isActive = true;
		}
		
		public function Update():void
		{
			if (isActive) {
				sun.update(null);
				star.update(null);
				moon.update(null);
				cloud.update(null);
				snow.update(null);
				leaves.update(null);
			}	
		}
		
		public function GetVersion():Number
		{
			return 0;
		}
		
		public function GetID():int
		{
			return PluginsID.SKY_PLUGIN;
		}
		
		public function OnBroadcastMsg(msg:MsgBase):void
		{
			
			if (msg is DelAllMsg) {
				//sky.destroy();
				//sky.dispose();
				sky.reset();
				
				star.reset();
				
				//sun.destroy();
				//sun.dispose();
				sun.reset();
				
				//cloud.destroy();
				cloud.reset();
				
				//snow.destroy();
				snow.reset();
				
				//star.destroy();
				
				snow.reset();
				
				moon.reset();
				
				leaves.destroy();
			}
			
			
			if (msg is WorldEndMsg) {
				isActive = false;
			}
			
			if (msg is WorldPeaceMsg) {
				isActive = true;
			}
			
			if(msg is SunMsg){
				//trace("sunMsg : " + (msg as SunMsg).data);
				if((msg as SunMsg).data == sky.index){
				
				}else{
					sky.update((msg as SunMsg).data);
				}
				
				if ((msg as SunMsg).data < 4) {
					moon.moonPosInit();
					star.close();
					PluginControl.BroadcastMsg(new DayMsg());
				}else if ((msg as SunMsg).data == 4) {
					moon.start();
					moon.moonPosInit();
					//trace("太阳又被拖回来了");
				}
				
				if (GameData.curBgMusic == SoundManager.BGM_SUNNYDAY) {
					
				}else {
					SoundManager.getInstance().stopBgMusic(GameData.curBgMusic);
					GameData.curBgMusic = SoundManager.BGM_SUNNYDAY;
					SoundManager.getInstance().playBgMusic(SoundManager.BGM_SUNNYDAY, 1000,SoundManager.getInstance().bgSoundTransform);
				}
			}
			
			if (msg is StartMoonMsg) {
				trace("通知月亮出来!");
				
				SoundManager.getInstance().stopBgMusic(GameData.curBgMusic);
				GameData.curBgMusic = SoundManager.BGM_SUNNYNITE;
				SoundManager.getInstance().playBgMusic(SoundManager.BGM_SUNNYNITE, 1000,SoundManager.getInstance().bgSoundTransform);
				
				moon.start();
				cloud.startNight();
				
				GameData.dayState = 1;
				//如果有乌云的话就不会有星星
				if (GameData.isDarkCloud) {
					
				}else {
					star.init();
				}
			}
			
			if (msg is MoonMsg) {
				if((msg as MoonMsg).data == sky.index){
				
				}else{
					sky.update((msg as MoonMsg).data);
				}
				
				if ((msg as MoonMsg).data < 9 && (msg as MoonMsg).data > 5) {
					sun.resetPos();
					PluginControl.BroadcastMsg(new NightMsg());
				}else if ((msg as MoonMsg).data == 9 ) {
					
				}
				
				if (GameData.curBgMusic == SoundManager.BGM_SUNNYNITE) {
					
				}else {
					SoundManager.getInstance().stopBgMusic(GameData.curBgMusic);
					GameData.curBgMusic = SoundManager.BGM_SUNNYNITE;
					SoundManager.getInstance().playBgMusic(SoundManager.BGM_SUNNYNITE, 1000,SoundManager.getInstance().bgSoundTransform);
				}
				
				trace("moonmsg : " + (msg as MoonMsg).data);
			}
			
			if (msg is StartSunMsg) {
				
				SoundManager.getInstance().stopBgMusic(GameData.curBgMusic);
				GameData.curBgMusic = SoundManager.BGM_SUNNYDAY;
				SoundManager.getInstance().playBgMusic(SoundManager.BGM_SUNNYDAY, 1000,SoundManager.getInstance().bgSoundTransform);
				
				cloud.startDay();
				sun.start();
				star.close();
				GameData.dayState = 0;
			}
			
			if (msg is CreatNewCloudMsg) {
				trace("开始产生云彩了么暗淡倒萨 : " + GameData.snowState + " _ " + GameData.isSnowing);
				var newCloudData : Object = CreatNewCloudMsg(msg).data;
				if (GameData.snowState == 0 && GameData.isSnowing == false) {
					trace("产生云彩");
					cloud.creatNewCloud(newCloudData);
				}
			}
			
			if (msg is DayMsg) {
				//trace("白天云彩！");
				GameData.dayState = 0;
				cloud.startDay();
			}
			
			if (msg is NightMsg) {
				//trace("黑天云彩");
				GameData.dayState = 1;
				cloud.startNight();
			}
			
			if (msg is SunEnergyMsg) {
				if (GameData.snowState == 0) {
					sun.sunShineAction();
				}
			}
			
			
			
			if (msg is SnowEndMsg) {
				trace("skyIndex : " + sky.index);
				if (sky.index < 5) {
					
					//&& GameData.isSnowing == false
					if(GameData.dayState == 0){
						trace("下雪结束了!,太阳可以化雪了");
						sun.sunShineAction();
					}
				}
			}
			
			//
			if (msg is SnowStopMsg) {
				if (sky.index < 5) {
					if(GameData.dayState == 0 && GameData.isSnowing == false){
						trace("下雪结束了!,太阳可以化雪了");
						//sun.sunShineAction();
					}
				}
			}
			
			
			

			
			if (msg is SnowMsg) {
				
				sun.stopSunShineAction();
				//trace("下雪了");				
				if (GameData.dayDesireList[2] == 0) {
					PluginControl.BroadcastMsg(new PigHappyMsg());
				}
				GameData.dayDesireList[2] = 1;
				
				if ((msg as SnowMsg).data == 1) {
					snow.numFlakes = 100;
				}
				
				snow.enabled();
				snow.numFlakes += (msg as SnowMsg).data * 0.5;
				
				cloud.clearAllCloud();
			}
			
			
			
			if (msg is DarkCloudMsg) {
				if ((msg as DarkCloudMsg).data == true) {
					//如果当前是黑夜的话，星星消失
					if (sky.index < 5) {
						
					}else {
						if (star.isActive) {
							star.close();
						}else {
							
						}
					}
				}else {
					//如果是黑夜的话，星星可以显示出来
					if (sky.index < 5) {
						
					}else {
						if (star.isActive) {
							
						}else {
							star.init();
						}
					}
				}
			}
		}
		
	}
}