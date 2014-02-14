package com.pamakids.weather.items
{
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.urbansquall.ginger.Animation;
	import com.urbansquall.ginger.AnimationPlayer;
	import com.urbansquall.ginger.tools.AnimationBuilder;
	import com.urbansquall.ginger.tools.AnimationPlayerFactory;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	import flash.display.BitmapData;
	
	import flash.utils.getTimer;
	
	/**
	 * 乐符控制
	 * @author icekiller
	 */
	public class MusicBreak extends Sprite
	{
		private var musicBreakList : Array = [ ];
		private var musicBreakPool : Array = [];	
		private var musicTextures : Vector.<Texture>;
		public function MusicBreak() 
		{
			this.touchable = false;
		}
		
		public function install():void {

		}
		
		public function reset():void {
			for (var i : int = 0; i < musicBreakList.length; i ++ ) {
				var musicbreak : Image = musicBreakList[i] as Image;
				musicBreakList.splice(i, 1);
				musicbreak.visible = false;
				musicBreakPool.push(musicbreak);
			}
		}
		
		public function creatMusicBreak(pos : Point):void {
			
			if (musicTextures) {
				
			}else {
				musicTextures = AssetManager.getInstance().getTextures("note");
			}
			
			var musicBreak : Image;
			var randNum : int = int(Math.random() * 10);
			if (musicBreakPool.length < 1) {
				musicBreak = new Image(musicTextures[randNum]);
				addChild(musicBreak);
				musicBreak.touchable = false;
				musicBreak.pivotX = musicBreak.width * 0.5;
				musicBreak.pivotY = musicBreak.height * 0.5;
			}else {
				trace("执行到乐符的仓库了么");
				musicBreak = musicBreakPool.shift();
				musicBreak.texture = musicTextures[randNum];
				musicBreak.visible = true;
			}
			musicBreak.x = pos.x;
			musicBreak.y = pos.y;
			musicBreakList.push(musicBreak);
			musicBreak.data.oldTime = getTimer();
			musicBreak.data.vy = -Math.random() * 1 - 1;
			musicBreak.data.angle = 0;
			musicBreak.data.random = Math.random();
			musicBreak.data.oldX = pos.x;
		}
		
		public function update():void {
			for (var i : int = 0; i < musicBreakList.length; i ++ ) {
				var musicbreak : Image = musicBreakList[i] as Image;
				
				musicbreak.data.angle += 0.05;
				if(musicbreak.data.random > 0.5){
					musicbreak.x += Math.sin(musicbreak.data.angle) * (musicbreak.data.vy * (Math.random() * 2 + 1)) * Screen.ratio;
				}else {
					musicbreak.x -= Math.cos(musicbreak.data.angle) * (musicbreak.data.vy * (Math.random() * 2 + 1)) * Screen.ratio;
				}
				musicbreak.y += musicbreak.data.vy * 0.7;
				
				if ((getTimer() - musicbreak.data.oldTime) >= 2000) {
					musicBreakList.splice(i, 1);
					musicbreak.visible = false;
					musicBreakPool.push(musicbreak);
				}
			}
		}
		
		
	}

}