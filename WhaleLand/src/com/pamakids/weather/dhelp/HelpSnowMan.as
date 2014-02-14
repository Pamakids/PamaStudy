package com.pamakids.weather.dhelp
{
	import com.greensock.TweenLite;
	import com.pamakids.core.msgs.TouchMsg;
	import com.pamakids.core.PluginControl;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.minterface.IDhelp;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class HelpSnowMan extends Sprite implements IDhelp
	{
		private var snowMan : Sprite;
		private var snowManHead : Image;
		private var snowManBody : Image;
		
		private var snowManFace : Image;
		private var snowManHand : Image;
		private var snowManCollar : Image;
		private var resTextures : AssetManager;
		
		private var rightHand : Image;
		
		private var touchMsg : TouchMsg = new TouchMsg();
		
		private var offX : Number = 0;
		private var offY : Number = 0;
		private var defaultX : Number;
		private var defaultY : Number;
		public function HelpSnowMan(posx : Number = 400,posy : Number = 300)
		{
			
			defaultX = posx;
			defaultY = posy;
			resTextures = AssetManager.getInstance();
			snowMan = new Sprite();
			this.addChild(snowMan);
			snowManHead = new Image(resTextures.getTexture("snowman002"));
			snowManBody = new Image(resTextures.getTexture("snowman001"));
			snowMan.addChild(snowManBody);
			snowMan.addChild(snowManHead)
			
			snowMan.x = UICoordinatesFactory.getNewPosX(defaultX);
			snowMan.y = UICoordinatesFactory.getNewPosY(defaultY);
			snowMan.touchable = false;
			//snowMan.addEventListener(TouchEvent.TOUCH,onTouchSnowMan);
			
			snowManHead.scaleX = snowManHead.scaleY = 0.3;
			snowManBody.scaleX = snowManBody.scaleY = 0.3;
			
			rightHand = new Image(AssetManager.getInstance().getTexture("lefthand"));
			addChild(rightHand);
			rightHand.pivotX = 0;
			rightHand.pivotY = 0;
			rightHand.touchable = false;
			resetPos();
			
		}
		
		private function resetPos():void {
			rightHand.visible = true;
			rightHand.x = UICoordinatesFactory.getNewPosX(185 + defaultX);
			rightHand.y = UICoordinatesFactory.getNewPosY(84 + defaultY);
		}
		
		public function play():void
		{
			TweenLite.to(rightHand,2,{x : UICoordinatesFactory.getNewPosX(85 + defaultX),y : UICoordinatesFactory.getNewPosY(34 + defaultY),onComplete : hideHand});
		}
		
		private function hideHand():void 
		{
			rightHand.visible = false;
			creatNewSnowMan();
			TweenLite.delayedCall(2,rePlay);
		}
		
		
		public function stop():void
		{
			TweenLite.killDelayedCallsTo(creatNewSnowMan);
			TweenLite.killDelayedCallsTo(rePlay);
			TweenLite.killTweensOf(rightHand);
			
			if (snowManFace) {
				snowManFace.visible = false;
			}
			
			if (snowManHand) {
				snowManHand.visible = false;
			}
			
			if (snowManCollar) {
				snowManCollar.visible = false;
			}
			
			resetPos();
		}
		
		public function destroy():void
		{
			
		}
		
		private function creatNewSnowMan():void 
		{
			
			if (snowManFace) {
				snowManFace.visible = true;
			}else {
				snowManFace = new Image(resTextures.getTexture("zhuangbanlian001"));
				snowManFace.x = 226*0.3*Screen.ratio;
				snowManFace.y = UICoordinatesFactory.getNewPosY(140 * 0.3);
				snowManFace.scaleX = snowManFace.scaleY = 0.3;
				snowMan.addChild(snowManFace);
			}
			
			if (snowManHand) {
				snowManHand.visible = true;
			}else {
				snowManHand = new Image(resTextures.getTexture("zhuangbanshou001"));
				snowManHand.x = 0*0.3*Screen.ratio;
				snowManHand.y = UICoordinatesFactory.getNewPosY(56 * 0.3);
				snowManHand.scaleX = snowManHand.scaleY = 0.3;
				snowMan.addChild(snowManHand);
			}
			
			if (snowManCollar) {
				snowManCollar.visible = true;
			}else {
				snowManCollar = new Image(resTextures.getTexture("zhuangbantou001"));
				snowManCollar.x = 87*0.3*Screen.ratio;
				snowManCollar.y = UICoordinatesFactory.getNewPosY(6 * 0.3);
				snowManCollar.scaleX = snowManCollar.scaleY = 0.3;
				snowMan.addChild(snowManCollar);	
			}
			
			
		}
		
		private function rePlay():void 
		{
			
			stop();
			play();
		}
	}
}