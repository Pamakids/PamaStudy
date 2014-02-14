package com.pamakids.weather.dhelp
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.pamakids.utils.CenterPivot;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.minterface.IDhelp;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class HelpSnowBall extends Sprite implements IDhelp
	{
		private var snowBall : Image;
		
		private var rightHand : Image;
		
		private var isPlay : Boolean = false;
		public function HelpSnowBall()
		{
			snowBall = new Image(AssetManager.getInstance().getTexture("snowball"));
			addChild(snowBall);
			CenterPivot.center(snowBall);
			
			rightHand = new Image(AssetManager.getInstance().getTexture("lefthand"));
			addChild(rightHand);
			rightHand.pivotX = 0;
			rightHand.pivotY = 0;
			
			reset();
		}
		
		private function reset():void {
			snowBall.x = UICoordinatesFactory.getNewPosX(300);
			snowBall.y = UICoordinatesFactory.getNewPosY(400);
			snowBall.scaleX = snowBall.scaleY = 0.1;
			snowBall.alpha = 0.1;
			
			rightHand.x = UICoordinatesFactory.getNewPosX(300);
			rightHand.y = UICoordinatesFactory.getNewPosY(400);
		}
		
		public function play():void
		{
			if(isPlay == false){
				TweenMax.to(snowBall, 2, { scaleX : 0.5, scaleY : 0.5, alpha : 1,rotation : 720,
							bezier:[ { x:UICoordinatesFactory.getNewPosX(300), y:UICoordinatesFactory.getNewPosY(400) }, { x:UICoordinatesFactory.getNewPosX(550), y:UICoordinatesFactory.getNewPosY(350) } ], orientToBezier:true ,
							onComplete : tweenCom } );
				TweenMax.to(rightHand, 2, {bezier:[ { x:UICoordinatesFactory.getNewPosX(300), y:UICoordinatesFactory.getNewPosY(400) }, { x:UICoordinatesFactory.getNewPosX(550), y:UICoordinatesFactory.getNewPosY(350) } ], orientToBezier:true
				});
				
				isPlay = true;
			}
		}
		
		private function tweenCom():void 
		{
			TweenLite.delayedCall(2,rePlay);
		}
		
		private function rePlay():void 
		{
			stop();
			play();
		}
		
		public function stop():void
		{
			isPlay = false;
			TweenLite.killDelayedCallsTo(rePlay);
			TweenMax.killTweensOf(snowBall);
			TweenMax.killTweensOf(rightHand);
			reset();
		}
		
		public function destroy():void
		{
			
		}
	}
}