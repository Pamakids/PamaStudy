package com.pamakids.weather.items
{
	import com.pamakids.core.msgs.SnowStopMsg;
	import com.pamakids.core.PluginControl;
	import com.pamakids.core.msgs.SnowEndMsg;
	import com.pamakids.core.msgs.SnowSateMsg;
	import com.pamakids.effects.weather.Snow;
	import com.pamakids.effects.weather.SnowFlake;
	import com.pamakids.uimanager.UIBase;
	import com.pamakids.utils.dinput.Accel;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.model.GameData;
	import starling.display.QuadBatch;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class SnowItem extends UIBase implements IItem
	{
		public var xV : Number;
		public var yV : Number = 7;
		public var numFlakes : uint = 200;
		public var isStop : Boolean = false;
		public var tNum : int = 0;
		public var canBroadcastMsg : Boolean = true;
		
		private var isActive : Boolean = false;
		private var snowFlakes : Array = []; 
		private var maxNum : int = 400;
		private var oldTime : uint = 0;
		private var isFirst : Boolean = true;
		private var startTime : uint = 0;
		private var snowBmd : SnowTexture;
		private var snowIsEnd : Boolean = false;
		private var shareTexture : Texture;
		
		private var mQuenBatch : QuadBatch;
		public function SnowItem()
		{
			super();
			numFlakes *= Screen.ratio;
			maxNum *= Screen.ratio;
			snowBmd = new SnowTexture();
			shareTexture = Texture.fromBitmapData(snowBmd);
			
			mQuenBatch = new QuadBatch();
			addChild(mQuenBatch);
		}
		
		public function init():void
		{
			this.touchable = false;
		}
		
		public function enabled():void {
			GameData.snowIsEnd = false;
			isActive = true;
			isStop = false;
			if (isFirst) {
				trace("这执行了几次呢!");
				oldTime = getTimer();
				startTime = oldTime;
				isFirst = false;
			}
		}
		
		public function denabled():void{
			isStop = true;	
			isFirst = true;
		}
		
		public function update(data:*):void
		{
			if (isActive) {
				if (canBroadcastMsg) {
					GameData.isSnowing = true;
					if((getTimer() - oldTime) > 32000){
						denabled();
						
					}
					if ((getTimer() - startTime) >= 10000) {
						var index : int = (getTimer() - oldTime) / 10000;
						if(index < 4){
							var msg : SnowSateMsg = new SnowSateMsg();
							msg.data = index;
							//记录雪的状态
							GameData.snowState = index;
							PluginControl.BroadcastMsg(msg);
							startTime = getTimer();
						}else{
							//下雪结束了
							if (snowIsEnd == false) {
								trace("下雪结束了");
								PluginControl.BroadcastMsg(new SnowEndMsg());
								snowIsEnd = true;
								GameData.snowIsEnd = true;
							}
						}
					}
				}
				
				var snowflake : Snow; 
				if (numFlakes >= maxNum) {
					numFlakes = maxNum;
				}
				if(snowFlakes.length < numFlakes)
				{
					snowflake = new Snow(shareTexture);
					snowflake.maxSpeed = yV;
					snowFlakes.push(snowflake);
					//mQuenBatch.addImage(snowflake.img);
					addChild(snowflake.img); 
					snowflake.img.touchable = false;
					
				}
				var wind : Number = -(Accel.incX / 100) * 300;
				var count : int = 0;
				
				if (snowFlakes.length >= maxNum) {
					tNum = numFlakes;
				}else {
					tNum = snowFlakes.length;
				}
				
				for(var i:uint = 0; i< tNum; i++)
				{
					snowflake = snowFlakes[i]; 
					snowflake.img.visible = true;
					snowflake.isStop = isStop;
					snowflake.update(wind); 
					//mQuenBatch.addImage(snowflake.img);
					if (snowflake.isend) {
						count ++;
					}
				}
				if(canBroadcastMsg){
					if (count == snowFlakes.length) {
						isActive = false;
						isFirst = true;
						snowIsEnd = false;
						//向外广播下雪结束了
						GameData.isSnowing = false;
						PluginControl.BroadcastMsg(new SnowStopMsg());
					}
				}
			}
		}
		
		public function reset():void {
			isActive = false;
			for (var i : int = 0; i < snowFlakes.length;i ++) {
				snowFlakes[i].img.visible = false;
				snowFlakes[i].reset();
			}
		}
		
		public function reStart():void {
			
		}
		
		public function destroy():void
		{
			for (var i : int = 0; i < snowFlakes.length;i ++ ) {
				snowFlakes[i].img.dispose();
				removeChild(snowFlakes[i].img);
			}
		}
	}
}