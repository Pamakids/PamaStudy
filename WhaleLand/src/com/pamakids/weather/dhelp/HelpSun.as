package com.pamakids.weather.dhelp
{
	import com.greensock.TweenLite;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.minterface.IDhelp;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class HelpSun extends Sprite implements IDhelp
	{
		private var sunTexture : Texture;
		private var sunEyesTextures  :Vector.<Texture>;
		private var m_sun : Sprite;
		private var sunImg : Image;
		private var sunEyes : MovieClip;
		
		private var leftHand : Image;
		private var rightHand : Image;
		
		private var defaultX : Number;
		private var defaultY : Number;
		public function HelpSun(posx  : Number = 512,posy : Number = 384)
		{
			sunTexture = AssetManager.getInstance().getTexture("sun001");
			sunEyesTextures = AssetManager.getInstance().getTextures("suneyes");
			sunImg = new Image(sunTexture);
			m_sun = new Sprite();
			m_sun.addChild(sunImg);
			sunEyes = new MovieClip(sunEyesTextures,6);
			m_sun.addChild(sunEyes);
			sunEyes.touchable = false;
			addChild(m_sun);
			m_sun.touchable = false;
			//
			sunEyes.x = UICoordinatesFactory.getNewPosY(92);
			sunEyes.y = UICoordinatesFactory.getNewPosY(122);
			m_sun.pivotX = m_sun.width * 0.5;
			m_sun.pivotY = m_sun.height * 0.5;
			
			leftHand = new Image(AssetManager.getInstance().getTexture("lefthand"));
			addChild(leftHand);
			leftHand.scaleX = -1;
			leftHand.pivotX = 0;
			leftHand.pivotY = 0;
			
			
			
			rightHand = new Image(AssetManager.getInstance().getTexture("lefthand"));
			addChild(rightHand);
			rightHand.pivotX = 0;
			rightHand.pivotY = 0;
			
			
			m_sun.x = UICoordinatesFactory.getNewPosX(posx);
			m_sun.y = UICoordinatesFactory.getNewPosY(posy);
			
			
			defaultX = posx;
			defaultY = posy;
			resetPos(defaultX,defaultY);
		}
		private function resetPos(posx : Number,posy : Number):void {
			leftHand.x = UICoordinatesFactory.getNewPosX(posx - 30);
			leftHand.y = UICoordinatesFactory.getNewPosY(posy - 30);
			rightHand.x = UICoordinatesFactory.getNewPosX(posx + 30);
			rightHand.y = UICoordinatesFactory.getNewPosY(posy + 30);
		}
		
		public function play():void
		{
			
			TweenLite.to(leftHand,2,{x : UICoordinatesFactory.getNewPosX(defaultX - 50),y : UICoordinatesFactory.getNewPosY(defaultY - 50),onComplete : tweenCom,onCompleteParams : [0]});
			TweenLite.to(rightHand,2,{x : UICoordinatesFactory.getNewPosX(defaultX + 50),y : UICoordinatesFactory.getNewPosY(defaultY + 50)});
			TweenLite.to(m_sun,2,{scaleX : 1.3,scaleY : 1.3,onComplete : tweenCom,onCompleteParams : [0]});
		}
		
		private function tweenCom(value : int):void 
		{
			stop();
			play();
		}
		
		public function stop():void
		{
			resetPos(defaultX,defaultY);
			TweenLite.killTweensOf(m_sun);
			TweenLite.killTweensOf(leftHand);
			TweenLite.killTweensOf(rightHand);
			m_sun.scaleX = m_sun.scaleY = 1;
		}
		
		public function destroy():void
		{
			
		}
	}
}