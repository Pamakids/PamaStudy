package com.pamakids.effects.weather
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.DisplayObject;
	
	public class Earthquake
	{
	
		public var callBack : Function;
		public var vx : Number = 5;
		public var vy : Number = 5;
		
		public const FRAME_RATE		: int = 25;			// adjustable, but looks pretty good at 25
		private var timer			: Timer;
		
		private var image			: DisplayObject;
		private var originalX		: int;
		private var originalY		: int;
		
		private var intensity		: int;
		private var intensityOffset	: int;
		
		
		private var msPerUpdate:int;
		private var totalUpdates:int;
		private var mSecond : Number;
		
		private var oldTime : uint;
		public function Earthquake()
		{
			// static class - do not instantiate
		}
		
		// === A P I ===
		public function go( _image : DisplayObject, _intensity:Number = 10, _seconds:Number = 1 ): void
		{
			if(timer){
				stop();
			}
			
			image = _image;
			originalX = image.x;
			originalY = image.y;
			
			intensity = _intensity;
			intensityOffset = intensity / 2;
			
			mSecond = _seconds;
			
			// truncations and integer math are faster
			msPerUpdate = int( 1000 / FRAME_RATE );
			totalUpdates = int( _seconds * 1000 / msPerUpdate );
			
			timer = new Timer( msPerUpdate, totalUpdates );
			timer.addEventListener( TimerEvent.TIMER, quake );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, resetImage );
			
			timer.start();
			
		}
		
		public function stop() : void {
			if (timer) {
				timer.stop();
				timer.removeEventListener( TimerEvent.TIMER, quake );
				timer.removeEventListener( TimerEvent.TIMER_COMPLETE, resetImage );
			}
		}
		
		public static function temp(): void {}
		
		
		// === ===
		private function quake( event:TimerEvent ): void
		{
			//trace( intensity );
			//var newX:int = originalX + Math.random() * intensity - intensityOffset;
			//var newY:int = originalY + Math.random() * intensity - intensityOffset;
			var newX:int = originalX + Math.random() * vx;
			var newY:int = originalY + Math.random() * vy;
			image.x = newX;
			if(vy != 0){
				image.y = newY;
			}
		}
		
		private function resetImage( event:TimerEvent = null ): void
		{
			image.x = originalX;
			if(vy != 0){
				image.y = originalY;
			}
			stop();
			//cleanup();
			
			
			if (callBack != null) {
				this.callBack();
			}
		}
		
		private function cleanup(): void
		{
			timer = null;
			image = null;
		}
		

	}
}