package 
{	
    import com.gslib.net.hires.debug.Stats;
    import com.pamakids.utils.DeviceInfo;
    import com.pamakids.utils.LogUI;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.factory.AssetsFactory;
    import com.pamakids.weather.factory.ResLoader;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    import com.pamakids.weather.ui.AboutUI;
    import com.urbansquall.metronome.Ticker;
    
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.system.Capabilities;
    
    import as3logger.Logger;
    
    import models.PosVO;
    
    import starling.core.Starling;
    
    [SWF(width="1024",height="768",backgroundColor="#000000",frameRate="60")]
    public class WinterOnWhaleIsland extends Sprite
    {
        public static  var m_ticker : Ticker;
        private var stats : Stats;
        protected var loader : Loader = new Loader();
        private var currentlyLoading : String;
        private var resLoader : ResLoader;
        
        private var lineSp : Sprite = new Sprite();
        
        private var loadingBar : LoadingBar;
        
        public static var isActive : Boolean = false;
        
        private var soundManger : SoundManager = new SoundManager();
        
        private var logo : MovieClip;
        
        private var logoIsOk : Boolean = false;
        
        private var resIsOK : Boolean = false;
        
        private var loadingBg : Shape = new Shape();
        
        private var aboutUI : AboutUI;
        
        private var mStarling : Starling;
        
        private var bgShape : Sprite;
        
        private var logUI : LogUI;
        
        public function WinterOnWhaleIsland()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, init);
        }
        private function init(e : flash.events.Event) : void{
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            
            PosVO.init(Capabilities.screenResolutionX,Capabilities.screenResolutionY);
            this.scaleX=this.scaleY=PosVO.scale;
            
            GameData.frameRate = stage.frameRate;
            
            Screen.stg =Screen.stage= stage;
            Screen.init();
            loadUI();
            
            stats = new Stats();
            //addChild(stats);
            stats.x = 1024 * Screen.wRatio - stats.width;
            
            logUI = new LogUI();
            logUI.installation(this);
            addChild(logUI);
            logUI.visible = false;
            logUI.mouseEnabled = false;
            
            Logger.log("width : " + Screen.wdth + "," + "height : " + Screen.hght,0);
            Logger.log("screen.scaleY : " + Screen.ratio,0);
            Logger.log("offX : ",0);
            Logger.log("deviceType : " + DeviceInfo.getDeviceType(), 0);
            Logger.log("ios : " + Capabilities.os, 0);
        
        }
        
        private function loadUI():void 
        {
            stage.frameRate = 30;
            
            SoundManager.getInstance().prepareSounds();
            
            var logoPos : Point = UICoordinatesFactory.getInstance().getUIPostion(UICoordinatesFactory.START_LOADING);
            logo = AssetsFactory.getInstance().getStartLoading();
            logo.x = logoPos.x;
            logo.y = logoPos.y;
            logo.mouseEnabled = false;
            logo.mouseChildren = false;
            addChild(logo);
            this.addEventListener(Event.ENTER_FRAME, onComHandler);
            
            SoundManager.getInstance().play("logo");
        
        }
        
        private function onComHandler(e : Event):void 
        {
            if (logo.currentFrame == logo.totalFrames) {
                this.removeEventListener(Event.ENTER_FRAME, onComHandler);
                logoIsOk = true;
                removeChild(logo);
                logo = null;
                initializeStarling();
            }
        }
        
        private function initializeStarling():void 
        {
            stage.frameRate = 60;
            Starling.multitouchEnabled = true;
            Starling.handleLostContext = false;
            mStarling = new Starling(GameMain, stage);
            mStarling.simulateMultitouch = true;
            mStarling.enableErrorChecking = false;
            mStarling.antiAliasing = 0;
            mStarling.start();
        }
    }
}

