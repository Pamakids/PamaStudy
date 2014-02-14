package com.pamakids.weather.factory
{
    import flash.display.Bitmap;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    import starling.extensions.ATextureAtlas;
    import starling.textures.Texture;
    
    public class IpadAssetFactory implements IAssetFactory
    {
        //ui
        /*		[Embed(source = "/assets/ui/startbg_day.jpg")]
                private static const BgDay:Class;
                [Embed(source = "/assets/ui/startbg_night.jpg")]
                private static const BgNight:Class;
        
                public static const BGFOG : String = "bgFog";
                [Embed(source = "/assets/ui/start_day.png")]
                 private static const BgFog:Class;
        
                public static const BGFOG_NIGHT : String = "bgFog_night";
                [Embed(source = "/assets/ui/start_night.png")]
                private static const BgFogNight:Class;*/
        
        //天空
        /*		[Embed(source = "/assets/bg/daySky.png")]
                private static const DaySky:Class;
                [Embed(source = "/assets/bg/nightsky.png")]
                private static const NightSky:Class;*/
        
        //loadingUI
        /*		[Embed(source = "/assets/ui/page0.jpg")]
                private static const LoadingPage0 : Class;
                [Embed(source = "/assets/ui/page1.jpg")]
                private static const LoadingPage1 : Class;
                [Embed(source = "/assets/ui/page2.jpg")]
                private static const LoadingPage2 : Class;
                [Embed(source = "/assets/ui/page3.jpg")]
                private static const LoadingPage3 : Class;*/
        
        
        //asset1
        [Embed(source = "/assets/sprrow/asset1.xml", mimeType = "application/octet-stream")]
        static public const Asset1XML:Class;
        [Embed(source = "/assets/sprrow/asset1.png")]
        static public const Asset1GFX:Class;
        //asset2
        [Embed(source = "/assets/sprrow/asset3.xml", mimeType = "application/octet-stream")]
        static public const Asset2XML:Class;
        [Embed(source = "/assets/sprrow/asset3.png")]
        static public const Asset2GFX:Class;
        //asset3
        [Embed(source = "/assets/sprrow/asset4.xml", mimeType = "application/octet-stream")]
        static public const Asset3XML:Class;
        [Embed(source = "/assets/sprrow/asset4.png")]
        static public const Asset3GFX:Class;
        //asset4
        [Embed(source = "/assets/sprrow/asset6.xml", mimeType = "application/octet-stream")]
        static public const Asset4XML:Class;
        [Embed(source = "/assets/sprrow/asset6.png")]
        static public const Asset4GFX:Class;
        //pig
        [Embed(source = "/assets/sprrow/pig.xml", mimeType = "application/octet-stream")]
        static public const PigXML:Class;
        [Embed(source = "/assets/sprrow/pig.png")]
        static public const PigGFX:Class;
        
        /*		//粒子
                [Embed(source = '/assets/sprrow/particle.png')]
                private static const particle_png : Class;
                [Embed(source = '/assets/sprrow/particle.pex',mimeType="application/octet-stream")]
                private static const particle_pex : Class;
        
                //火
                [Embed(source = '/assets/sprrow/fireparticle.pex',mimeType="application/octet-stream")]
                private static const fireparticle_pex : Class;*/
        
        private var mTextureAtlasDic : Dictionary;
        private var mTextureDic : Dictionary;
        private var mTexturesDic : Dictionary;
        
        private var sTextures : Dictionary;
        
        private var mTextureNameDic : Dictionary;
        
        public function IpadAssetFactory()
        {
            mTextureAtlasDic = new Dictionary();
            mTextureDic = new Dictionary();
            mTexturesDic = new Dictionary();
            sTextures = new Dictionary();
            
            mTextureNameDic = new Dictionary();
        }
        
        public function init():void {
            addTextureAtlas("asset1",getMTexture("Asset1GFX"),XML(new Asset1XML()));
            addTextureAtlas("asset2",null,XML(new Asset2XML()));
            addTextureAtlas("asset3",null,XML(new Asset3XML()));
            addTextureAtlas("asset4", null, XML(new Asset4XML()));
            addTextureAtlas("pig", null, XML(new PigXML()));
            
            mTextureNameDic["asset1"] = "Asset1GFX";
            mTextureNameDic["asset2"] = "Asset2GFX";
            mTextureNameDic["asset3"] = "Asset3GFX";
            mTextureNameDic["asset4"] = "Asset4GFX";
            mTextureNameDic["pig"] = "PigGFX";
        /*			addTextureAtlas("asset2",getMTexture("Asset2GFX"),XML(new Asset2XML()));
                    addTextureAtlas("asset3",getMTexture("Asset3GFX"),XML(new Asset3XML()));
                    addTextureAtlas("asset4",getMTexture("Asset4GFX"),XML(new Asset4XML()));
                    addTextureAtlas("pig",getMTexture("PigGFX"),XML(new PigXML()));*/
        }
        
        public function getMTexture(name:String) : Texture
        {
            if (sTextures[name] == undefined)
            {
                var data:Object = new IpadAssetFactory[name]();
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

