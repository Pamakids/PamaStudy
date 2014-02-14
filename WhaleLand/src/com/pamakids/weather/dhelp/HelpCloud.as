package com.pamakids.weather.dhelp
{
	import com.greensock.TweenLite;
	import com.pamakids.utils.CenterPivot;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.minterface.IDhelp;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class HelpCloud extends Sprite implements IDhelp
	{
		private var smallCloudTexture : Texture;
		private var bigCloudTexture : Texture;
		
		private var firstCloud : Image;
		private var secondCloud : Image;
		
		private var cloudW : int = 0;
		
		private var leftHand : Image;
		private var rightHand : Image;
		
		private var defaultX : Number = 0;
		private var defaultY : Number = 0;
		public function HelpCloud(posx : Number = 312,posy : Number = 100)
		{
			smallCloudTexture = AssetManager.getInstance().getTexture("cloudnew001");
			bigCloudTexture = AssetManager.getInstance().getTexture("cloud001");
			
			firstCloud = new Image(smallCloudTexture);
			secondCloud = new Image(smallCloudTexture);
			addChild(firstCloud);
			addChild(secondCloud);
			
			cloudW = smallCloudTexture.width;
			CenterPivot.center(firstCloud);
			CenterPivot.center(secondCloud);
			
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
			
			defaultX = posx;
			defaultY = posy;
			
			initData();
		}
		
		private function setTexture():void {
			firstCloud.texture = smallCloudTexture;
			secondCloud.texture = smallCloudTexture;
		}
		private function initData():void {
			firstCloud.visible = true;
			firstCloud.x = UICoordinatesFactory.getNewPosX(100 + defaultX);
			firstCloud.y = UICoordinatesFactory.getNewPosY(200 + defaultY);
			secondCloud.visible = true;
			secondCloud.touchable = true;
			firstCloud.touchable = true;
			firstCloud.data.hasTouch = false;
			secondCloud.data.hasTouch = false;
			
			secondCloud.x = UICoordinatesFactory.getNewPosX(300 + defaultX);
			secondCloud.y = UICoordinatesFactory.getNewPosY(200 + defaultY);
			
			leftHand.visible = true;
			rightHand.visible = true;
			leftHand.x = UICoordinatesFactory.getNewPosX(100 + defaultX);
			leftHand.y = UICoordinatesFactory.getNewPosY(200 + defaultY);
			rightHand.x = UICoordinatesFactory.getNewPosX(300 + defaultX);
			rightHand.y = UICoordinatesFactory.getNewPosY(200 + defaultY);
		}
		
		public function play():void
		{
			
			TweenLite.to(leftHand,1,{x : UICoordinatesFactory.getNewPosX(170 + defaultX),onComplete : tweenCom});
			TweenLite.to(rightHand, 1, { x : UICoordinatesFactory.getNewPosX(220 + defaultX) } );
			
			TweenLite.to(firstCloud, 1, { x : UICoordinatesFactory.getNewPosX(170 + defaultX) ,onComplete : tweenCom} );
			TweenLite.to(secondCloud, 1, { x : UICoordinatesFactory.getNewPosX(220 + defaultX) } );
		}
		
		private function tweenCom():void 
		{
			firstCloud.texture = bigCloudTexture;
			secondCloud.visible = false;
			
			leftHand.visible = false;
			rightHand.visible = false;
			
			TweenLite.delayedCall(2,rePlay);
		}
		
		private function rePlay():void 
		{
			stop();
			play();
		}
		
		public function stop():void
		{
			
			setTexture();
			initData();
			TweenLite.killTweensOf(leftHand);
			TweenLite.killTweensOf(rightHand);
			TweenLite.killTweensOf(firstCloud);
			TweenLite.killTweensOf(secondCloud);
			TweenLite.killDelayedCallsTo(rePlay);
		}
		
		public function destroy():void
		{
			
		}
	}
}