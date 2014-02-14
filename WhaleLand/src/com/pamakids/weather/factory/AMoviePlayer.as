package com.pamakids.weather.factory
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class AMoviePlayer extends Sprite
	{
		//public var data : Object = { };
		
		public var curFrameId : int;
		
		public var curAnimation : Object = { };
		public var currentAnimationID : String = "";
		private var imgDic : Dictionary = new Dictionary();
		private var animationList : Array = [];
		
		public var curImage : Image;
		
		private var rect : Rectangle = new Rectangle();
		
		
		public function AMoviePlayer()
		{
			super();
		}
		
		public function addAniamtions( a_animationID : String, a_texture : Vector.<Texture> ,a_alignMode : int = 0) : void
		{
			var data : Object = { };
			var img : Image = new Image(a_texture[0]);
			alignMode(img,a_alignMode);
			//img.touchable = false;
			var imgTextures : Vector.<Texture> = a_texture;
			data.image = img;
			data.textures = imgTextures;
			data.animationID = a_animationID;
			data.alignMode = a_alignMode;
			data.defaultColor = img.color;
			imgDic[a_animationID] = data;
			imgDic[a_animationID].image.visible = false;
			//addChild(imgDic[a_animationID].image);
			animationList.push(data);
		}
		
		public function updateTexture(a_frameId : String,a_texture : Texture):void {
			
		}
		
		public function copy() : AMoviePlayer
		{
			var player : AMoviePlayer = new AMoviePlayer();
			for( var i:int = 0; i < animationList.length; i++ )
			{
				var id:String = animationList[ i ].animationID;
				var textures : Vector.<Texture> = animationList[ i ].textures;
				player.addAniamtions( id, textures, animationList[ i ].alignMode);
			}
			return player;
		}
		
		
		public function hitTestByRect(a_rect : Rectangle):Boolean {
			rect.x = this.x;
			rect.y = this.y;
			rect.width = curImage.width;
			rect.height = curImage.height;
			
			if (rect.intersects(a_rect)) {
				return true;
			}
			return false;
		}
		
		public function get aRect():Rectangle {
			rect.x = this.x;
			rect.y = this.y;
			rect.width = curImage.width;
			rect.height = curImage.height;
			
			return rect;
		}
		
		public function gotoFrame(a_frameId : int, a_animationID : String):void {
			
			for (var i : int = 0; i < animationList.length;i ++ ) {
				animationList[i].image.visible = false;
			}
			
			
			if (imgDic[a_animationID]) {
				var updateTexture : Texture = imgDic[a_animationID].textures[a_frameId];
				(imgDic[a_animationID].image as Image).texture = updateTexture;
				(imgDic[a_animationID].image as Image).visible = true;
				addChild(imgDic[a_animationID].image);
				curImage = (imgDic[a_animationID].image as Image);
				currentAnimationID = a_animationID;
				curFrameId = a_frameId;
				curAnimation = imgDic[a_animationID];
			}
		}
		
		//注册点位置,默认居中
		private function alignMode(disObj : DisplayObject, mode : int = 0):void {
			if(mode == 0){
				disObj.pivotX = disObj.width * 0.5;
				disObj.pivotY = disObj.height * 0.5;
			}
		}
	}
}