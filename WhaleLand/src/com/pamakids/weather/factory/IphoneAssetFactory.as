package com.pamakids.weather.factory
{
	import com.adobe.utils.DictionaryUtil;
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import starling.extensions.ATextureAtlas;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import flash.utils.getTimer;
	
	public class IphoneAssetFactory implements IAssetFactory
	{
		
		[Embed(source = "/assets/ios/asset1.xml", mimeType = "application/octet-stream")]
		static public const IosAsset1XML:Class;
		[Embed(source = "/assets/ios/asset1.png")]
		static public const IosAsset1GFX:Class;
		
		[Embed(source = "/assets/ios/asset2.xml", mimeType = "application/octet-stream")]
		static public const IosAsset2XML:Class;
		[Embed(source = "/assets/ios/asset2.png")]
		static public const IosAsset2GFX:Class;
		
		
		private var mTextureAtlasDic : Dictionary;
		private var mTextureDic : Dictionary;
		private var mTexturesDic : Dictionary;
		
		private var sTextures : Dictionary;
		
		private var mTextureNameDic : Dictionary;
		
		public function IphoneAssetFactory()
		{
			mTextureAtlasDic = new Dictionary();
			mTextureDic = new Dictionary();
			mTexturesDic = new Dictionary();
			sTextures = new Dictionary();
			
			mTextureNameDic = new Dictionary();
		}
		
		public function init():void {
			addTextureAtlas("asset1",getMTexture("IosAsset1GFX"),XML(new IosAsset1XML()));
			addTextureAtlas("asset2",null,XML(new IosAsset2XML()));
			
			mTextureNameDic["asset1"] = "IosAsset1GFX";
			mTextureNameDic["asset2"] = "IosAsset2GFX";
		}
		
		public function getMTexture(name:String) : Texture
        {
            if (sTextures[name] == undefined)
            {
                var data:Object = new IphoneAssetFactory[name]();
                if (data is Bitmap)
                    sTextures[name] = Texture.fromBitmapData((data as Bitmap).bitmapData,false);
                else if (data is ByteArray)
                    sTextures[name] = Texture.fromAtfData(data as ByteArray);
            }
            return sTextures[name];
        }
		
		public function addTextureAtlas(name:String, texture:Texture, atlasXml:XML):void
		{	
			mTextureAtlasDic[name] = new ATextureAtlas(texture,atlasXml);
		}
		
		public function getTexture(name:String):Texture
		{
			if (mTextureDic[name]) {
				
			}else {
				var taltsName : String = getTexturesAtlasName(name);
				if ((mTextureAtlasDic[taltsName] as ATextureAtlas).mAtlasTexture == null) {
					(mTextureAtlasDic[taltsName] as ATextureAtlas).mAtlasTexture = getMTexture(mTextureNameDic[taltsName]);
				}
				mTextureDic[name] = (mTextureAtlasDic[taltsName] as ATextureAtlas).getTexture(name);
			}
			return mTextureDic[name];
		}
		
		public function getTextures(name:String):Vector.<Texture>
		{
			if (mTexturesDic[name]) {
				
			}else {
				var taltsName : String = getTexturesName(name);
				if ((mTextureAtlasDic[taltsName] as ATextureAtlas).mAtlasTexture == null) {
					(mTextureAtlasDic[taltsName] as ATextureAtlas).mAtlasTexture = getMTexture(mTextureNameDic[taltsName]);
				}
				mTexturesDic[name] = (mTextureAtlasDic[taltsName] as ATextureAtlas).getTextures(name);
			}
			return mTexturesDic[name];
		}
		
		private function getTexturesAtlasName(name : String):String {
			var dic : Dictionary;
			for (var k : String in mTextureAtlasDic) {
				dic = (mTextureAtlasDic[k] as ATextureAtlas).mTextureNames;	
				if (dic[name]) {
					return k;
					break;
				}
			}
			return "undefined";
		}
		
		private function getTexturesName(name : String):String {
			var dic : Dictionary;
			var len : int = 0;
			var oldTime : uint = getTimer();
			len = name.length;
			for (var k : String in mTextureAtlasDic) {
				dic = (mTextureAtlasDic[k] as ATextureAtlas).mTextureNames;	
				for (var m : String in dic) {
					if (m.substr(0, len) == name) {
						return k;
						break;
					}
				}
			}
			return "undefined";
		}
		
	}
}