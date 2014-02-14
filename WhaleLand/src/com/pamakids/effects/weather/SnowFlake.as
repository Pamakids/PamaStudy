// SNOWSTORM IN 15 MINS!
// Author : Seb Lee-Delisle
// Blog : www.sebleedelisle.com
// Company : www.pluginmedia.net
//
// This work is licensed under a Creative Commons  2.0 License.

// Full details at 
// http://creativecommons.org/licenses/by/2.0/uk/

// You may re-use this code as you wish, but a credit would be 
// appreciated. And I'd love to see what you do with it! 
// mail me : seb@sebleedelisle.com

package com.pamakids.effects.weather
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class SnowFlake
	{
		
		public var pos : Point = new Point();
		public var xVel:Number; 
		public var yVel:Number; 
		public var size:Number ;
		public var screenArea:Rectangle; 
		
		private var bitmapData : BitmapData;
		
		private var texture : BitmapData;
		public var img : Bitmap;
		
		
		
		public function SnowFlake(screenarea:Rectangle,vtexture : BitmapData)
		{
			screenArea = screenarea; 	
			texture = vtexture;
			var z:Number = (Math.random()*600)-250; 
			size = calculatePerspectiveSize(z);
			img = new Bitmap(texture);
			img.scaleX = img.scaleY = size * 0.35;
			img.x = Math.random()*screenArea.width; 
			xVel = (Math.random()*2)-1; 
			yVel = 1; 
			xVel*=size; 
			yVel*=size; 
			
		}
		
		public function update(wind:Number):void
		{
			
			img.x+=xVel; 
			img.y+=yVel;
		
			img.x += (wind*size);
			
			if(img.y>screenArea.bottom) img.y = screenArea.top; 
			if(img.x>screenArea.right) img.x = screenArea.left; 
			else if(img.x<screenArea.left) img.x = screenArea.right; 
			pos.x = img.x;
			pos.y = img.y;
			
		}
		
		public function calculatePerspectiveSize(z:Number) : Number
		{
			var fov:Number = 300; 
			return fov/(z+fov); 
			
			
		}
		
		
	}
	
}