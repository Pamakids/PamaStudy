package com.pamakids.weather.items
{
	import com.pamakids.utils.CenterPivot;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * 小猪头上的泡泡
	 */
	public class BubblesItem extends Sprite
	{
		private var bubblesBg : Image;
		private var wishIco : MovieClip;
		
		private var wishNames : Array = ["xiangtaiyang", "xiangyun", "xiangxue", "xiangbing"];
		private var wishNames2 : Array = ["xiangxueqiu","xiangxueren","xiangjiedong","xianghuo"];
		public function BubblesItem()
		{
			super();
		}
		
		public function init() : void {
			
			setTexture();
			
			bubblesBg = new Image(paopaoTexture);
			addChild(bubblesBg);
			bubblesBg.touchable = false;
			CenterPivot.center(bubblesBg);
			
			var wishIcoTextures : Vector.<Texture> = new Vector.<Texture>();
			for (var i : int = 0; i < wishNames.length - 1; i ++ ) {
				wishIcoTextures.push(AssetManager.getInstance().getTexture(wishNames[i]));
			}
			for (i = 0; i < wishNames2.length; i ++ ) {
				wishIcoTextures.push(AssetManager.getInstance().getTexture(wishNames2[i]));
			}
			wishIcoTextures.push(Texture.fromBitmapData(new sleepbmd()));
			
			wishIcoTextures.push(AssetManager.getInstance().getTexture("xiangfei"));
			wishIcoTextures.push(AssetManager.getInstance().getTexture(wishNames[3]));
			
			wishIco = new MovieClip(wishIcoTextures, 12);
			addChild(wishIco);
			wishIco.loop = false;
			wishIco.touchable = false;
			CenterPivot.center(wishIco);
		}
		
		public function gotoAndStop(value : int):void {
			wishIco.currentFrame = value;
		}
		
		
		private var paopaoTexture : Texture;
		private function setTexture():void {
			paopaoTexture = AssetManager.getInstance().getTexture("bubbles");
		}
		
	}
}