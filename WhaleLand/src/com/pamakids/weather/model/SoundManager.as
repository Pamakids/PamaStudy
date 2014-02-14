package com.pamakids.weather.model 
{
    import com.gslib.net.hires.debug.Stats;
    
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    /**
     * ...
     * @author icekiller
     */
    public class SoundManager
    {
        
        public static const BGM_SUNNYDAY : String = "bgm_SunnyDay";
        public static const BGM_SUNNYNITE : String = "bgm_SunnyNite";
        public static const BGM_SNOWDAY : String = "bgm_SnowyDay";
        public static const BGM_SNOWNITE : String = "bgm_SnowyNite";
        
        public var bgSoundTransform : SoundTransform = new SoundTransform();
        
        public static var fileStr : String = "assets/music/";
        public static var soundList : Array = ["s1","s2","s3","s4","s5","s6","s7",
            "bgm_SunnyDay","bgm_SunnyNite","fishjump","fishin",
            "bird","light_on","light_off","meteor","pig_land",
            "pig_run","cloud","ice","wind","ice_creak",
            "newcloud","smallcloud","middlecloud","sun_big","sun_small","bigcloud",
            "snow_small", "snow_big", "tree", "owlSound", "fly2", "mailbox", "letter",
            "vane","signs","xueqiu","pig_skate","pig_sleep","pig_sad","pig_happy"];
        public var count : int = 0;
        
        private var soundChannel : SoundChannel = new SoundChannel();
        private var bgSoundChannel : SoundChannel = new SoundChannel();
        
        private var my_soundtransform : SoundTransform = new SoundTransform();
        
        public var cloudSoundTransform : SoundTransform = new SoundTransform();
        
        public var soundDic : Dictionary = new Dictionary();
        private var soundChannelDic : Dictionary = new Dictionary();
        
        private static var instance : SoundManager;
        
        private var callback : Function;
        
        private var soundTransFormDic : Dictionary = new Dictionary();
        
        // Sounds
        [Embed(source="/assets/music/btn_click.mp3")]
        private static const BtnClickSound:Class;
        
        [Embed(source="/assets/music/start_ui.mp3")]
        private static const startUISound:Class;
        
        [Embed(source="/assets/music/glass1.mp3")]
        private static const glass1Sound:Class;
        [Embed(source="/assets/music/glass2.mp3")]
        private static const glass2Sound:Class;
        [Embed(source="/assets/music/glass3.mp3")]
        private static const glass3Sound:Class;
        [Embed(source="/assets/music/glass4.mp3")]
        private static const glass4Sound:Class;
        [Embed(source="/assets/music/glass5.mp3")]
        private static const glass5Sound:Class;
        [Embed(source="/assets/music/glass6.mp3")]
        private static const glass6Sound:Class;
        
        
        [Embed(source="/assets/music/plot0.mp3")]
        private static const plot0Sound:Class;
        [Embed(source="/assets/music/plot1.mp3")]
        private static const plot1Sound:Class;
        [Embed(source="/assets/music/plot2.mp3")]
        private static const plot2Sound:Class;
        [Embed(source="/assets/music/plot3.mp3")]
        private static const plot3Sound:Class;
        
        
        [Embed(source="/assets/music/plot_en0.mp3")]
        private static const plotEn0Sound:Class;
        [Embed(source="/assets/music/plot_en1.mp3")]
        private static const plotEn1Sound:Class;
        [Embed(source="/assets/music/plot_en2.mp3")]
        private static const plotEn2Sound:Class;
        [Embed(source="/assets/music/plot_en3.mp3")]
        private static const plotEn3Sound:Class;
        
        //logo声音
        [Embed(source="/assets/music/logo.mp3")]
        private static const logoSound:Class;
        
        public function SoundManager( ) 
        {
            bgSoundTransform.volume = 0.4;
            cloudSoundTransform.volume = 0.3;
            my_soundtransform.volume = 0.8;
        }
        
        public function stopAllSound():void {
            trace("停止所有声音");
            
            var transform:SoundTransform=SoundMixer.soundTransform;
            transform.volume = 0;
            SoundMixer.soundTransform=transform;
        }
        
        public function startAllSound():void {
            trace("开启所有声音");
            
            var transform:SoundTransform=SoundMixer.soundTransform;
            transform.volume = 1;
            SoundMixer.soundTransform=transform;
        }
        
        //预加载用到的音效
        public function prepareSounds():void
        {
            
            
            soundDic["btn_click"] = new BtnClickSound();   
            soundDic["start_ui"] = new startUISound();
            soundDic["plot0"] = new plot0Sound();
            soundDic["plot1"] = new plot1Sound();   
            soundDic["plot2"] = new plot2Sound(); 
            soundDic["plot3"] = new plot3Sound(); 
            
            soundDic["plot_en0"] = new plotEn0Sound(); 
            soundDic["plot_en1"] = new plotEn1Sound();   
            soundDic["plot_en2"] = new plotEn2Sound();
            soundDic["plot_en3"] = new plotEn3Sound();
            
            soundDic["glass1"] = new glass1Sound(); 
            soundDic["glass2"] = new glass2Sound(); 
            soundDic["glass3"] = new glass3Sound(); 
            soundDic["glass4"] = new glass4Sound(); 
            soundDic["glass5"] = new glass5Sound(); 
            soundDic["glass6"] = new glass6Sound(); 
            
            soundDic["logo"] = new logoSound();
        }                                                                                                                                                                                                    
        
        public function setCallBack(func : Function):void {
            this.callback = func;
        }
        
        /**
         * 预加载音乐
         */
        public function loadMusic():void {
            
            var fileStr : String = "assets/music/" + soundList[count] + ".mp3";
            trace("fileStr : " + fileStr + " fps : " + Stats.tFps);
            var sound : Sound = new Sound();
            var req : URLRequest = new URLRequest(fileStr); 
            sound.load(req);
            sound.addEventListener(Event.COMPLETE, soundLoadCompleteHandler);
            soundDic[soundList[count]] = sound;
        }
        
        /**
         * 同步加载
         */
        public function loadMusicSyc(path : String, name : String):void {
            if (soundDic[name]) {
                soundDic[name].play(0, 1);
            }else{
                var sound : Sound = new Sound();
                var req : URLRequest = new URLRequest(path + name + ".mp3"); 
                sound.load(req);
                sound.addEventListener(Event.COMPLETE, soundCompleteHandler);
                soundDic[name] = sound;
                function soundCompleteHandler(e : Event):void {
                    sound.play(0,1);
                }
            }
        }
        
        private function soundLoadCompleteHandler(e:Event):void 
        {
            //trace("音乐家在完毕了");
            if (count < soundList.length - 1) {
                count ++;
                e.currentTarget.removeEventListener(Event.COMPLETE, soundLoadCompleteHandler);
                loadMusic();
            }else {
                if (this.callback != null) {
                    this.callback();
                }
            }
        }
        
        public function play(soundStr : String, playNum : int = 1, playpos : Number = 0,soundTransform : SoundTransform = null):void {
            soundChannel = soundDic[soundStr].play(playpos, playNum);
            if(soundTransform == null){
                soundChannel.soundTransform = my_soundtransform;
            }else {
                soundChannel.soundTransform = soundTransform;
            }
            soundChannelDic[soundStr] = soundChannel;
        
        }
        
        public function stop(soundStr : String):void {
            if (soundChannelDic[soundStr]) {
                soundChannelDic[soundStr].stop();
            }
        
        }
        
        private function onCompleteHandler(e:Event):void 
        {
            trace("soundcom : " + e.target);
        }
        
        public function playBgMusic(soundStr : String, playNum : int = 1, soundTransform : SoundTransform = null):void {
            bgSoundChannel = soundDic[soundStr].play(0, playNum);
            bgSoundChannel.soundTransform = soundTransform;
        }
        
        public static function getInstance():SoundManager {
            if (instance == null) {
                instance = new SoundManager();
            }
            return instance;
        }
        public function stopBgMusic(soundStr : String):void {
            {
                bgSoundChannel.stop();
            }
        }
    
    }

}

