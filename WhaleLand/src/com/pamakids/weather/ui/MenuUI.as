package com.pamakids.weather.ui
{
	import com.greensock.easing.Bounce;
	import com.greensock.TweenLite;
	import com.pamakids.core.msgs.DelAllMsg;
	import com.pamakids.core.PluginControl;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.model.SoundManager;
	import starling.display.DisplayObject;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	import flash.utils.getTimer;
	
	public class MenuUI extends Sprite
	{
		//返回
		public var callBack : Function;
		
		//wishList界面
		public var callWishList : Function;
		
		//
		private var wood : Image;
		private var arrowItem : Sprite;
		//返回
		private var backButton : Image;
		//
		private var soundButton : Sprite;
		//
		private var wishListIco : Sprite;
		
		private var defaultY : Number = -120;
		
		private var arrowArea : Quad;
		private var wishListIcoArea : Quad;
		private var soundBtnArea : Quad;
		
		private var soundButtonMc : MovieClip;
		private var wishListImg : Image;
		//菜单类
		public function MenuUI()
		{
			super();
		}
		
		public function reset():void {
			soundButtonMc.currentFrame = 1;
		}
		
		public function init():void {
			
			defaultY *= Screen.ratio;
			//setTexture();
			//wood
			wood = new Image(AssetManager.getInstance().getTexture("wood"));
			addChild(wood);
			wood.touchable = false;
			wood.x = UICoordinatesFactory.getNewPosX(775);
			wood.y = defaultY;
			
			
			arrowItem = new Sprite();
			addChild(arrowItem);
			var arrowImg : Image = new Image(AssetManager.getInstance().getTexture("menu"));
			arrowArea = new Quad(arrowImg.width * 1.5, arrowImg.height * 1.5, 0xFFFFFF);
			centerImg(arrowArea);
			centerImg(arrowImg);
			arrowArea.alpha = 0;
			arrowItem.addChild(arrowImg);
			arrowItem.addChild(arrowArea);
			arrowItem.x = 29 * Screen.ratio + arrowImg.width * 0.5;
			arrowItem.data.oldX = arrowItem.x;
			arrowItem.y = UICoordinatesFactory.getNewPosY(21) + arrowImg.height * 0.5;
			
			backButton = new Image(AssetManager.getInstance().getTexture("menu_back"));
			backButton.x = 77 * Screen.ratio;
			backButton.y = defaultY;
			addChild(backButton);
			
			//wishlist
			
			wishListIco = new Sprite();
			addChild(wishListIco);
			wishListImg = new Image(AssetManager.getInstance().getTexture("wishlist"));
			wishListIcoArea = new Quad(wishListImg.width * 1.5, wishListImg.height * 1.5, 0xFF0000);
			centerImg(wishListImg);
			centerImg(wishListIcoArea);
			wishListIco.addChild(wishListImg);
			wishListIco.addChild(wishListIcoArea);
			trace("wishListIco.w : " + wishListIcoArea.width);
			wishListIcoArea.alpha = 0;
			wishListIco.x = UICoordinatesFactory.getNewPosX(816) + wishListImg.width * 0.5;
			wishListIco.y = defaultY;
			
			
			
			soundButton = new Sprite();
			addChild(soundButton);
			
			soundButtonMc = new MovieClip(AssetManager.getInstance().getTextures("sound_"));
			soundBtnArea = new Quad(soundButtonMc.width * 1.5, soundButtonMc.height * 1.5, 0x00FF00);
			centerImg(soundButtonMc);
			centerImg(soundBtnArea);
			soundButton.addChild(soundButtonMc);
			soundButton.addChild(soundBtnArea);
			soundBtnArea.alpha = 0;
			soundButton.x = UICoordinatesFactory.getNewPosX(884) + soundButtonMc.width * 0.5;
			soundButton.y = defaultY;
			soundButtonMc.currentFrame = 1;
			this.addEventListener(TouchEvent.TOUCH, onTouchHandler);
		}
		
		public function isClicked(tar : DisplayObject):Boolean {
			if (tar == arrowItem || tar == backButton || tar == wishListIco || tar == soundButton) {
				return true;
			}
			return false;
		}
	
		
		private function onTouchHandler(e:TouchEvent):void 
		{
			var touch : Touch = e.getTouch(stage);
			var touchs : Vector.<Touch> = e.getTouches(stage);
			if (touch) {
				if (touchs.length == 1) {
					if (touch.phase == TouchPhase.BEGAN) {
						
					}else if (touch.phase == TouchPhase.ENDED) {
						onToucEnd(touch);
					}
				}
			}
		}
		
		private function onToucEnd(touch:Touch):void 
		{
			SoundManager.getInstance().play("btn_click");
			trace("touch.target : " + touch.target);
			if (touch.target == arrowArea) {
				TweenLite.to(arrowItem,1,{x : -arrowItem.width - 10,ease:Bounce.easeOut});
				TweenLite.to(wood,1,{y : 0,ease:Bounce.easeOut});
				TweenLite.to(wishListIco,1,{y : UICoordinatesFactory.getNewPosY(27) + wishListImg.height * 0.5,ease:Bounce.easeOut});
				TweenLite.to(backButton,1,{y : 0,ease:Bounce.easeOut});
				TweenLite.to(soundButton, 1, { y : UICoordinatesFactory.getNewPosY(22) + soundButtonMc.height * 0.5, ease:Bounce.easeOut } );
				
				trace("getTimer : " + getTimer());
				TweenLite.delayedCall(5,resetPos); 
			}else if (touch.target == soundBtnArea) {
				TweenLite.killDelayedCallsTo(resetPos);
				if (soundButtonMc.currentFrame == 1) {
					SoundManager.getInstance().stopAllSound();
				}else {
					SoundManager.getInstance().startAllSound();
				}
				soundButtonMc.currentFrame = soundButtonMc.currentFrame == 1?0 : 1;
				resetPos();
			}else if (touch.target == backButton) {
				TweenLite.killDelayedCallsTo(resetPos);
				resetPos();
				if (this.callBack != null) {
					
					PluginControl.BroadcastMsg(new DelAllMsg());
					this.callBack();
				}
			}else if (touch.target == wishListIcoArea) {
				TweenLite.killDelayedCallsTo(resetPos);
				resetPos();
				if (this.callWishList != null) {
					this.callWishList();
				}
			}
		}
		
		public function resetPos():void 
		{
			if (int(arrowItem.x) == int( -arrowItem.width - 10)) {
				TweenLite.killDelayedCallsTo(resetPos);
				trace("menu归位~~~~~~~~~~~~~~~~~~~~~~~~ : " + getTimer());
				TweenLite.to(arrowItem,1,{x : arrowItem.data.oldX,ease:Bounce.easeOut});
				TweenLite.to(backButton,1,{y : defaultY,ease:Bounce.easeOut});
				TweenLite.to(soundButton, 1, { y : defaultY, ease:Bounce.easeOut } );
				TweenLite.to(wood,1,{y : defaultY,ease:Bounce.easeOut});
				TweenLite.to(wishListIco, 1, { y : defaultY, ease:Bounce.easeOut } );
			}
		}
		
		private function centerImg(img : Quad):void {
			img.pivotX = img.width * 0.5;
			img.pivotY = img.height * 0.5;
		}
	}
}