package com.pamakids.weather.factory
{
	import com.pamakids.utils.DeviceInfo;
	import com.pamakids.utils.Screen;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class AssetsFactory
	{
		private static var instance : AssetsFactory;
		public function AssetsFactory()
		{
			
		}
		
		public static function getInstance():AssetsFactory {
			if (instance == null) {
				instance = new AssetsFactory();
			}
			return instance;
		}
		
		
		//开始的logo动画
		public function getStartLoading():MovieClip {
			if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
				return new StartLoading();
			}else {
				return new StartLoadingIphone();
			}
		}
		
		//startUI背景材质
		private var startUIBg : Array = ["BgDay", "BgNight"];
		private var startUIBg_iphone : Array = ["startbg_day","startbg_night"];
		public function getStartUIBgTexture(value : int = 0):Texture {
			if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
				return BitmapDataLibrary.getTexture(startUIBg[value]);
			}else {
				return AssetManager.getInstance().getTexture(startUIBg_iphone[value]);
			}
		}
		
				//frontBg
		public function getStartUIFrontBg() : Texture {
			if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
				return BitmapDataLibrary.getTexture("FrontBg");
			}else {
				return AssetManager.getInstance().getTexture("frontbg");
			}
		}
		
		
		private var bmdLib : BitmapDataLibrary = new BitmapDataLibrary();
		//
		private var startFogs : Array = [BitmapDataLibrary.BGFOG, BitmapDataLibrary.BGFOG_NIGHT];
		private var startFogs_iphone : Array = [BitmapDataLibrary.IOSBG_FOG,BitmapDataLibrary.IOSBG_NIGHT_FOG];
		public function getStartUIFogTexture(value : int = 0):BitmapData {
			if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
				return bmdLib.lookupBitmapData(startFogs[value]);
			}else {
				return bmdLib.lookupBitmapData(startFogs_iphone[value]);
			}
		}
		
		
		public function getMojoyLogo():BitmapData{
			if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
				return bmdLib.lookupBitmapData("MojoyLogo");
			}else {
				return bmdLib.lookupBitmapData("MojoyIphoneLogo");
			}
		}
	
		
		
		//aboutUI
/*		public function getAboutUI() : TextureAtlas {
			if (Screen.type == "ipad") {
				return BitmapDataLibrary.getAsset3Atlas();
			}else {
				return BitmapDataLibrary.getIosAsset2Atlas();
			}
		}*/
		
		public function getAboutUIBg() : Texture {
			if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
				return BitmapDataLibrary.getTexture("about_bg");
			}else {
				return AssetManager.getInstance().getTexture("about");
			}
		}
		
		
		//loadingUI
/*		public function getLoadingUITextures():TextureAtlas { 
			if (Screen.type == "ipad") {
				return BitmapDataLibrary.getAsset2Atlas();
			}else {
				return BitmapDataLibrary.getIosAsset2Atlas();
			}
			
			return null;
		}*/
		
	}
}