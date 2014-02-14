package com.pamakids.weather.dhelp
{
	import com.greensock.TweenLite;
	import com.pamakids.utils.ColorUtils;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.minterface.IDhelp;
	
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class HelpFly extends Sprite implements IDhelp
	{
		private var resTextures : AssetManager;
		private var aroof : MovieClip;
		private var chimney : Image;
		private var mainHouse : Image;
		private var broof : MovieClip;
		private var roof : Image;
		private var _juggler : Juggler = new Juggler();
		
		private var offX : Number = 369;
		private var offY : Number = 308;
		private var defaultX : Number = 0;
		private var defaultY : Number = 0;
		
		private var leftHand : Image;
		private var rightHand : Image;
		
		private var flyBg : Image;
		
		private var isPlaying : Boolean = false;
		public function HelpFly(posx : Number = 400,posy : Number = 300 )
		{
			defaultX = posx;
			defaultY = posy;
			resTextures = AssetManager.getInstance();
			
			
			flyBg = new Image(resTextures.getTexture("hbg"));
			addChild(flyBg);
			flyBg.touchable = false;
			flyBg.x = UICoordinatesFactory.getNewPosX(204 - offX + defaultX);
			flyBg.y = UICoordinatesFactory.getNewPosY(165 - offY + defaultY);
			
			aroof = new MovieClip(resTextures.getTextures("aroof"),6);
			addChild(aroof);
			setDefaultColor(aroof);
			aroof.touchable = false;
			aroof.pause();
			aroof.loop = false;
			aroof.x = UICoordinatesFactory.getNewPosX(439 - offX + defaultX);
			aroof.y = UICoordinatesFactory.getNewPosY(289 - offY + defaultY);
			aroof.changePlayMode(0);
			
			
			chimney = new Image(resTextures.getTexture("chimney"));
			addChild(chimney);
			setDefaultColor(chimney);
			chimney.touchable = false;
			chimney.x = UICoordinatesFactory.getNewPosX(521 - offX + defaultX);
			chimney.y = UICoordinatesFactory.getNewPosY(273 - offY + defaultY);
			
			
			mainHouse = new Image(resTextures.getTexture("house"));
			addChild(mainHouse);
			setDefaultColor(mainHouse);
			mainHouse.x = UICoordinatesFactory.getNewPosX(369 - offX + defaultX);
			mainHouse.y = UICoordinatesFactory.getNewPosY(308 - offY + defaultY);
			
			broof = new MovieClip(resTextures.getTextures("broof"),6);
			addChild(broof);
			setDefaultColor(broof);
			broof.touchable = false;
			broof.pause();
			broof.loop = false;
			broof.x = UICoordinatesFactory.getNewPosX(331 - offX + defaultX);
			broof.y = UICoordinatesFactory.getNewPosY(289 - offY + defaultY);
			broof.changePlayMode(0);
			
			
			roof = new Image(resTextures.getTexture("roof"));
			addChild(roof);
			setDefaultColor(roof);
			roof.touchable = false;
			roof.x = UICoordinatesFactory.getNewPosX(535 - offX + defaultX);
			roof.y = UICoordinatesFactory.getNewPosY(304 - offY + defaultY);
			
			changeToDefaultColor(aroof,1);
			changeToDefaultColor(chimney,1);
			changeToDefaultColor(mainHouse,1);
			changeToDefaultColor(broof,1);
			changeToDefaultColor(roof, 1);
			
			leftHand = new Image(AssetManager.getInstance().getTexture("lefthand"));
			addChild(leftHand);
			leftHand.touchable = false;
			leftHand.scaleX = -1;
			leftHand.pivotX = 0;
			leftHand.pivotY = 0;
			
			rightHand = new Image(AssetManager.getInstance().getTexture("lefthand"));
			addChild(rightHand);
			rightHand.touchable = false;
			rightHand.pivotX = 0;
			rightHand.pivotY = 0;
			
			initData();
		}
		
		private function initData():void {
			leftHand.visible = true;
			rightHand.visible = true;
			leftHand.x = UICoordinatesFactory.getNewPosX(120 + defaultX);
			leftHand.y = UICoordinatesFactory.getNewPosY(20 + defaultY);
			rightHand.x = UICoordinatesFactory.getNewPosX(150 + defaultX);
			rightHand.y = UICoordinatesFactory.getNewPosY(20 + defaultY);
		}
		
		public function play():void
		{
			TweenLite.to(leftHand, 1, { x : UICoordinatesFactory.getNewPosX(70 + defaultX),onComplete : tweenCom} );
			TweenLite.to(rightHand, 1, { x : UICoordinatesFactory.getNewPosX(200 + defaultX)} );
			
		}
		
		private function tweenCom():void 
		{
			runHappyTime();
		}
		
		public function stop():void
		{
			TweenLite.killDelayedCallsTo(runHappyTime);
			TweenLite.killDelayedCallsTo(rePlay);
			TweenLite.killDelayedCallsTo(closeHouse);
			_juggler.remove(aroof);
			_juggler.remove(broof);
			aroof.changePlayMode(0);
			broof.changePlayMode(0);
			aroof.currentFrame = 0;
			broof.currentFrame = 0;
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			aroof.removeEventListener(Event.COMPLETE, onARoofComHandler);
			isPlaying = false;
			
			initData();
		}
		
		public function destroy():void
		{
			
		}
		
		private function onARoofComHandler(e:Event):void 
		{
			_juggler.remove(aroof);
			_juggler.remove(broof);
			aroof.removeEventListener(Event.COMPLETE, onARoofComHandler);
			
			TweenLite.delayedCall(1,closeHouse);
		}
		
		private function closeHouse():void {
			aroof.changePlayMode(1);
			broof.changePlayMode(1);
			aroof.play();
			broof.play();
			_juggler.add(aroof);
			_juggler.add(broof);
			
			aroof.addEventListener(Event.COMPLETE, onCloseHouseOver);
		}
		
		private function onCloseHouseOver(e:Event):void 
		{
			_juggler.remove(aroof);
			_juggler.remove(broof);
			aroof.removeEventListener(Event.COMPLETE, onCloseHouseOver);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			
			TweenLite.delayedCall(1,rePlay);
		}
		
		private function rePlay():void 
		{
			stop();
			play();
		}
		
		private function runHappyTime():void {
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			aroof.changePlayMode(0);
			broof.changePlayMode(0);
			aroof.play();
			broof.play();
			if (aroof.hasEventListener(Event.COMPLETE)) {
				
			}else{
				aroof.addEventListener(Event.COMPLETE, onARoofComHandler);
			}
			_juggler.add(aroof);
			_juggler.add(broof);
		}
		
		private function onEnterFrameHandler(e:Event):void 
		{
			_juggler.advanceTime(0.05);
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