package com.pamakids.weather.items
{
	import com.greensock.TweenLite;
	import com.gslib.net.hires.debug.Stats;
	import com.pamakids.uimanager.UIBase;
	import com.pamakids.utils.ColorUtils;
	import com.pamakids.utils.DeviceInfo;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	
	import flash.utils.getTimer;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class SkyItem extends UIBase implements IItem
	{
		public var callBack : Function;
		public var index : int = 0;
		private var oldIndex : int = 0;
		private var oldTime : uint = 0;
		
		private var frameList : Array = [0, 1, 2, 1, 0, 0, 3, 4, 3, 0];
		private var bgNames : Array = ["DaySky", "NightSky"];
		private var bgNames_iphone : Array = ["daySky","nightsky"];
		private var skyTextures : Vector.<Texture>;
		private var m_sky : MovieClip;
		private var m_ghostSky : MovieClip;
		private var intervalTime : int = 100;
		private var colorTransList : Array = [];
		public function SkyItem()
		{
			super();
			colorTransList = [ColorUtils.daySkyLv1Trans, ColorUtils.daySkyLv2Trans,
							  ColorUtils.daySkyLv3Trans, ColorUtils.nightSkyLv2Trans,
							  ColorUtils.nightSkyLv1Trans];
		}
		
		public function init():void
		{	
			skyTextures = new Vector.<Texture>();
			oldTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME,onUpdate);
		}
		
		public function update(data : *):void
		{	
			index = data;
			m_sky.alpha = 0;
			if (oldIndex > 5 && oldIndex < 9) {
				m_ghostSky.currentFrame = 1;
			}else {
				m_ghostSky.currentFrame = 0;
			}
			
			
			if (data > 5 && index < 9) {
				m_sky.currentFrame = 1;
			}else {
				m_sky.currentFrame = 0;
			}                   
			changeToDefaultColor(m_ghostSky, oldIndex);
			changeToDefaultColor(m_sky, data);
			TweenLite.to(m_sky, 1, { alpha : 1, onComplete : tweenComHandler, onCompleteParams : [index] } );
			oldIndex = index;
		}
		
		public function destroy():void
		{
			for (var i : int = 0; i < skyTextures.length;i ++ ) {
				if (skyTextures[i]) {
					skyTextures[i].dispose();
				}
			}
			
			removeChild(m_ghostSky, true);
			m_ghostSky = null;
			removeChild(m_sky, true);
			m_sky = null;
			
		}
		
		public function reset():void {
			initData();
		}
		
		private function setBgTexture() : Texture {
			if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
				return BitmapDataLibrary.getTexture(bgNames.shift());
			}else {
				return AssetManager.getInstance().getTexture(bgNames_iphone.shift());
			}
		}
		
		private function onUpdate(e:Event):void 
		{
			var passTime : int = getTimer() - oldTime;
			
			if (passTime >= intervalTime) {
				var len : int = bgNames.length >= bgNames_iphone.length?bgNames_iphone.length : bgNames.length;
				if (len > 0) {
					var tTexture : Texture = setBgTexture();
					skyTextures.push(tTexture);
				}else {
					this.removeEventListener(Event.ENTER_FRAME, onUpdate);
					installationSky();
				}
				oldTime = getTimer();
			}
		}
		
		private function initData():void {
			index = 0;
			oldIndex = 0;
			
			changeToDefaultColor(m_ghostSky,0);
			changeToDefaultColor(m_sky, 0);
			
			m_ghostSky.currentFrame = 0;
			m_sky.currentFrame = 0;
			TweenLite.killTweensOf(m_sky);
			TweenLite.killTweensOf(m_ghostSky);
		}
		
		private function installationSky():void 
		{
			//克隆一个对象放在下面用作渐变显示
			m_ghostSky = new MovieClip(skyTextures);
			addChild(m_ghostSky);
			m_ghostSky.touchable = false;
			setDefaultColor(m_ghostSky);
			changeToDefaultColor(m_ghostSky,0);
			
			m_sky = new MovieClip(skyTextures);
			addChild(m_sky);
			setDefaultColor(m_sky);
			changeToDefaultColor(m_sky,0);
			if (this.callBack != null) {
				this.callBack();
			}
		}
		
		private function tweenComHandler(value : int):void {
			changeToDefaultColor(m_ghostSky,value - 1);
		}
		
		private function setDefaultColor(obj : Image):void {
			obj.data.defaultColor = obj.color;
		}
		
		//设置颜色
		//@mode 0 : 恢复默认颜色 1 : 生成新的颜色
		private function changeToDefaultColor(obj : Image, mode : int = -1):void {
			if (mode == -1) {
				obj.color = obj.data.defaultColor;
			}else{
				obj.color = ColorUtils.getNewColor(obj.data.defaultColor,colorTransList[frameList[mode]]);
			}
		}
	}
}