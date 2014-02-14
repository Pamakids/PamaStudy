package com.pamakids.weather.dhelp
{
	import com.greensock.TweenLite;
	import com.pamakids.core.PluginControl;
	import com.pamakids.core.msgs.TouchMsg;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.behavior.FrictionBehavior;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.minterface.IDhelp;
	import starling.display.Image;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	import flash.utils.getQualifiedClassName;
	
	public class HelpIcePig extends Sprite implements IDhelp
	{
		private var m_pig : MovieClip;
		
		private var defaultX : Number;
		private var defaultY : Number;
		
		private var rightHand : Image;
		
		private var isPlaying : Boolean = false;
		public function HelpIcePig(posx : Number = 512,posy : Number = 384)
		{
			
			trace("哈哈");
			defaultX = posx;
			defaultY = posy;
			
			var pigIceTextures : Vector.<Texture> = AssetManager.getInstance().getTextures("dongbing");
			m_pig = new MovieClip(pigIceTextures, 12);
			m_pig.loop = false;
			addChild(m_pig);
			m_pig.x = UICoordinatesFactory.getNewPosX(defaultX - 100);
			m_pig.y = UICoordinatesFactory.getNewPosY(defaultY - 100);
			m_pig.touchable = false;
			m_pig.addEventListener(Event.COMPLETE, onMovieComHandler);
			
			rightHand = new Image(AssetManager.getInstance().getTexture("lefthand"));
			addChild(rightHand);
			rightHand.touchable = false;
			rightHand.pivotX = 0;
			rightHand.pivotY = 0;
			
			initData();
		}
		
		private function initData():void {
			rightHand.x = UICoordinatesFactory.getNewPosX(defaultX - 80);
			rightHand.y = UICoordinatesFactory.getNewPosY(defaultY + 30);
		}
		
		private function onMovieComHandler(e:Event):void 
		{
			TweenLite.delayedCall(2,rePlay);
		}
		
		private function rePlay():void 
		{
			trace("重新播放~~~~~~~~~");
			count = 0;
			stop();
			play();
		}
		
		public function play():void
		{
			trace("开始播放 : " + isPlaying);
			if (isPlaying == false) {
				isPlaying = true;
				TweenLite.to(rightHand,1,{x :UICoordinatesFactory.getNewPosX(defaultX + 70) ,y : UICoordinatesFactory.getNewPosY(defaultY - 120),onComplete : tweenCom});
			}
		}
		
		private function tweenCom():void 
		{
			TweenLite.to(rightHand,1,{x :UICoordinatesFactory.getNewPosX(defaultX - 80) ,y : UICoordinatesFactory.getNewPosY(defaultY + 30),onComplete : nextTween});
		}
		
		private var count : int = 0;
		private function nextTween():void 
		{
			count ++;
			if (count >= 2) {
				playMovie();
			}else {
				TweenLite.to(rightHand,1,{x :UICoordinatesFactory.getNewPosX(defaultX + 70) ,y : UICoordinatesFactory.getNewPosY(defaultY - 120),onComplete : tweenCom});
			}
		}
		
		private function playMovie():void 
		{
			Starling.juggler.add(m_pig);
		}
		
		public function stop():void
		{
			TweenLite.killDelayedCallsTo(rePlay);
			TweenLite.killDelayedCallsTo(playMovie);
			Starling.juggler.remove(m_pig);
			m_pig.currentFrame = 0;
			count = 0;
			isPlaying = false;
		}
		
		public function destroy():void
		{
			
		}
	}
}