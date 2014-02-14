package com.pamakids.weather.items
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.pamakids.uimanager.UIBase;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class TipItem extends UIBase
	{
		private var medalTip : Image;
		private var arrow : Image;
		private var arrowY : int = 485;
		public function TipItem()
		{
			super();
		}
		
		public function init():void {
			
			setTexture();
			
			arrowY *= Screen.ratio;
			
			medalTip = new Image(medalTipTexture);
			addChild(medalTip);
			medalTip.pivotX = medalTip.width * 0.5;
			medalTip.pivotY = medalTip.height * 0.5;
			medalTip.touchable = false;
			medalTip.x = UICoordinatesFactory.getNewPosX(820) + medalTip.width * 0.5;
			medalTip.y = medalTip.height * 0.5 * Screen.ratio;
			medalTip.visible = false;
			
			arrow = new Image(arrowTexture);
			addChild(arrow);
			arrow.touchable = false;
			arrow.pivotX = arrow.width * 0.5;
			arrow.pivotY = arrow.height;
			arrow.scaleX = arrow.scaleY = 0.7;
			arrow.visible = false;
			arrow.x = UICoordinatesFactory.getNewPosX(145);
			arrow.y = arrowY;
		}
		
		
		public function reset():void {
			medalTip.visible = false;
			arrow.visible = false;
			TweenLite.killTweensOf(medalTip);
			TweenLite.killTweensOf(arrow);
			TweenLite.killDelayedCallsTo(startMedal);
		}
		
		public function showArrow():void {
			arrow.visible = true;
			arrow.x = UICoordinatesFactory.getNewPosX(145);
			arrow.y = arrowY;
			TweenLite.to(arrow,0.5,{y : UICoordinatesFactory.getNewPosY(475),onComplete : resetArrow,onCompleteParams : [0]});
		}
		
		private var medalTipTexture : Texture;
		private var arrowTexture : Texture;
		private function setTexture():void {
			medalTipTexture = AssetManager.getInstance().getTexture("badges");
			arrowTexture = AssetManager.getInstance().getTexture("arrow");
		}
		
		private function resetArrow(value : int):void 
		{
			if (value == 0) {
				TweenLite.to(arrow,0.5,{y : arrowY,onComplete : resetArrow,onCompleteParams : [1]});
			}else if (value == 1) {
				TweenLite.to(arrow,0.5,{y : UICoordinatesFactory.getNewPosY(475),onComplete : resetArrow,onCompleteParams : [0]});
			}
		}
		
		public function hideArrow():void {
			arrow.visible = false;
		}
		
		
		public function showMedal():void {
			trace("点亮图标");
			
			TweenLite.killDelayedCallsTo(startMedal);
			TweenLite.delayedCall(1,startMedal);
		}
		
		private function startMedal():void 
		{
			medalTip.visible = true;
			medalTip.alpha = 0;
			medalTip.y = medalTip.height * 0.5;
			medalTip.scaleX = medalTip.scaleY = 1.3;
			TweenLite.killTweensOf(medalTip);
			TweenLite.killDelayedCallsTo(beginHide);
			TweenLite.to(medalTip,1,{alpha:1,scaleX : 1,scaleY : 1,ease:Bounce.easeOut,onComplete:hideMedalHandler});
		}
		
		private function hideMedalHandler():void 
		{
			TweenLite.delayedCall(1,beginHide);
		}
		
		private function beginHide():void {
			TweenLite.to(medalTip,0.5,{alpha : 0,y : -100 * Screen.ratio});
		}
		
		public function update():void {
			
		}
		
		public function destroy():void {
			
		}
	}
}