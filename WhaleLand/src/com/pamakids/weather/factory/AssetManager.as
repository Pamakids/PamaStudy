package com.pamakids.weather.factory
{
	import com.pamakids.utils.DeviceInfo;
	import com.pamakids.utils.DeviceType;
	import com.pamakids.utils.Screen;
	
	import starling.textures.Texture;

	public class AssetManager
	{
		private static var instance : AssetManager;
		private var curAssetFactory : IAssetFactory;
		
		private var ipadAssetFactory : IpadAssetFactory = new IpadAssetFactory();
		public function AssetManager()
		{
			
		}
		
		public static function getInstance():AssetManager {
			if (instance == null) {
				instance = new AssetManager();
			}
			return instance;
		}
		
		public function init():void {
			
			var dtype : String = DeviceInfo.getDeviceType();
			trace("type : " + dtype);
			if(dtype.indexOf("iphone") != -1){
				curAssetFactory = new IphoneAssetFactory();
				curAssetFactory.init();
			}else{
				curAssetFactory = ipadAssetFactory;
				curAssetFactory.init();
			}
		}
		
		public function getTexture(name : String):Texture {
			if (curAssetFactory) {
				return curAssetFactory.getTexture(name);
			}
			return null;
		}
		
		public function getTextures(name:String):Vector.<Texture>
		{
			if (curAssetFactory) {
				return curAssetFactory.getTextures(name);
			}
			return null;
		}
	}
}