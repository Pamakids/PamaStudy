package com.pamakids.weather.items
{
    import com.greensock.TweenLite;
    import com.greensock.easing.Bounce;
    import com.greensock.easing.Sine;
    import com.gslib.net.hires.debug.Stats;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.LoadSkyOtherItem;
    import com.pamakids.core.msgs.OpenMailMsg;
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.utils.Screen;
    import com.pamakids.utils.dinput.Accel;
    import com.pamakids.utils.dinput.MouseDown;
    import com.pamakids.utils.dinput.MouseMove;
    import com.pamakids.utils.dinput.MouseUp;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.GameStatic;
    import com.pamakids.weather.model.SoundManager;
    import com.urbansquall.ginger.Animation;
    import com.urbansquall.ginger.AnimationPlayer;
    import com.urbansquall.ginger.events.AnimationEvent;
    import com.urbansquall.ginger.events.FrameEvent;
    import com.urbansquall.ginger.tools.AnimationBuilder;
    import com.urbansquall.metronome.Ticker;
    import com.urbansquall.metronome.TickerEvent;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Scene;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.media.SoundChannel;
    import flash.system.System;
    import flash.text.TextField;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import adobe.utils.ProductManager;
    
    import models.PosVO;
    
    import starling.animation.Juggler;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.MovieClip;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    public class AnimalsItem extends UIBase implements IItem
    {	
        //需要重置的变量
        private var isActive : Boolean = false;
        private var vx : Number = -2;
        private var isMouseDown : Boolean = false;
        private var isDrag : Boolean = false;
        private var isInIce : Boolean = false;
        private var isRuning : Boolean = false;
        //是否在厚冰上
        private var isOnIce : Boolean = false;
        private var pigState : int = 0;
        private var bubblesStartTime : uint = 0;
        private var slidLen : int = 0;
        private var iceVx : Number = 0;
        private var oldTime : uint = 0;
        private var pigOldScaleX : Number = 1;
        private var oldSleepTime : uint = 0;
        private var m_pigPos : Point = new Point();
        
        private var bubblesTime : uint = 2000;
        private var pigDefaultY : int = 620;
        private var pigTexturesNames : Array = ["bugaoxing", "dongbing", "pao","pose","xiangxiaxue"];
        private var pig2TexturesNames : Array = ["huabing","zhushuijiao","wanchengrenwu"];
        private static const PIG_SAD : String = "bugaoxing";
        private static const PIG_ICE : String = "dongbing";
        private static const PIG_RUN : String = "pao";
        private static const PIG_SKATING : String = "huabing";
        private static const PIG_POSE : String = "pose";
        private static const PIG_THINK : String = "xiangxiaxue";
        private static const PIG_STAND : String = "changtai";
        private static const PIG_MELT : String = "ronghu";
        private static const PIG_FLOP : String = "lengchan";
        private static const PIG_SLEEP : String = "zhushuijiao";
        private static const PIG_HAPPY : String = "wanchengrenwu";
        
        private var _costumes:Object = {};
        private var pigTextureAlts : AssetManager;
        private var m_pig : MovieClip;
        private var curState : String = "changtai";
        private var _juggler : Juggler = new Juggler();
        private var bubbleItem : BubblesItem;
        private var pigTimer : Timer;
        
        public function AnimalsItem()
        {
            super();
        }
        
        public function init():void
        {	
            
            pigDefaultY *= Screen.ratio;
            
            runRect.x = UICoordinatesFactory.getNewPosX(runRect.x);
            runRect.y = UICoordinatesFactory.getNewPosY(runRect.y);
            
            bubbleItem = new BubblesItem();
            bubbleItem.init();
            bubbleItem.touchable = false;
            centerPivot(bubbleItem);
            addChild(bubbleItem);
            bubbleItem.visible = false;
            
            pigTextureAlts = AssetManager.getInstance();
            
            m_pig = new MovieClip(pigTextureAlts.getTextures(PIG_STAND));
            centerPivot(m_pig);
            m_pig.name = PIG_STAND;
            m_pig.data.ax = 0;
            _costumes[PIG_STAND] = m_pig;
            addChild(m_pig);
            m_pig.x = UICoordinatesFactory.getNewPosX(700);
            m_pig.y = pigDefaultY;
            m_pigPos.x = UICoordinatesFactory.getNewPosX(700);
            m_pigPos.y = pigDefaultY;
            
            m_pig.addEventListener(TouchEvent.TOUCH, onPigTouchHandler);
            m_pig.addEventListener(Event.COMPLETE, onMovieComHandler);
            
            oldTime = getTimer();
            this.addEventListener(Event.ENTER_FRAME, onLoadRes);
            
            pigTimer = new Timer(2000, 1);
            pigTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComHandler);
        }
        
        public function reStart():void {
            isActive = true;
        }
        
        public function reset():void {
            switchState(PIG_STAND);
            
            initData();
        }
        
        private function initData():void {
            isActive = false;
            vx = -2;
            isMouseDown = false;
            isDrag = false;
            isInIce = false;
            isRuning = false;
            //是否在厚冰上
            isOnIce = false;
            pigState = 0;
            bubblesStartTime = 0;
            slidLen = 0;
            iceVx = 0;
            oldTime = 0;
            pigOldScaleX = 1;
            oldSleepTime = 0;
            m_pigPos = new Point();
            
            bubbleItem.visible = false;
            m_pig.x = UICoordinatesFactory.getNewPosX(700);
            m_pig.y = pigDefaultY;
            m_pigPos.x = UICoordinatesFactory.getNewPosX(700);
            m_pigPos.y = pigDefaultY;
            pigTimer.stop();
            
            m_pig.scaleX = 1;
        
        }
        
        private function onTimerComHandler(e:TimerEvent):void 
        {
            trace("想什么呢..................");
            if (GameData.getCurDesire() != -1 && GameData.is2012 == false) {
                if(isOnIce == false){
                    if (m_pig.name == PIG_STAND) {
                        if(isDrag == false){
                            switchState(PIG_THINK);
                        }
                    }else if (m_pig.name == PIG_SLEEP) {
                        showBubbles();
                    }else if (m_pig.name == PIG_SAD || m_pig.name == PIG_POSE) {
                        switchState(PIG_THINK);
                    }
                }
                
            }else {
                if(m_pig.name == PIG_POSE || m_pig.name == PIG_SAD){
                    switchState(PIG_STAND);
                }
            }
        }
        
        //需要优化
        private function onMovieComHandler(e:Event):void 
        {	
            trace("猪动画播放完毕了 : " + m_pig.name);
            if (m_pig.name == PIG_SAD) {
                m_pig.stop();
                pigTimer.reset();
                pigTimer.start();
                //switchState(PIG_STAND);
                trace("开始冥想了么");
            }else if (m_pig.name == PIG_THINK) {
                trace("恢复到常态 : " + getTimer());
                m_pig.stop();
                if(actionQueue.length < 1){
                    switchState(PIG_STAND);
                }else {
                    switchState(actionQueue.shift());
                }
            }else if (m_pig.name == PIG_POSE) {
                if (GameData.is2012 == false) {
                    m_pig.stop();
                    
                    if(m_pig.data.type == -1){
                        switchState(PIG_STAND);
                    }else {
                        pigTimer.reset();
                        pigTimer.start();
                    }
                }else {
                    trace("小猪POSE");
                    m_pig.currentFrame = 8;
                }
            }else if (m_pig.name == PIG_MELT) {
                if(GameData.dayState == 0){
                    switchState(PIG_STAND);
                }else {
                    if(GameData.nightDesireList[1] == 0){
                        switchState(PIG_HAPPY);
                    }else {
                        switchState(PIG_SLEEP);
                        GameData.nightDesireList[2] = 1;
                        
                        GameData.setWishComTime(7,getTimer());
                    }
                }
            }else if (m_pig.name == PIG_SKATING) {
                switchState(PIG_STAND);
                SoundManager.getInstance().stop("pig_skate");
            }else if (m_pig.name == PIG_FLOP) {
                m_pig.data.playCount ++;
                if (m_pig.data.playCount >= 4) {
                    switchState(PIG_ICE);
                }
                trace("playCount : " + m_pig.data.playCount);
            }else if (m_pig.name == PIG_HAPPY) {
                switchState(PIG_STAND);
                if (GameData.getCurDesire() != -1) {
                    pigTimer.reset();
                    pigTimer.start();
                }
            }else if (m_pig.name == PIG_SLEEP) {
                pigTimer.reset();
                pigTimer.start();
            }
        }
        
        private function onPigTouchHandler(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(stage);
            
            var touchs : Vector.<Touch> = e.getTouches(stage);
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    resetSleepTime();
                    if(touchs.length == 1){
                        m_pig.data.offX = touch.globalX/PosVO.scale - m_pig.x;
                        m_pig.data.offY = touch.globalY/PosVO.scale - m_pig.y;
                    }
                }else if (touch.phase == TouchPhase.MOVED) {
                    isDrag = true;
                    resetSleepTime();
                    if(touchs.length == 1){
                        onMouseMoveHandler(touch);
                    }
                }else if (touch.phase == TouchPhase.ENDED) {
                    onPigClickHandler(touch);
                    onMouseUpHandler(touch);
                    resetSleepTime();
                }
            }
        }
        
        private function resetSleepTime():void {
            if (oldSleepTime != 0) {
                oldSleepTime = getTimer();
            }
        }
        
        private function onLoadRes(e:Event):void 
        {
            if (getTimer() - oldTime >= 500) {
                if (pigTexturesNames.length > 0) {
                    var itemName : String = pigTexturesNames.shift();
                    addCostume(itemName, pigTextureAlts.getTextures(itemName));
                }else {
                    
                    if (pig2TexturesNames.length > 0) {
                        var item2Name : String = pig2TexturesNames.shift();
                        addCostume(item2Name,pigTextureAlts.getTextures(item2Name));
                    }else {
                        this.removeEventListener(Event.ENTER_FRAME, onLoadRes);
                        loadResCom();
                        oldTime = getTimer();
                    }
                }
            }
        }
        
        private function addCostume(name:String, textures:Vector.<Texture>):void
        {	
            //_costumes||=new Object();
            var frames : int = 12;
            if (name == PIG_THINK || name == PIG_FLOP || name == PIG_HAPPY) {
                frames = 8;
            }
            _costumes[name]=new MovieClip(textures, frames);
            
            trace("name : " + name);
            var costume : MovieClip = _costumes[name] as MovieClip;
            costume.name = name;
            costume.data.ax = 0;
            centerPivot(costume);
        }
        
        private function centerPivot(obj : DisplayObject):void {
            obj.pivotX = obj.width / 2;
            obj.pivotY = obj.height / 2;
        }
        
        public function run():void {			
            if (m_pig.name == PIG_RUN) {
                
            }else {
                switchState(PIG_RUN);
                bubbleItem.visible = false;
                SoundManager.getInstance().play("pig_run",50);
            }
            isRuning = true;
        }
        
        public function stopRun():void {
            if (m_pig.name == PIG_RUN) {
                switchState(PIG_STAND);
                SoundManager.getInstance().stop("pig_run");
            }
            isRuning = false;
        }
        
        //颤抖
        public function trembling():void {
            switchState(PIG_ICE);
        }
        
        //常态
        public function resetPigAimation():void {
            switchState(PIG_STAND);
            SoundManager.getInstance().stop("pig_skate");
        }
        
        public function playPose():void {
            switchState(PIG_POSE);
            m_pig.loop = true;
        }
        
        //提醒小猪摆pose
        public function pigComeon():void {
            if (m_pig.name == PIG_STAND && isDrag == false) {
                switchState(PIG_POSE);
                m_pig.data.type = -1;
            }
        }
        
        
        public var loadOtherRes : Function;
        
        private function loadResCom( ):void 
        {	
            //融化
            var fireTxtures : Vector.<Texture> = pigTextureAlts.getTextures(PIG_ICE);
            //晚上冻冰前的打颤
            var floppingTextures : Vector.<Texture> = new Vector.<Texture>();
            for (var i : int = 0; i < 6;i ++ ) {
                floppingTextures.push(fireTxtures[i]);
            }
            addCostume(PIG_FLOP,floppingTextures);
            
            
            fireTxtures.reverse();
            addCostume(PIG_MELT, fireTxtures);
            
            
            m_pig.data.ax = 0;
            isActive = true;
            
            trace("小猪加载完毕 : " + Stats.tFps);
            
            if (this.loadOtherRes != null) {
                this.loadOtherRes();
            }
            //GameData.allResIsOK = true;
        }
        
        /**
         * 点击小猪
         * @param	e
         */
        private function onPigClickHandler(e : Touch):void 
        {
            if(isDrag == false){
                if (m_pig.name == PIG_STAND) {
                    if (GameData.dayDesireList[0] == 1) {
                        trace("点击小猪了么");
                        switchState(PIG_POSE);
                    }else {
                        trace("小猪叹气了");
                        switchState(PIG_SAD);
                    }
                    trace("anuantuibId : " + m_pig.name);
                }else if (m_pig.name == PIG_SLEEP) {
                    trace("猪由睡觉状态切换过来!");
                    switchState(PIG_STAND);
                    
                    //记录小猪被搞醒的时间
                    oldSleepTime = getTimer();
                    
                    //隐藏泡泡
                    bubbleItem.visible = false;
                }
            }
        }
        
        private function onMouseMoveHandler(e : Touch):void 
        {
            isDrag = true;
            if (m_pig.name == PIG_ICE || m_pig.name == PIG_FLOP) {
                var dy : int = e.globalY/PosVO.scale - e.previousGlobalY/PosVO.scale;
                var dx : int = e.globalX/PosVO.scale - e.previousGlobalX/PosVO.scale;
                if (e.target == m_pig) {
                    slidLen += (Math.abs(dx) + Math.abs(dy));
                    trace("slidLen : " + slidLen);
                    if(slidLen >= 200 * Screen.ratio){
                        if (slidLen >= 1000 * Screen.ratio) {
                            trace("小猪你可以融化了哈哈！");
                            slidLen = 0;
                            isInIce = false;
                            
                            if (GameData.nightDesireList[0] == 0) {
                                
                            }
                            GameData.nightDesireList[0] = 1;
                            
                            GameData.setWishComTime(5,getTimer());
                            
                            if(m_pig.isPlaying){
                                if (m_pig.name == PIG_FLOP) {
                                    switchState(PIG_STAND);
                                }
                            }else {
                                if(m_pig.name == PIG_ICE){
                                    switchState(PIG_MELT);
                                }
                            }
                        }else {
                            if (m_pig.isPlaying) {
                                if (m_pig.name == PIG_FLOP) {
                                    
                                    if (GameData.nightDesireList[0] == 0) {
                                        
                                    }
                                    GameData.nightDesireList[0] = 1;
                                    GameData.setWishComTime(5,getTimer());
                                    
                                    slidLen = 0;
                                    isInIce = false;
                                    switchState(PIG_STAND);
                                }
                            }
                        }
                    }
                }
                
            }else if (m_pig.name == PIG_STAND) {
                if (GameData.thinkIceIsOk) {
                    if (e.globalX/PosVO.scale - m_pig.data.offX - m_pig.width * 0.5 < 0) {
                        m_pig.x = m_pig.width * 0.5;
                    }else if (e.globalX/PosVO.scale - m_pig.data.offX + m_pig.width * 0.5 > Screen.wdth) {
                        m_pig.x = Screen.wdth - m_pig.width * 0.5;
                    }else {
                        m_pig.x = e.globalX/PosVO.scale - m_pig.data.offX;
                    }
                    
                    if (e.globalY/PosVO.scale - m_pig.data.offY - m_pig.height * 0.5 <= 0) {
                        m_pig.y = m_pig.height * 0.5;
                    }else if (e.globalY/PosVO.scale - m_pig.data.offY + m_pig.height * 0.5 >= Screen.hght) {
                        m_pig.y = 768 - m_pig.height * 0.5;
                    }else {
                        m_pig.y = e.globalY/PosVO.scale - m_pig.data.offY;
                    }
                }else {
                    if (e.globalX/PosVO.scale - m_pig.data.offX - m_pig.width * 0.5 < UICoordinatesFactory.getNewPosX(190)) {
                        m_pig.x = UICoordinatesFactory.getNewPosX(190) + m_pig.width * 0.5;
                    }else if (e.globalX/PosVO.scale - m_pig.data.offX + m_pig.width * 0.5 > UICoordinatesFactory.getNewPosX(900)) {
                        m_pig.x = UICoordinatesFactory.getNewPosX(900) - m_pig.width * 0.5;
                    }else {
                        m_pig.x = e.globalX/PosVO.scale - m_pig.data.offX;
                    }
                    
                    if (e.globalY/PosVO.scale - m_pig.data.offY - m_pig.height * 0.5 <= 0) {
                        m_pig.y = m_pig.height * 0.5;
                    }else if (e.globalY - m_pig.data.offY + m_pig.height * 0.5 >= Screen.hght) {
                        m_pig.y = 768 - m_pig.height * 0.5;
                    }else {
                        m_pig.y = e.globalY/PosVO.scale - m_pig.data.offY;
                    }
                }
                
            }
        }
        
        
        /**
         * Manages the various potential states of the mole.  Changes its costume and registers event handles as needed
         * @param state
         */
        private function switchState(state : String):void
        {
            //before changing states, see if there is anything that needs to be stopped/cleaned up from the last state
            cleanupLeaveState(state);
            switch (state)
            {
                case PIG_ICE:
                    switchCostume(PIG_ICE);
                    m_pig.loop = false;
                    m_pig.play();
                    break;
                case PIG_MELT :
                    switchCostume(PIG_MELT);
                    m_pig.loop = false;
                    m_pig.play();
                    break;
                case PIG_POSE:
                    SoundManager.getInstance().play("pig_happy");
                    switchCostume(PIG_POSE);
                    m_pig.loop = false;
                    m_pig.play();
                    break;
                
                case PIG_RUN:
                    switchCostume(PIG_RUN);
                    m_pig.loop=true;
                    m_pig.play();
                    break;
                
                case PIG_SAD:
                    SoundManager.getInstance().play("pig_sad");
                    switchCostume(PIG_SAD);
                    m_pig.loop=false;
                    m_pig.play();
                    break;
                
                case PIG_SKATING:
                    switchCostume(PIG_SKATING);
                    m_pig.loop=false;
                    m_pig.play();
                    break;
                
                case PIG_THINK:
                    PluginControl.BroadcastMsg(new OpenMailMsg());
                    switchCostume(PIG_THINK);
                    m_pig.loop = false;
                    m_pig.play();
                    break;
                case PIG_STAND:
                    isDrag = false;
                    switchCostume(PIG_STAND);
                    m_pig.loop = false;
                    break;
                case PIG_FLOP :
                    switchCostume(PIG_FLOP);
                    m_pig.loop = true;
                    m_pig.play();
                    break;
                case PIG_SLEEP :
                    SoundManager.getInstance().play("pig_sleep");
                    switchCostume(PIG_SLEEP);
                    m_pig.loop = false;
                    m_pig.play();
                    break;
                case PIG_HAPPY :
                    switchCostume(PIG_HAPPY);
                    m_pig.loop = false;
                    m_pig.play();
                    break;
                
            }
            //now set the official state
            curState = state;
        }
        
        private function cleanupLeaveState(state:String):void 
        {
            m_pig.removeEventListeners();
        }
        
        /**
         * Change to a new costume based on the a string key
         * @param name the string key that indicates the name of the MovieClip in the Object
         * @return A MovieClip of the selected costume
         */
        private function switchCostume(name:String):MovieClip
        {
            //stop the current costume from animating
            
            pigOldScaleX = m_pig.scaleX;
            m_pigPos.x = m_pig.x;
            m_pigPos.y = m_pig.y;
            _juggler.remove(m_pig);
            removeChild(m_pig);
            
            m_pig = _costumes[name];
            trace("switchName : " + name);
            addChild(m_pig);
            m_pig.data.playCount = 0;
            m_pig.data.type = 0;
            m_pig.stop();
            m_pig.scaleX = pigOldScaleX;
            m_pig.currentFrame = 0;
            m_pig.addEventListener(TouchEvent.TOUCH, onPigTouchHandler);
            m_pig.addEventListener(Event.COMPLETE, onMovieComHandler);
            if (name == PIG_ICE || name == PIG_MELT || name == PIG_SKATING || name == PIG_FLOP) {
                m_pig.pivotX = m_pig.width * 0.5 - 2 * Screen.ratio;
                m_pig.pivotY = m_pig.height * 0.5 + 10 * Screen.ratio;
            }else if(name == PIG_HAPPY){
                m_pig.pivotX = m_pig.width * 0.5 + 12 * Screen.ratio;
                m_pig.pivotY = m_pig.height * 0.5 + 22 * Screen.ratio;
            }else if (name == PIG_SLEEP) {
                m_pig.pivotX = m_pig.width * 0.5 + 8 * Screen.ratio;
                m_pig.pivotY = m_pig.height * 0.5 + 4 * Screen.ratio;
            }else {
                centerPivot(m_pig);
            }
            
            
            m_pig.x = m_pigPos.x;
            m_pig.y = m_pigPos.y;
            m_pig.data.ax = 0;
            //start the new costume animating
            _juggler.add(m_pig);
            return m_pig;
        }
        
        private function onFrameChangeHandler( ):void 
        {
            //trace("frame : " + e.animationID + " dsf : " + e.frameID + " mmm : " + e.animationID);
            
            if (m_pig.name == PIG_THINK && m_pig.currentFrame == 8) {
                m_pig.currentFrame = 9;
                m_pig.pause();
                showBubbles();
            }else if (m_pig.name == PIG_SKATING) {
                if (Math.abs(iceVx) < 1) {
                    
                }else {
                    
                }
                
            }
            
            if (GameData.is2012) {
                if (m_pig.name == PIG_ICE && m_pig.currentFrame == 6) {
                    m_pig.currentFrame = 0;
                }
            }
        }
        
        private function showBubbles():void {
            trace("出现思考的画面");
            
            if(m_pig.scaleX == 1){
                bubbleItem.x = m_pig.x;
                bubbleItem.scaleX = 1;
            }else if(m_pig.scaleX == -1){
                bubbleItem.x = m_pig.x;
                bubbleItem.scaleX = -1;
            }
            bubbleItem.y = m_pig.y - m_pig.height * 0.5 + 20 * Screen.ratio;
            var curAindex : int = GameData.getCurDesire();
            if(curAindex != -1){
                bubbleItem.gotoAndStop(curAindex);
                bubbleItem.visible = true;
            }
            bubblesStartTime = getTimer();
            
            //全局广播时间重置
            oldTime = getTimer();
        }
        
        
        private function onMouseUpHandler(e : Touch):void 
        {
            if (isDrag) {
                
                trace("m_pig.name : " + m_pig.name);
                if (m_pig.name == PIG_STAND) {
                    
                    if (GameData.thinkIceIsOk) {
                        if (m_pig.y > 690 * Screen.ratio) {
                            TweenLite.to(m_pig, 1, { y:690 * Screen.ratio,ease:Bounce.easeOut, onComplete : tweenCom } );
                        }else {
                            TweenLite.to(m_pig, 1, { y:pigDefaultY, ease:Bounce.easeOut, onComplete : tweenCom } );
                            SoundManager.getInstance().play("pig_land");
                        }
                    }else {
                        SoundManager.getInstance().play("pig_land");
                        TweenLite.to(m_pig, 1, { y:pigDefaultY, ease:Bounce.easeOut, onComplete : tweenCom } );
                    }
                    
                    
                }else if (m_pig.name == PIG_ICE) {
                    //pigAnimationPlayer.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMoveHandler);
                }else if (m_pig.name == PIG_SLEEP) {
                    isDrag = false;
                }
                
            }
        }
        
        private function tweenCom():void {
            isDrag = false;
            if (isInIce) {
                switchState(PIG_FLOP);
                isInIce = false;
            }
        }
        
        
        public function updateThink():void {
            if (GameData.getCurDesire() != -1) {
                if(isOnIce == false){
                    if (m_pig.name == PIG_STAND && isDrag == false) {
                        trace("切换到冥想状态");
                        switchState(PIG_THINK);
                    }else if (m_pig.name == PIG_SLEEP) {
                        showBubbles();
                    }
                }
            }
        }
        
        
        public function wakeup():void {
            if (m_pig.name == PIG_SLEEP) {
                switchState(PIG_STAND);
                bubbleItem.visible = false;
                pigTimer.stop();
                pigTimer.reset();
            }
        } 
        
        
        public function updateHappy():void {
            if (m_pig.name == PIG_STAND && isDrag == false) {
                trace("切换到小猪高兴的状态");
                switchState(PIG_HAPPY);
                pigTimer.stop();
            }
        }
        
        public function icePig():void {
            bubbleItem.visible = false;
            pigState = 2;
            isInIce = true;
            trace("isDrag : " + isDrag);
            if (isDrag == false) {
                bubbleItem.visible = false;
                if (m_pig.name == PIG_RUN) {
                    SoundManager.getInstance().stop("pig_run");
                }
                //switchState(PIG_ICE);
                switchState(PIG_FLOP);
            }
        }
        
        public function updateData():void {
            oldSleepTime = 0;
        }
        
        public function firePig():void {
            pigState = 1;
            isInIce = false;
            m_pig.y = pigDefaultY;
            
            if (m_pig.x <= runRect.x) {
                m_pig.x = runRect.x + 2;
            }else if (m_pig.x >= runRect.y) {
                m_pig.x = runRect.y - 2;
            }
            
            bubbleItem.visible = false;
            if (m_pig.name == PIG_ICE) {
                switchState(PIG_MELT);
            }else if (m_pig.name == PIG_FLOP) {
                switchState(PIG_STAND);
            }else if (m_pig.name == PIG_STAND) {
                if(GameData.dayState == 1){
                    switchState(PIG_SLEEP);
                }
                
                GameData.nightDesireList[2] = 1;
                GameData.setWishComTime(7,getTimer());
            }else if (m_pig.name == PIG_SLEEP) {
                if (GameData.dayState == 0) {
                    switchState(PIG_STAND);
                }
            }else if (m_pig.name == PIG_THINK) {
                if (GameData.dayState == 1) {
                    actionQueue.push(PIG_SLEEP);
                }
            }
            
            if (GameData.dayState == 0) {
                actionQueue = [];
            }
        }
        
        private var skateSoundIsOk : Boolean = true;
        private var skateSoundChannel : SoundChannel;
        
        private var runRect : Rectangle = new Rectangle(190,810,1,1);
        
        public function update(data:*):void
        {
            if (isActive) 
            {
                _juggler.advanceTime(0.03);
                //note : 泡泡消失的情况需要提出来
                if (m_pig.name == PIG_THINK || m_pig.name == PIG_SLEEP) {
                    if (getTimer() - bubblesStartTime >= bubblesTime) {
                        bubblesStartTime = getTimer();
                        m_pig.play();
                        bubbleItem.visible = false;
                        trace("提示泡可以消失了");
                    }
                }else {
                    bubblesStartTime = getTimer();
                }
                
                onFrameChangeHandler();
                
                if (isInIce) {
                    pigState = 2;
                }
                
                if(m_pig.name == PIG_RUN){
                    if (m_pig.x < runRect.x) {
                        trace("变形了么");
                        m_pig.scaleX = -1;
                        m_pig.x = runRect.x + 2;
                        bubbleItem.scaleX = m_pig.scaleX;
                        vx = -vx;
                    }else if (m_pig.x > runRect.y) {
                        m_pig.scaleX = 1;
                        m_pig.x = runRect.y - 2;
                        bubbleItem.scaleX = m_pig.scaleX;
                        vx = -vx;
                    }
                    m_pig.x += vx;
                }
                
                if (isDrag == false) {
                    if (m_pig.y >= 690 * Screen.ratio) {
                        isOnIce = true;
                        m_pig.data.ax = Accel.incX - (m_pig.data.ax);
                        if (Accel.incX >= 0.1) {
                            if (m_pig.scaleX == 1) {
                                
                            }else {
                                m_pig.scaleX = 1;
                            }
                        }else if(Accel.incX <= -0.1){
                            if (m_pig.scaleX == -1) {
                                
                            }else {
                                m_pig.scaleX = -1;
                            }
                        }
                        if(Math.abs(Accel.incX) < 0.2){
                            m_pig.data.ax *= 0.95;
                        }else {
                            m_pig.data.ax = Accel.incX;
                        }
                        iceVx = -m_pig.data.ax * 10;
                        
                        if(Math.abs(iceVx) >= 9){
                            iceVx = Math.abs(iceVx) / iceVx * 9;
                        }else if (Math.abs(iceVx) <= 0.5) {
                            iceVx = 0;
                        }
                        //trace("vx : " + iceVx + " indx : " + Accel.incX);
                        if(Math.abs(Accel.incX) > 0.1){
                            if (m_pig.name != PIG_SKATING) {
                                
                                GameData.nightDesireList[4] = 1;
                                
                                
                                switchState(PIG_SKATING);
                            }else {
                                if (Math.abs(iceVx) < 1) {
                                    
                                }else {
                                    if (m_pig.currentFrame == 8) {
                                        m_pig.stop();
                                        m_pig.currentFrame = 0;
                                        m_pig.play();
                                    }
                                }
                            }
                            
                            if (skateSoundIsOk) {
                                GameData.setWishComTime(9,getTimer());
                                skateSoundIsOk = false;
                                skateSoundChannel = SoundManager.getInstance().soundDic["pig_skate"].play(0, 1);
                                skateSoundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE,onSkateSoundCom);
                            }
                        }else {
                        }
                        
                        if (m_pig.x <= 0) {
                            m_pig.x = 1000 * Screen.wRatio;
                        }else if(m_pig.x >= 1020 * Screen.wRatio){
                            m_pig.x = 100 * Screen.wRatio;
                        }
                        
                        m_pig.x += iceVx;
                    }else {
                        isOnIce = false;
                    }
                }
                
                if (getTimer() - oldTime >= 30000 && GameData.is2012 == false) {
                    trace("小猪开始想");
                    oldTime = getTimer();
                    updateThink();
                }else {
                    //oldTime = getTimer();
                }
                
                if(GameData.dayState == 1){
                    if (oldSleepTime != 0) {
                        if (getTimer() - oldSleepTime >= 10000 && GameData.is2012 == false) {
                            oldSleepTime = getTimer();
                            trace("小猪继续睡觉");
                            if (m_pig.name == PIG_STAND) {
                                switchState(PIG_SLEEP);
                                GameData.nightDesireList[2] = 1;
                            }else {
                                //暂时加入队列
                                actionQueue.push(PIG_SLEEP);
                            }
                        }
                    }
                }else {
                    oldSleepTime = 0;
                }
                
            }
        
        }
        
        private var actionQueue : Array = [];
        
        private function onSkateSoundCom(e : flash.events.Event):void 
        {
            skateSoundIsOk = true;
            skateSoundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE,onSkateSoundCom);
        }
        
        public function resetTime():void {
            oldTime = getTimer();
        }
        
        public function destroy():void
        {
            removeChild(m_pig, true);
            removeChildren();
            removeEventListeners();
        }
    }
}

