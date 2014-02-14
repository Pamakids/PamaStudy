package com.pamakids.weather.items
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.pamakids.uimanager.UIBase;
	import com.pamakids.utils.CenterPivot;
	import com.pamakids.utils.Screen;
	import com.pamakids.utils.dinput.Micropoe;
	import com.pamakids.utils.math.MathRect;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.model.GameData;
	import com.pamakids.weather.model.SoundManager;
	import starling.textures.TextureAtlas;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import starling.animation.Juggler;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	
	public class StarItem extends UIBase implements IItem
	{	
		private var m_star_liu : MovieClip;
		private var m_stars : Array = [];
		private var bounce : Number = 0.9;
		private var curClick : DisplayObject;
		private var hasCreat : Boolean = false;
		public var isActive : Boolean = false;
		private var liuxingList : Array = [];
		private var liuxingTextures : Vector.<Texture>;
		private var juggler : Juggler = new Juggler();
		
		private var starRect : Rectangle = new Rectangle(50, 10, 900, 140);
		private var starSize : Number = 40;
		private var resTextureAtls : AssetManager;
		public function StarItem()
		{
			super();
		}
		
		
		
		public function init():void
		{
			var posList : Array;
			if (hasCreat == false) {
				
				newData();
				
				setTexture();
				
				hasCreat = true;
				isActive = true;
				m_stars = [];
				
				posList = MathRect.getPosList(starRect,[new Point(starSize,starSize)],10);
				
				for( var i:int = 0; i < 10; i++ )
				{   
                    var k : int = Math.random() > 0.5?1 : -1;
					var m_star : MovieClip = new MovieClip(resTextureAtls.getTextures("stars"));
					m_star.x = (posList[i] as Point).x + Math.random() * 20 * k;
					m_star.y = (posList[i] as Point).y + Math.random() * 20 * k;
					m_star.alpha = Math.random() * 0.5 + 0.5;
					m_star.scaleX = m_star.scaleY = Math.random() * 0.5 + 0.2;
					m_stars.push( m_star );
					m_star.touchable = false;
					m_star.pivotX = m_star.width * 0.5;
					m_star.pivotY = m_star.height * 0.5;
					addChild( m_star );
				}
				liuxingTextures = resTextureAtls.getTextures("Meteor");
			}else{
				isActive = true;
				var len:int = m_stars.length;
				posList = MathRect.getPosList(starRect,[new Point(starSize,starSize)],10);
				for( var j:int = 0; j < len; j++ )
				{
					var tk : int = Math.random() > 0.5?1 : -1;
					(m_stars[j] as MovieClip).x = (posList[j] as Point).x + Math.random() * 20 * tk;
					(m_stars[j] as MovieClip).y = (posList[j] as Point).y + Math.random() * 20 * tk;
					(m_stars[j] as MovieClip).visible = true;
				}
			}
		}
		
		public function close():void{
			isActive = false;
			var len:int = m_stars.length;
			for( var i:int = 0; i < len; i++ )
			{
				(m_stars[i] as MovieClip).visible = false;
			}
		}
		
		public function update(data:*):void
		{
			if (isActive) {
				juggler.advanceTime(0.125);
				var len:int = m_stars.length;
				if (Micropoe.mactivityLevel >= GameData.MICACTIVELEVEL) {
					if (liuxingList.length < 1) {
						var tliuxing : MovieClip = new MovieClip(liuxingTextures, 8);
						tliuxing.pivotX = tliuxing.width * 0.5;
						tliuxing.pivotY = tliuxing.height * 0.5;
						tliuxing.scaleX = tliuxing.scaleY = Math.random() * 0.6 + 0.2;
						tliuxing.x = (-130 + Math.random() * 768) * Screen.wRatio;
						tliuxing.loop = false;
						var oldX : int = tliuxing.x;
						tliuxing.y = -74 * Screen.wRatio;
						tliuxing.rotation = -60 * Math.PI / 180;
						addChild( tliuxing );
						tliuxing.play();
						juggler.add(tliuxing);
						liuxingList.push(tliuxing);
						TweenLite.to(tliuxing, 1.5, { x : oldX + 710 * Screen.wRatio, y : 366 * Screen.ratio, onComplete : tweenCom, onCompleteParams : [tliuxing], ease : Back.easeIn  } );
						SoundManager.getInstance().play("meteor");
					}
				}
			}
		}
		
		public function reset():void {
			if (liuxingList.length > 0) {
				TweenLite.killTweensOf(liuxingList[0]);
				tweenCom(liuxingList[0]);
			}
			close();
		}
		
		
		public function reStart():void {
			
		}
		
		public function destroy():void
		{
			removeEventListeners();
			removeChildren();
		}
		
		private function tweenCom(targe : MovieClip):void 
		{
			removeChild(targe);
			juggler.remove(targe);
			liuxingList = [];
		}
		
		private function newData():void {
			starRect.x *= Screen.wRatio;
			starRect.y *= Screen.ratio;
			starRect.width *= Screen.wRatio;
			starRect.height *= Screen.ratio;
			
			starSize *= Screen.ratio;
		}
		
		
		private function setTexture():void {
			resTextureAtls = AssetManager.getInstance();
		}

	}
}