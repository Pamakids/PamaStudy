package com.pamakids.weather.plugins
{
	import com.gslib.net.hires.debug.Stats;
	import com.pamakids.core.IPlugin;
	import com.pamakids.core.msgs.DelAllMsg;
	import com.pamakids.core.msgs.LoadMarineMsg;
	import com.pamakids.core.msgs.WorldEndMsg;
	import com.pamakids.core.msgs.WorldPeaceMsg;
	import com.pamakids.core.PluginsID;
	import com.pamakids.core.msgs.CreatNewCloudMsg;
	import com.pamakids.core.msgs.DayMsg;
	import com.pamakids.core.msgs.MsgBase;
	import com.pamakids.core.msgs.NightMsg;
	import com.pamakids.core.msgs.PlayFishMsg;
	import com.pamakids.core.msgs.StartMoonMsg;
	import com.pamakids.core.msgs.StartSunMsg;
	import com.pamakids.uimanager.UIGlobal;
	import com.pamakids.uimanager.UIManager;
	import com.pamakids.weather.items.Fishs;
	import com.pamakids.weather.items.MarineLayer;
	import com.pamakids.weather.model.GameData;
	
	import flash.geom.Point;
	
	public class MarinePlugin implements IPlugin
	{
		private var fishs : Fishs;
		private var marineLayer : MarineLayer;
		
		private var isActive : Boolean = true;
		public function MarinePlugin()
		{
			
		}
		
		public function Init():void
		{
			trace("海洋插件初始化 : " + Stats.tFps);
			marineLayer = new MarineLayer();
			UIManager.AddUiToLayer(marineLayer, UIGlobal.BACKGROUND0_LAYER);
			
			fishs = new Fishs();
			UIManager.AddUiToLayer(fishs, UIGlobal.BACKGROUND3_LAYER);
		}
		
		public function Release():void
		{
			
		}
		
		public function ReStart():void {
			fishs.reSart();
			marineLayer.reStart();
			isActive = true;
		}
		
		public function Update():void
		{
			if(isActive){
				fishs.update(null);
				marineLayer.update(null);
			}
		}
		
		public function GetVersion():Number
		{
			return 0;
		}
		

		
		public function GetID():int
		{
			return PluginsID.MARINE_PLUGIN;
		}
		
		public function OnBroadcastMsg(msg:MsgBase):void
		{
			
			if (msg is LoadMarineMsg) {
				marineLayer.init();
				fishs.init();
			}
			
			
			if (msg is WorldEndMsg) {
				isActive = false;
				if (marineLayer.isLightOn) {
					
				}else {
					marineLayer.clickTheLightTower();
				}
			}
			
			if (msg is WorldPeaceMsg) {
				isActive = true;
				marineLayer.clickTheLightTower();
			}
			
			
			if (msg is CreatNewCloudMsg) {
				var data : Object = CreatNewCloudMsg(msg).data;
				if(GameData.snowState == 0 && GameData.isSnowing == false && GameData.cloudsM < 10){
					marineLayer.creatWaterVapor(data);
				}
			}
			
			if (msg is PlayFishMsg) {
				var posX : Number = PlayFishMsg(msg).posX;
				var posY : Number = PlayFishMsg(msg).posY;
				fishs.creatdFish(new Point(posX,posY));
			}
			
			if (msg is StartMoonMsg) {
				marineLayer.updateDayState(1);
			}
			
			if (msg is StartSunMsg) {
				marineLayer.updateDayState(0);
			}
			
			if (msg is DayMsg) {
				if (GameData.dayState != 0) {
					marineLayer.updateDayState(0);
				}
			}
			
			if (msg is NightMsg) {
				if (GameData.dayState != 1) {
					marineLayer.updateDayState(1);
				}
			}
			
			//释放所有内存
			if (msg is DelAllMsg) {
				//fishs.destroy();
				//fishs.removeChildren();
				fishs.reset();
				//marineLayer.destroy();
				//marineLayer.removeChildren();
				marineLayer.reset();
			}
			
		}
	}
}