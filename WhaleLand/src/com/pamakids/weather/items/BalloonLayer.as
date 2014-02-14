package com.pamakids.weather.items
{
	import com.pamakids.core.PluginControl;
	import com.pamakids.core.msgs.EarthquakeMsg;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	
	import flash.utils.getTimer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class BalloonLayer extends Sprite
	{
		public var isActive : Boolean = false;
		public var balloonList : Array = [];
		
		private var oldTime : uint = 0;
		private var interTime : uint = 0;
		
		private var endCount : int = 0;
		
		private var msg : EarthquakeMsg = new EarthquakeMsg();
		
		private var balloonTexture : Texture;
		
		private var ballPoolList : Array = [];
		
		private var totalTime : uint = 0;
		public function BalloonLayer()
		{
			super();
			setBalloonTexture();
		}
		
		private function setBalloonTexture():void {
			balloonTexture = AssetManager.getInstance().getTexture("ball");
		}
		
		public function start():void {
			trace("气球启动~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
			isActive = true;
			msg.data = 0;
			msg.oldTime = getTimer();
			oldTime = getTimer();
			totalTime = 0;
		}
		
		public function reset():void {
			stop();
		}
		
		public function stop():void {
			isActive = false;
			while (balloonList.length > 0) {	
				var tballoon : Image = balloonList.shift();
				tballoon.visible = false;
				ballPoolList.push(tballoon);
			}
			msg.data = 0;
			
		}
		
		public function destroy():void {
			for (var i : int = 0; i < balloonList.length;i ++ ) {
				if (balloonList[i]) {
					removeChild(balloonList[i],true);
				}
			}
			removeEventListeners();
			removeChildren();
		}
		
		public function creatBalloon(value : int):void {
			for (var i : int = 0; i < value;i ++ ) {
				var balloon : Image;
				if(ballPoolList.length > 0){
					balloon = ballPoolList.shift();
				}else {
					balloon = new Image(balloonTexture);
				}
				balloon.pivotX = balloon.width * 0.5;
				balloon.pivotY = balloon.height;
				balloon.color = Math.random() * 0xFFFFFF;
				balloon.data.oldTime = getTimer();
				balloon.touchable = false;
				balloon.data.vy = (Math.random() * 1 + 1) * Screen.ratio;
				balloon.x = UICoordinatesFactory.getNewPosX(400 + Math.random() * 200);
				balloon.y = 450 * Screen.ratio;
				addChild(balloon);
				balloon.visible = true;
				balloonList.push(balloon);
			}
		}
		
		public function update():void {
			if (isActive) {
				endCount = 0;
				//trace("气球飞起来啊 : " + balloonList.length);
				for (var i : int = 0; i < balloonList.length;i ++ ) {
					if (getTimer() - balloonList[i].data.oldTime >= 1200) {
						endCount ++
					}else {
						balloonList[i].y -= balloonList[i].data.vy;
					}
				}
				
				var passTime : int = getTimer() - oldTime;
				interTime += passTime;
				if (interTime >= 350) {
					
					creatBalloon(2);
					trace("balloonList.length : " + balloonList.length);
/*					if (balloonList.length < 100) {
						if (balloonList.length >= 90) {
							msg.data ++;
							msg.curTime = getTimer();
							PluginControl.BroadcastMsg(msg);
						}
						creatBalloon(2);
					}else {
						//
					}
					*/
					totalTime += interTime;
					interTime = 0;
					
									
					if(totalTime >= 16000){
						msg.data ++;
						msg.curTime = getTimer();
						PluginControl.BroadcastMsg(msg);
					
					}
				}
				

				
				if(totalTime >= 18000){
					isActive = false;
				}
				
				
/*				if (endCount >= 100 && endCount == balloonList.length) {
					isActive = false;
				}*/
			}
			oldTime = getTimer();
		}
	}
}