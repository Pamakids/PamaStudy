package com.pamakids.weather.factory
{
	import com.pamakids.utils.Screen;
	import com.urbansquall.ginger.tools.IBitmapDataLibrary;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class BitmapDataLibrary implements IBitmapDataLibrary
	{
		
		//粒子
		[Embed(source = '/assets/sprrow/particle.png')]
		private static const particle_png : Class;
		[Embed(source = '/assets/sprrow/particle.pex',mimeType="application/octet-stream")]
		private static const particle_pex : Class;
		//火
		[Embed(source = '/assets/sprrow/fireparticle.pex',mimeType="application/octet-stream")]
		private static const fireparticle_pex : Class;
		
		//UI开始界面
		[Embed(source = "/assets/ui/startbg_day.jpg")]
        private static const BgDay:Class;
		[Embed(source = "/assets/ui/startbg_night.jpg")]
        private static const BgNight:Class;
		
		public static const BGFOG : String = "bgFog";
		[Embed(source = "/assets/ui/start_day.png")]
		 private static const BgFog:Class;
		
		public static const BGFOG_NIGHT : String = "bgFog_night";
		[Embed(source = "/assets/ui/start_night.png")]
		private static const BgFogNight:Class;
		
		[Embed(source = "/assets/ui/frontbg.png")]
		private static const FrontBg : Class;
		
		
		//天空
		[Embed(source = "/assets/bg/daySky.png")]
        private static const DaySky:Class;
		[Embed(source = "/assets/bg/nightsky.png")]
        private static const NightSky:Class;
		
		
		//loadingUI
		[Embed(source = "/assets/ui/page0.jpg")]
		private static const LoadingPage0 : Class;
		[Embed(source = "/assets/ui/page1.jpg")]
		private static const LoadingPage1 : Class;
		[Embed(source = "/assets/ui/page2.jpg")]
		private static const LoadingPage2 : Class;
		[Embed(source = "/assets/ui/page3.jpg")]
		private static const LoadingPage3 : Class;
		
		//mojoylogo
		[Embed(source = "/assets/ui/logo.png")]
		private static const MojoyLogo : Class;
		[Embed(source = "/assets/ios/logo_iphone.png")]
		private static const MojoyIphoneLogo : Class;
		
		
		
		
		
		
		//asset3
		
		
		static public const IOSBG_FOG : String = "ios_bgFog";
		[Embed(source = "/assets/ios/start_day.png")]
		static public const IosStartDayGFX:Class;
		
		static public const IOSBG_NIGHT_FOG : String = "ios_bgNightFog";
		[Embed(source = "/assets/ios/start_night.png")]
		static public const IosStartNightGFX:Class;
		
		
		
		
		private static var iosAsset1Atlas : TextureAtlas;
		private static var iosAsset2Atlas : TextureAtlas;
		private static var iosAsset3Atlas : TextureAtlas;
		
		
		private static var sTextures : Dictionary = new Dictionary();
		private static var sTextureAtlas:TextureAtlas;
		private static var allTextureAtlas : TextureAtlas;
		
		private static var pigTexturesAtlas : TextureAtlas;
		
		private static var asset1TexturesAtlas : TextureAtlas;
		private static var asset2TexturesAtlas : TextureAtlas;
		private static var asset3TextureAlts : TextureAtlas;
		
		
		private static var wishListTextureAlts : TextureAtlas;
		private static var fireworksTextureAlts : TextureAtlas;
		private static var SnowManTexturesAtlas : TextureAtlas;
		
		
		
		
		
		public static function resetData():void {
			
		}
		
		
		
		public static function getparticleXML():XML {
			return new XML(new particle_pex());
		}
		
		public static function getparticleTexture() : Texture {
			if (sTextures["particle"] == undefined) {
				sTextures["particle"] = Texture.fromBitmap(new particle_png());
			}
			return sTextures["particle"];
		}
		
		public static function getFireParticleXml():XML {
			return new XML(new fireparticle_pex());
		}
		
		//wishList
		public static function getWishListAtlas() : TextureAtlas {
			if(wishListTextureAlts){
	
			}else{
			}

			return wishListTextureAlts;
		}
		
		
		
		
		public static function getAllAtlas():TextureAtlas {
			return allTextureAtlas;
		}
		
		//获得材质
		public static function getTexture(name:String) : Texture
        {
            if (sTextures[name] == undefined)
            {
                var data:Object = new BitmapDataLibrary[name]();
                if (data is Bitmap)
                    sTextures[name] = Texture.fromBitmapData((data as Bitmap).bitmapData,false);
                else if (data is ByteArray)
                    sTextures[name] = Texture.fromAtfData(data as ByteArray);
            }
            return sTextures[name];
        }

		public function lookupBitmapData(a_bitmap:String):BitmapData
		{
			switch( a_bitmap )
			{
				case BGFOG :
					return new BgFog().bitmapData;
					break;
				case BGFOG_NIGHT :
					return new BgFogNight().bitmapData;
					break;
				case IOSBG_FOG :
					return new IosStartDayGFX().bitmapData;
					break;
				case IOSBG_NIGHT_FOG : 
					return new IosStartNightGFX().bitmapData;
					break;
				case "MojoyLogo":
					return new MojoyLogo().bitmapData;
					break;
				case "MojoyIphoneLogo":
					return new MojoyIphoneLogo().bitmapData;
					break;
			}
			return null;
		}
		
	}
}