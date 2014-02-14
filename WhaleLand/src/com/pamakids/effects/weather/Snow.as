package com.pamakids.effects.weather
{
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.model.GameData;
	import starling.display.Image;
	import starling.textures.Texture;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author 
	 */
	public class Snow
	{
		public var isStop : Boolean = false;
		public var isend : Boolean = false;
		public var maxSpeed : int = 4;
		public var xVel:Number; 
		public var yVel:Number; 
		//private var bd:BitmapData;
		private var speed:Number;
		private var moy:Number;
		private var size : Number = 0;
		public var img : Image;
		private var bmd : Texture;
		public function Snow(bd : Texture) 
		{	
			maxSpeed *= Screen.ratio;
			
			var z:Number = (Math.random()*600)-200; 
			size = calculatePerspectiveSize(z);
			bmd = bd;
			img = new Image(bmd);
			img.touchable = false;
			//if (size < 1) {
				//size = 1;
			//}
			img.scaleX = img.scaleY = size * 0.5 * Screen.ratio;
			
/*			xVel = (Math.random()*2)-1; 
			yVel = 1; 
			xVel*=size; 
			yVel*=size; */
			
			xVel = (Math.random()*2)-1 * Screen.ratio; 
			
			//yVel = 1; 
			
			xVel*=size; 
			//yVel*=size; 
			
			reInit();
			
			
			//this.addEventListener(Event.ENTER_FRAME, move);
		}
		
		public function reset():void {
			isStop = false;
			isend = false;
			reInit();
		}
		
		public function update(wind : int = 0):void {
			//moy += speed;
			img.x += xVel;
			img.y += speed;
			img.x += wind * size;
			//img.y = Math.round(moy);
			
			//this.rotation += 1;
			if (img.y > Screen.hght + 10) {
				if(isStop){
					img.y = Screen.hght + 100;
					img.visible = false;
					isend = true;
				}else {
					isend = false;
					reInit();
				}
			}
			
			if(img.x>Screen.wdth) img.x = 0; 
			else if(img.x<0) img.x = Screen.wdth; 
		}
		private function reInit():void {
			img.x = Math.round(Math.random() * Screen.wdth);
			img.y = - Math.round(Math.random() * Screen.hght);
			moy = img.y;
			speed = (1 + Math.round(img.width * 0.1 + Math.random() * 1)) * Screen.ratio;
			speed *= size;
			if (speed >= maxSpeed) {
				speed = maxSpeed;
			}
			
		}
		
		public function calculatePerspectiveSize(z:Number) : Number
		{
			var fov:Number = 300; 
			return fov/(z+fov); 
		}
	}
	
}