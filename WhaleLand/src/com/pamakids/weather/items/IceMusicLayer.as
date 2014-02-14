package com.pamakids.weather.items
{
	import com.pamakids.utils.ColorUtils;
	import com.pamakids.utils.DeviceInfo;
	import com.pamakids.utils.Screen;
	import com.pamakids.utils.dinput.MouseDown;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.model.GameData;
	import com.pamakids.weather.model.SoundManager;
	import com.urbansquall.ginger.Animation;
	import com.urbansquall.ginger.AnimationPlayer;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class IceMusicLayer extends Sprite
	{
		public var instanllCom : Function;
		private var icePlayerList : Array = [];
		private var icePosList : Array = [new Point(234, 512), new Point(292, 451), new Point(578, 473), new Point(613, 443), new Point(667, 589)];
		private var iceAniamtionList : Array = [];
		private var iceMusicList : Array = [];
		
		public var callMusic : Function;
		
		private var resTextureAlts : AssetManager;
		
		private var resTextureNames : Array = ["iceblock001","iceblock002","iceblock003","iceblock004","iceblock005"];
		public function IceMusicLayer()
		{
			
		}
		
		public function instanll():void {
			newData();
			addEventListener(Event.ENTER_FRAME, loadRes);
		}
		
		public function reset():void {
			iceUpdateDayState(0,icePlayerList);
		}
		
		
		private function newData():void {
			if(DeviceInfo.getDeviceType().indexOf("iphone") == -1){
				
			}else {
				for (var i : int = 0; i < icePosList.length;i ++ ) {
					var pos : Point = icePosList[i] as Point;
					pos.x = UICoordinatesFactory.getNewPosX(pos.x);
					pos.y = UICoordinatesFactory.getNewPosY(pos.y);
				}
				//resTextureAlts = AssetManager.getInstance();
			}
			resTextureAlts = AssetManager.getInstance();
		}
		
		private function loadRes(e:Event):void 
		{
			if (resTextureNames.length > 0) {
				var ice1TextAlts : Texture = resTextureAlts.getTexture(resTextureNames.shift());
				var icePlayer1 : Image = new Image(ice1TextAlts);
				icePlayerList.push(icePlayer1);
				setDefaultColor(icePlayer1);
				var pos : Point = icePosList.shift();
				icePlayer1.x = pos.x;
				icePlayer1.y = pos.y;
				icePlayer1.addEventListener(TouchEvent.TOUCH, onTouchIce);
			}else {			
				removeEventListener(Event.ENTER_FRAME, loadRes);
				if (instanllCom != null) {
					this.instanllCom();
				}
			}

		}
		
		private function onTouchIce(e:TouchEvent):void 
		{
			var touch : Touch = e.getTouch(e.currentTarget as DisplayObject);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					
				}else if (touch.phase == TouchPhase.ENDED) {
						onClickIceBox(touch);
				}
			}
		}
		
		private function onClickIceBox(e : Touch):void 
		{
			var len : int = SoundManager.soundList.length;
			var mindex : int = GameData.soundList[GameData.soundInex] - 1;
			SoundManager.getInstance().play(SoundManager.soundList[mindex]);
			if (GameData.soundInex >= GameData.soundList.length - 1) {
				GameData.soundInex = 0;
			}else {
				GameData.soundInex += 1;
			}
			
			if (this.callMusic != null) {
				this.callMusic(e.globalX,e.globalY - e.target.height * 0.5);
			}
		}
		
		public function show():void {
			
		}
		
		/**
		 *白天黑夜
		 */
		public function updateIce():void {
			var len : int = icePlayerList.length;
			for (var i : int = 0; i < len; i ++ ) {

				if ((icePlayerList[i] as Image).parent) {
					
				}else {
					addChild((icePlayerList[i] as Image));
				}
				var str : String = "0";
				if (GameData.dayState == 0) {
					str = "0";
					iceUpdateDayState(0,icePlayerList);
				}else {
					str = "1";
					iceUpdateDayState(1,icePlayerList);
				}
			}
		}
		
		//更新静态树的白天黑夜状态
		private function iceUpdateDayState(value : int = 0, list : Array = null):void {
			if(list != null){
				for (var i : int = 0; i < list.length;i ++ ) {
					if (value == 0) {
						changeToDefaultColor(list[i]);
					}else if(value == 1){
						changeToDefaultColor(list[i],1);	
					}
				}
			}
		}
		
		//设置颜色
		//@mode 0 : 恢复默认颜色 1 : 生成新的颜色
		private function changeToDefaultColor(obj : Image, mode : int = 0):void {
			if (mode == 0) {
				obj.color = obj.data.defaultColor;
			}else if (mode == 1) {
				obj.color = ColorUtils.getNewColor(obj.data.defaultColor,ColorUtils.islandColorTrans);
			}
		}
		
		
		
		/**
		 * 更新下雪状态
		 */
		public function updateSnowState():void {
			
		}
		
		public function destory():void {
			removeEventListeners();
			removeChildren();
		}
		
		//记录默认颜色
		private function setDefaultColor(obj : Image):void {
			obj.data.defaultColor = obj.color;
		}
		
		private function getTheIce(tar : *):int {
			for (var i : int = 0; i < iceMusicList.length;i ++ ) {
				if (iceMusicList[i] == tar) {
					return i;
					break;
				}
			}
			return -1;
		}
	}
}