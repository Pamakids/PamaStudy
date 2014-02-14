package com.pamakids.weather.items
{
	import as3logger.Logger;
	
	import com.greensock.TweenLite;
	import com.pamakids.uimanager.UIBase;
	import com.pamakids.utils.ColorUtils;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class FlyWhales extends Sprite
	{
		private var whales : Image;
		private var leftEyes : MovieClip;
		private var rightEyes : MovieClip;
		
		private var tice : Image;
		
		private var count : int = 0;
		
		private var _juggler : Juggler = new Juggler();
		public function FlyWhales()
		{
			super();
		}
		
		public function init():void {
			
			if (whales) {
				whales.visible = true;
				leftEyes.visible = true;
				rightEyes.visible = true;
			}else {
				
				setTexture();
				
				whales = new Image(whalesTexture);
				whales.touchable = false;
				addChild(whales);
				
				leftEyes = new MovieClip(leftEyesTexture,8);
				leftEyes.loop = true;
				leftEyes.touchable = false;
				addChild(leftEyes);
				leftEyes.addEventListener(Event.COMPLETE,onMovieCompleteHandler);
				
				rightEyes = new MovieClip(rightEyesTexture,8);
				rightEyes.touchable = false;
				rightEyes.loop = false;
				rightEyes.addEventListener(Event.COMPLETE,onRightMovieCom);
				addChild(rightEyes);
			}
			
			initData();
			
			count = 0;
		}
		
		public function reset():void {
			leftEyes.currentFrame = 0;
			rightEyes.currentFrame = 0;
			leftEyes.removeEventListener(Event.COMPLETE, onMovieCompleteHandler);
			rightEyes.removeEventListener(Event.COMPLETE,onRightMovieCom);
			count = 0;
			
			this.visible = false;
			
			if (this.hasEventListener(Event.ENTER_FRAME)) {
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			}
		}
		
		private function initData():void {
			whales.x = UICoordinatesFactory.getNewPosX(-42);
			whales.y = UICoordinatesFactory.getNewPosY(408);
			leftEyes.x = UICoordinatesFactory.getNewPosX(150);
			leftEyes.y = UICoordinatesFactory.getNewPosY(715);
			rightEyes.x = UICoordinatesFactory.getNewPosX(540);
			rightEyes.y = UICoordinatesFactory.getNewPosY(723);
		}
		
		private var whalesTexture : Texture;
		private var leftEyesTexture : Vector.<Texture>;
		private var rightEyesTexture : Vector.<Texture>;
		private function setTexture():void {
			whalesTexture = AssetManager.getInstance().getTexture("whales");
			leftEyesTexture = AssetManager.getInstance().getTextures("jingyuyanl");
			rightEyesTexture = AssetManager.getInstance().getTextures("jingyuyanb");
		}
		
		private function onRightMovieCom(e:Event):void 
		{
			rightEyes.pause();
		}
		
		private function onMovieCompleteHandler(e:Event):void 
		{
			count ++;
			trace("鲸鱼眨眼睛了 : " + count);
			if (count >= 2) {
				trace("播放两次了啊");
				_juggler.remove(leftEyes);
				_juggler.remove(rightEyes);
				count = 0;
				leftEyes.currentFrame = 0;
				rightEyes.currentFrame = 0;
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			}else {
				trace("眨眼睛");
				leftEyes.currentFrame = 0;
				rightEyes.currentFrame = 0;
			}
		}
		
		public function destroy():void {
			
			if (whales) {
				removeChild(whales,true);
			}
			
			removeEventListeners();
			removeChildren();
		}
		
		public function startBlink():void {
			trace("鲸鱼开始眨眼睛");
			
			leftEyes.currentFrame = 0;
			rightEyes.currentFrame = 0;
			
			this.addEventListener(Event.ENTER_FRAME,onEnterFrameHandler);
			
			_juggler.add(leftEyes);
			_juggler.add(rightEyes);
			leftEyes.play();
			rightEyes.play();
		}
		
		private function onEnterFrameHandler(e:Event):void 
		{
			_juggler.advanceTime(0.03);
		}
		
		//记录默认颜色
		private function setDefaultColor(obj : Image):void {
			obj.data.defaultColor = obj.color;
		}
		
		//设置颜色
		//@mode 0 : 恢复默认颜色 1 : 生成新的颜色
		private function changeToDefaultColor(obj : Image, mode : int = 0):void {
			if (mode == 0) {
				obj.color = obj.data.defaultColor;
			}else if (mode == 1) {
				obj.color = ColorUtils.getNewColor(obj.data.defaultColor,ColorUtils.islandColorTrans);
			}
		}
	}
}