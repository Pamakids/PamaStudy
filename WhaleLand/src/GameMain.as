package
{
    import com.gslib.net.hires.debug.Stats;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.PluginsID;
    import com.pamakids.uimanager.UIGlobal;
    import com.pamakids.uimanager.UILayer;
    import com.pamakids.uimanager.UIManager;
    import com.pamakids.utils.dinput.Accel;
    import com.pamakids.utils.dinput.Micropoe;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.items.StartUI;
    import com.pamakids.weather.model.AnalyticsUtils;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    import com.pamakids.weather.plugins.LandPlugin;
    import com.pamakids.weather.plugins.MarinePlugin;
    import com.pamakids.weather.plugins.SkyPlugins;
    import com.pamakids.weather.ui.AboutUI;
    import com.pamakids.weather.ui.LoadingUI;
    import com.pamakids.weather.ui.MenuUI;
    import com.pamakids.weather.ui.WishListUI;
    
    import flash.events.TimerEvent;
    import flash.media.SoundMixer;
    import flash.system.Capabilities;
    import flash.system.System;
    import flash.text.TextField;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import models.PosVO;
    
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    
    
    
    public class GameMain extends Sprite
    {
        private var startUI : StartUI;
        private var aboutUI : AboutUI;
        private var loadingUI : LoadingUI;
        private var wishListUI : WishListUI;
        
        //麦克风和重力感应是否启动
        private var isMicStarted : Boolean = false;
        
        private var txt : flash.text.TextField = new flash.text.TextField();
        
        
        private var oldTime : uint = 0;
        
        private var menu : MenuUI;
        
        private var soundHasLoad : Boolean = false;
        
        private var heartTime : uint = 0;
        
        private var isReplay : Boolean = false;
        
        public function GameMain()
        {
            super();
            
            this.scaleX=this.scaleY=PosVO.scale;
            
            trace("ios : " + Capabilities.os);
            
            var oldTime : uint = getTimer();
            
            AssetManager.getInstance().init();
            trace("passTime : " + (getTimer() - oldTime));
            //记录启动时间
            creatMainUI();
            Micropoe.init();
            AnalyticsUtils.init();
            
            
            menu = new MenuUI();
            menu.init();
            menu.callBack = returnMainUI;
            menu.callWishList = openWishListUI;
            addChild(menu);
            menu.visible = false;
            
            this.addEventListener(TouchEvent.TOUCH, onTouchMenuHandler);
            
            GameData.startUIIsOK = true;		
        }
        
        private function onTouchMenuHandler(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(this);
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    if (menu.isClicked(touch.target)) {
                        
                    }else {
                        menu.resetPos();
                    }
                }
            }
        }
        
        //打开wishListUI界面
        private function openWishListUI():void 
        {
            trace("打开wishList面板");
            this.setChildIndex(wishListUI,this.numChildren - 1);
            wishListUI.init();
        }
        
        private function creatMainUI():void {
            startUI = new StartUI();
            startUI.init();
            startUI.callAboutUI = loadAboutUI;
            startUI.callBack = startGame;
            addChild(startUI);
            
            aboutUI = new AboutUI();
            aboutUI.installation();
            aboutUI.hide();
            aboutUI.visible = false;
            aboutUI.show();
            aboutUI.callReturn = returnStartUI;
            addChild(aboutUI);
            
            
            wishListUI = new WishListUI();
            addChild(wishListUI);
        
        /*			var help : Help = new Help();
                    addChild(help);
                    help.init();*/
        }
        
        //关于我们
        private function loadAboutUI():void 
        {	
            startUI.denabled();
            aboutUI.visible = true
            aboutUI.show();
            this.addChildAt(aboutUI,this.numChildren - 1);
        }
        
        //返回主界面
        private function returnStartUI():void 
        {
            startUI.enabled();
            aboutUI.hide();
        }
        
        //开始游戏
        private function startGame():void 
        {
            startUI.destroy();
            startUI.visible = false;
            if(aboutUI){
                aboutUI.visible = false;
            }
            
            System.gc();
            
            trace("开始游戏 : " + " fps : " + Stats.tFps);
            
            if(isReplay == false){
                //ui初始化
                initLayer();
                //注册各插件
                registeredPlugin();
                    //显示loading界面
                    //加载音乐
            }
            loadMusic();
            
            //菜单栏
            this.setChildIndex(menu,this.numChildren - 1);
        }
        
        private function returnMainUI():void 
        {
            
            trace("返回了");
            isReplay = true;
            
            removeEventListener(Event.ENTER_FRAME, update);
            //停止所有声音
            SoundMixer.stopAll();
            //数据初始化
            menu.visible = false;
            GameData.initData();
            BitmapDataLibrary.resetData();
            /*			//删除各插件
                        PluginControl.LogoutPlugin(PluginsID.LAND_PLUGIN);
                        PluginControl.LogoutPlugin(PluginsID.MARINE_PLUGIN);
                        PluginControl.LogoutPlugin(PluginsID.SKY_PLUGIN);
                        //删除事件
            
                        //删除对象
                        UIManager.RemoveAllLayers();
                        trace("返回主界面");*/
            
            UIManager.hideAllLayers();
            if(aboutUI){
                aboutUI.show();
            }
            startUI.visible = true;
            startUI.start();
            menu.reset();
            SoundManager.getInstance().startAllSound();
            
            this.setChildIndex(startUI,this.numChildren - 1);
            
            System.gc();
        }
        
        private function loadMusic():void 
        {
            trace("开始加载加载界面 : " + Stats.tFps);
            loadingUI = new LoadingUI();
            loadingUI.callMusicRes = loadMusicHandler;
            addChild(loadingUI);
        }
        
        private function loadMusicHandler():void 
        {
            trace("开始加载音乐...... : " + Stats.tFps);
            if(soundHasLoad == false){
                SoundManager.getInstance().loadMusic();
                SoundManager.getInstance().setCallBack(loadGameRes);
            }else {
                loadGameRes();
            }
        }
        
        
        private var timer : Timer;
        
        //加载游戏素材
        private function loadGameRes():void 
        {
            soundHasLoad = true;
            
            timer = new Timer(1000, 1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComHandler);
            timer.start();
            
            trace("加载音乐完毕...... : " + Stats.tFps);
        
        }
        
        private function onTimerComHandler(e:TimerEvent):void 
        {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComHandler);
            timer = null;
            
            
            
            if(isReplay == false){
                trace("加载音乐完毕wwwwwww...... : " + Stats.tFps);
                BitmapDataLibrary.getAllAtlas();
                PluginControl.Start();
            }
            this.setChildIndex(loadingUI,this.numChildren - 1);
            addEventListener(Event.ENTER_FRAME, update);
        }
        
        //刷新
        private function update(e:Event):void 
        {	
            if (GameData.allResIsOK && GameData.canRunGame) {
                
                if (GameData.loadingIsOk) {
                    trace("可以进入游戏了");
                    loadingUI.destory();
                    removeChild(loadingUI,true);
                    GameData.loadingIsOk = false;
                    
                    menu.visible = true;
                    
                    if (!isMicStarted) {
                        Accel.init();
                        
                        isMicStarted = true;
                    }
                    
                    UIManager.showAllLayers();
                    
                    if (isReplay) {
                        PluginControl.GetPluginByID(PluginsID.SKY_PLUGIN).ReStart();
                        PluginControl.GetPluginByID(PluginsID.LAND_PLUGIN).ReStart();
                        PluginControl.GetPluginByID(PluginsID.MARINE_PLUGIN).ReStart();
                        
                        UIManager.GetLayer(UIGlobal.BACKGROUND0_LAYER).touchable = true;
                        UIManager.GetLayer(UIGlobal.BACKGROUND1_LAYER).touchable = true;
                        UIManager.GetLayer(UIGlobal.BACKGROUND2_LAYER).touchable = true;
                        UIManager.GetLayer(UIGlobal.BACKGROUND3_LAYER).touchable = true;
                        UIManager.GetLayer(UIGlobal.BACKGROUND2_LAYER).visible = true;
                    }
                    
                    SoundManager.getInstance().startAllSound();
                    GameData.curBgMusic = SoundManager.BGM_SUNNYDAY;
                    SoundManager.getInstance().playBgMusic(SoundManager.BGM_SUNNYDAY, 1000,SoundManager.getInstance().bgSoundTransform);
                }
                PluginControl.GetPluginByID(PluginsID.SKY_PLUGIN).Update();
                PluginControl.GetPluginByID(PluginsID.LAND_PLUGIN).Update();
                PluginControl.GetPluginByID(PluginsID.MARINE_PLUGIN).Update();
            }
        }
        
        private function registeredPlugin():void {
            PluginControl.RegisterPlugin(new SkyPlugins());
            PluginControl.RegisterPlugin(new LandPlugin());
            PluginControl.RegisterPlugin(new MarinePlugin());
        }
        
        private function initLayer():void
        {
            UIManager.SetUIParent(this);// 设置需要管理UI的Sprite
            UIManager.AddLayder(new UILayer(), UIGlobal.BACKGROUND0_LAYER);
            UIManager.AddLayder(new UILayer(), UIGlobal.BACKGROUND1_LAYER);
            UIManager.AddLayder(new UILayer(), UIGlobal.BACKGROUND2_LAYER);
            UIManager.AddLayder(new UILayer(), UIGlobal.BACKGROUND3_LAYER);
            UIManager.AddLayder(new UILayer(), UIGlobal.BACKGROUND4_LAYER);
            UIManager.AddLayder(new UILayer(), UIGlobal.TOP_LAYER);
        }
    
    
    }
}

