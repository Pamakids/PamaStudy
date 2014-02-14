package com.pamakids.weather.ui
{
    import com.greensock.TweenLite;
    import com.gslib.net.hires.debug.Stats;
    import com.pamakids.utils.DeviceInfo;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.AssetsFactory;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    
    import flash.events.Event;
    import flash.media.SoundChannel;
    import flash.utils.getTimer;
    
    import starling.animation.Juggler;
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    public class LoadingUI extends Sprite
    {
        
        public var callMusicRes : Function;
        
        private var bg : Quad;
        private var loadingImag : Image;
        
        private var oldTime : uint = 0;
        
        private var loadingBar : MovieClip;
        
        private var _juggler : Juggler = new Juggler();
        
        private var soundChannel : SoundChannel;
        
        private var count : int = 0;
        private var soundNameList : Array = ["plot0","plot1", "plot2","plot3"];
        private var curName : String = "";
        
        private var textureList : Array = ["LoadingPage0","LoadingPage1","LoadingPage2","LoadingPage3"];
        private var textures_iphone : Array = ["page0","page1","page2","page3"];
        
        private var skipBtn : Button;
        private var heartImg : Image;
        
        private var btn_yes : Button;
        
        private var resTextures : TextureAtlas;
        
        private var imgTexture : Texture;
        public function LoadingUI()
        {
            super();
            
            trace("loadingUI加载中 : " + Stats.tFps);
            bg = new Quad(1024,768,0x000000);
            addChild(bg);
            
            //resTextures = AssetsFactory.getInstance().getLoadingUITextures();
            loadingBar = new MovieClip(AssetManager.getInstance().getTextures("loading"));
            addChild(loadingBar);
            loadingBar.pivotX = loadingBar.width * 0.5;
            loadingBar.pivotY = loadingBar.height * 0.5;
            loadingBar.x = UICoordinatesFactory.getNewPosX(512);
            loadingBar.y = UICoordinatesFactory.getNewPosY(384);
            loadingBar.loop = true;
            _juggler.add(loadingBar);
            
            trace("加载中..........................");
            
            
            setImgTexture();
            loadingImag = new Image(imgTexture);
            addChild(loadingImag);
            
            var skipName : String;
            if (GameData.curLangage == "cn") {
                skipName = "skip";
            }else {
                skipName = "skipe";
            }
            skipBtn = new Button(AssetManager.getInstance().getTexture(skipName));
            addChild(skipBtn);
            skipBtn.pivotX = skipBtn.width * 0.5;
            skipBtn.pivotY = skipBtn.height * 0.5;
            skipBtn.x =	UICoordinatesFactory.getNewPosX(994) - skipBtn.width * 0.5;
            skipBtn.y = UICoordinatesFactory.getNewPosY(738) - skipBtn.height * 0.5;
            skipBtn.addEventListener(TouchEvent.TOUCH,onClickSkip)
            
            if (GameData.curLangage == "cn") {
                soundNameList = ["plot0","plot1", "plot2","plot3"];
            }else {
                soundNameList = ["plot_en0","plot_en1", "plot_en2","plot_en3"];
            }
            
            curName = soundNameList.shift();
            
            TweenLite.delayedCall(1.5,playSoundHandler);
            /*			soundChannel = SoundManager.getInstance().soundDic[curName].play(curName, 1);
                        soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE,onSoundComHandler);*/
            
            oldTime = getTimer();
            
            this.addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrameHandler);
            
            trace("加载完毕了么");
        }
        
        private function playSoundHandler():void{
            soundChannel = SoundManager.getInstance().soundDic[curName].play(curName, 1);
            soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE,onSoundComHandler);
        }
        
        //----------------------------
        private function setImgTexture():void {
            if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
                imgTexture = BitmapDataLibrary.getTexture(textureList.shift());
            }else {
                imgTexture = AssetManager.getInstance().getTexture(textures_iphone.shift());
            }
        }
        
        private function getLastTexture():void {
            if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
                imgTexture = BitmapDataLibrary.getTexture(textureList[textureList.length - 1]);
            }else {
                imgTexture = AssetManager.getInstance().getTexture(textures_iphone[textures_iphone.length - 1]);
            }
        }
        
        private var btnYesTexture : Texture;
        private var heartTexture : Texture;
        private function setBtnTexture():void {
            btnYesTexture = AssetManager.getInstance().getTexture("yes");
            heartTexture = AssetManager.getInstance().getTexture("heart");
        }
        
        //-----------------------------
        
        private function onClickSkip(e : TouchEvent):void 
        {
            var touch : Touch = e.getTouch(skipBtn);
            if (touch) {
                if (touch.phase == TouchPhase.ENDED) {
                    //跳到最后一张图片
                    
                    TweenLite.killDelayedCallsTo(playSoundHandler);
                    
                    getLastTexture();
                    loadingImag.texture = imgTexture;
                    creatHeart();
                    removeChild(skipBtn,true);
                    if(soundChannel){
                        soundChannel.stop();
                        soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, onSoundComHandler);
                    }
                    
                    curName = soundNameList[soundNameList.length - 1];
                    trace("curName : " + curName);
                    TweenLite.delayedCall(1.5,skipSoundHanlder);
                    
                    /*					delObject();
                                        GameData.loadingIsOk = true;
                                        GameData.canRunGame = true;*/
                }
            }
        
        }
        
        
        private function skipSoundHanlder():void{
            soundChannel = SoundManager.getInstance().soundDic[curName].play(curName, 1);
        }
        
        private function delObject():void {
            removeChild(skipBtn,true);
            if(soundChannel){
                soundChannel.stop();
                soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, onSoundComHandler);
            }
            loadingImag.dispose();
            if (btn_yes) {
                removeChild(btn_yes,true);
            }
            
            if (heartImg) {
                removeChild(heartImg,true);
            }
            
            removeChild(loadingImag);
        }
        
        private function onSoundComHandler(e : flash.events.Event):void 
        {
            count ++ ;
            trace("count : " + count);
            TweenLite.killDelayedCallsTo(playSoundHandler);
            if (soundNameList.length > 0) {
                trace("哈哈");
                curName = soundNameList.shift(); 
                soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE,onSoundComHandler);
                
                TweenLite.delayedCall(1.5,playSoundHandler);
                //soundChannel = SoundManager.getInstance().soundDic[curName].play(curName, 1);
                //soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE, onSoundComHandler);
                
                setImgTexture();
                loadingImag.texture = imgTexture;
                
                if (soundNameList.length == 0) {
                    skipBtn.visible = false;
                    creatHeart();
                }
            }else {
                trace("播放完毕了啊");
                soundChannel.stop();
                this.removeEventListeners();
                soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, onSoundComHandler);	
            }
        
        
        }
        
        //跳动的红心
        private function creatHeart():void 
        {
            setBtnTexture();
            btn_yes = new Button(btnYesTexture);
            addChild(btn_yes);
            btn_yes.x = UICoordinatesFactory.getNewPosX(503 + 70);
            btn_yes.y = UICoordinatesFactory.getNewPosY(456 + 50);
            btn_yes.addEventListener(starling.events.Event.TRIGGERED, onClickYesHandler);
            
            heartImg = new Image(heartTexture);
            heartImg.touchable = false;
            heartImg.pivotX = heartImg.width * 0.5;
            heartImg.pivotY = heartImg.height * 0.5;
            heartImg.x = UICoordinatesFactory.getNewPosX(464) + heartImg.width * 0.5;
            heartImg.y = UICoordinatesFactory.getNewPosY(490) + heartImg.height * 0.5;
            addChild(heartImg);
            
            TweenLite.to(heartImg, 0.5, { scaleX : 0.7, scaleY : 0.7, onComplete :movieOver, onCompleteParams : [0] } );
        
        }
        
        private function onReplayHandler():void 
        {
            TweenLite.to(heartImg, 0.5, { scaleX : 0.7, scaleY : 0.7, onComplete :movieOver, onCompleteParams : [0] } );
        }
        
        private function movieOver(value : int ):void 
        {
            if(value == 0){
                TweenLite.to(heartImg, 0.5, { scaleX : 1, scaleY : 1, onComplete :movieOver, onCompleteParams : [1] } );
            }else {
                TweenLite.delayedCall(1,onReplayHandler);
            }
        }
        
        private function onClickYesHandler(e : starling.events.Event):void 
        {
            delObject();
            TweenLite.killTweensOf(heartImg);
            TweenLite.killDelayedCallsTo(onReplayHandler);
            TweenLite.killDelayedCallsTo(playSoundHandler);
            TweenLite.killDelayedCallsTo(skipSoundHanlder);
            GameData.loadingIsOk = true;
            GameData.canRunGame = true;
        }
        
        private var tcount : int = 0;
        private function onEnterFrameHandler(e : starling.events.Event):void 
        {
            _juggler.advanceTime(0.03);
            if (getTimer() - oldTime >= 1000) {
                if(tcount == 0){
                    if (this.callMusicRes != null) {
                        trace("开始加载声音资源了 : " + Stats.tFps);
                        this.callMusicRes();
                    }
                    tcount ++;
                }
            }
        }
        
        public function destory():void {
            bg.dispose();
            loadingImag.dispose();
            if(heartImg){
                removeChild(heartImg,true);
            }
            this.dispose();
            loadingBar.dispose();
            _juggler.remove(loadingBar);
        
        }
    }
}

