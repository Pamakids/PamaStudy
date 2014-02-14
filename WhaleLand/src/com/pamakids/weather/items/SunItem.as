package com.pamakids.weather.items
{	
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.CreatNewCloudMsg;
    import com.pamakids.core.msgs.PigHappyMsg;
    import com.pamakids.core.msgs.PigThinkMsg;
    import com.pamakids.core.msgs.StartMoonMsg;
    import com.pamakids.core.msgs.SunEnergyMsg;
    import com.pamakids.core.msgs.SunMsg;
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.GameStatic;
    import com.pamakids.weather.model.SoundManager;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.InteractiveObject;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import models.PosVO;
    
    import starling.animation.Juggler;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    public class SunItem extends UIBase implements IItem
    {
        public var interTime : int = 30;
        public var startTime : int = 0;
        public var isActive : Boolean = true;
        public var callBack : Function;
        
        private var curIndex : int = 0;
        private var oldIndex : int = 0;
        private var isEnd : Boolean = false;
        
        //是否开始进入蒸发阶段
        private var isSunShine : Boolean = false;
        private var sunShineTime : int = 0;
        private var oldSunShineTime : int = 0;
        //下完雪后阳光开始化雪
        private var startSunShine : Boolean = false;
        private var oldStartSunTime : int = 0;
        private var sunTotalTime : int = 0;
        
        private var sunOldDx : int = 0;
        private var sunOldDy : int = 0;
        private var sunOldDictance : Number = 0;
        private var isDown : Boolean = false;
        
        private var speed : Number = 0.5;
        private var sunScale : Number = 1;
        private var oldScale : Number = 1;
        private var scaleLevel1 : Number = 1.1;
        private var scaleLevel2 : Number = 1.3;
        
        private var m_sun : Sprite;
        private var sunEyes : MovieClip;
        private var sunTexture : Texture;
        private var sunEyesTextures : Vector.<Texture>;
        private var _juggler : Juggler = new Juggler();
        private var eyesTimer : Timer;
        
        public function SunItem()
        {
            super();
        }
        
        
        public function init():void
        {	
            trace("太阳加载中......");
            GameData.resetTrackList();
            speed *= Screen.ratio;
            
            setSunTexture();
            m_sun = new Sprite();
            var sunImg : Image = new Image(sunTexture);
            m_sun.addChild(sunImg);
            sunEyes = new MovieClip(sunEyesTextures,6);
            m_sun.addChild(sunEyes);
            sunEyes.touchable = false;
            addChild(m_sun);
            
            startTime = getTimer();
            eyesTimer = new Timer(4000);
            
            initData();
            initEvents();
            
            if (this.callBack != null) {
                this.callBack();
            }
        }
        
        public function update(data : *):void
        {
            if(isActive){
                if (getTimer() - startTime > interTime) {
                    startTime = getTimer();
                    if (curIndex < GameData.trackList.length - 1 ) {
                        var kIndex : int = GameData.getThek(m_sun.x);
                        var posY : Number;
                        if (kIndex != -1) {
                            var k : Number = GameData.trackKList[kIndex];
                            m_sun.x += speed;
                            posY = k * m_sun.x + GameData.trackBList[kIndex];
                            m_sun.y = posY;
                            var index : int = GameData.getThePosAtoX(m_sun.x, m_sun.y);
                            if (oldIndex != index) {
                                if(index < 5){
                                    broadMsg(index);
                                }
                            }
                            
                            oldIndex = index;
                        }
                        curIndex = oldIndex;
                        if (curIndex == GameData.trackList.length - 2 && m_sun.x > GameData.trackList[curIndex][0]) {
                            if (!isEnd) {
                                isEnd = true;
                                m_sun.touchable = false;
                                PluginControl.BroadcastMsg(new StartMoonMsg());
                                trace("通知月亮开始出来了");
                                isSunShine = false;
                                sunShineTime = 0;
                                
                                startSunShine = false;
                                sunTotalTime = 0;
                                
                            }
                        }
                    }else {
                        isActive = false;
                        m_sun.visible = false;
                    }
                }
                
                _juggler.advanceTime(0.03);
            }else {
                startTime = getTimer();
            }
            
            if (isSunShine) {
                var passTime : int = getTimer() - oldSunShineTime;
                sunShineTime += passTime;
                oldSunShineTime = getTimer();
                if (sunShineTime >= 5000) {
                    var msg : CreatNewCloudMsg = new CreatNewCloudMsg();
                    msg.data.posX = m_sun.x;
                    msg.data.posY = m_sun.y;
                    PluginControl.BroadcastMsg(msg);
                    sunShineTime = 0;
                }
            }
            
            if (startSunShine) {
                var hpassTime : int = getTimer() - oldStartSunTime;
                sunTotalTime += hpassTime;
                oldStartSunTime = getTimer();
                if (sunTotalTime >= 10000) {
                    trace("化雪了~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`");
                    //向外散发能量
                    var tmsg : SunEnergyMsg = new SunEnergyMsg();
                    PluginControl.BroadcastMsg(tmsg);
                    sunTotalTime = 0;
                }
            }
        }
        
        public function reset():void {
            initData();
            isActive = false;
        }
        
        public function destroy():void
        {
            removeChild(m_sun, true);
            m_sun = null;
            eyesTimer.stop();
            eyesTimer.removeEventListener(TimerEvent.TIMER, onEyesTimerHandler);
            eyesTimer = null;
        }
        
        public function startSunShineHandler():void {
            startSunShine = true;
            oldStartSunTime = getTimer();
            sunTotalTime = 0;
        }
        
        public function resetStartTime():void {
            startTime = getTimer();
        }
        
        public function start():void {
            curIndex = 0;
            isEnd = false;
            m_sun.x = GameData.trackList[0][0];
            m_sun.y = GameData.trackList[0][1];
            isActive = true;
            m_sun.visible = true;
            m_sun.touchable = true;
            m_sun.scaleX = m_sun.scaleY = sunScale;
            isSunShine = false;
            sunShineTime = 0;
            startSunShine = false;
            sunTotalTime = 0;
            stopEyes();
            GameData.sunIsZoomOut = false;
        }
        
        public function sunShineAction():void {
            if (m_sun.scaleX >= scaleLevel1 * sunScale) {
                if(GameData.isSnowing == false && GameData.snowState == 0){
                    isSunShine = true;
                    oldSunShineTime = getTimer();
                    sunShineTime = 0;
                }else {
                    isSunShine = false;
                }
                
                if (GameData.snowState > 0) {
                    trace("太阳照耀大地了");
                    startSunShine = true;
                    oldStartSunTime = getTimer();
                    sunTotalTime = 0;
                }
            }else {
                
            }
        }
        
        public function stopSunShineAction():void {
            m_sun.scaleX = m_sun.scaleY = sunScale;
            isSunShine = false;
            startSunShine = false;
            sunTotalTime = 0;
            sunShineTime = 0;
        }
        
        public function stop():void {
            isActive = false;
        }
        
        public function resetPos():void {
            stop();
            curIndex = 0;
            m_sun.x = -200;
            m_sun.visible = false;
            m_sun.y = GameData.trackList[0][1];
        }
        
        
        private function initData():void {
            sunScale = 1;
            oldScale = sunScale;
            curIndex = 0;
            oldIndex = curIndex;
            isEnd = false;
            
            isSunShine = false;
            sunShineTime = 0;
            oldSunShineTime = 0;
            startSunShine = false;
            oldStartSunTime = 0;
            sunTotalTime = 0;
            
            sunOldDx = 0;
            sunOldDy = 0;
            sunOldDictance = 0;
            isDown = false;
            
            eyesTimer.stop();
            sunEyes.x = UICoordinatesFactory.getNewPosY(92);
            sunEyes.y = UICoordinatesFactory.getNewPosY(122);
            m_sun.scaleX = m_sun.scaleY = sunScale;
            m_sun.pivotX = m_sun.width * 0.5;
            m_sun.pivotY = m_sun.height * 0.5;
            m_sun.x = GameData.trackList[0][0];
            m_sun.y = GameData.trackList[0][1];
        }
        
        private function initEvents():void {
            sunEyes.addEventListener(Event.COMPLETE, onSunEyesCom);
            m_sun.addEventListener(TouchEvent.TOUCH, onSunTouchHandler);
            eyesTimer.addEventListener(TimerEvent.TIMER,onEyesTimerHandler);
        }
        
        //这块可以在Screen类里返回是否是ipad不用每次都这么写
        private function setSunTexture():void {
            sunTexture = AssetManager.getInstance().getTexture("sun001");
            sunEyesTextures = AssetManager.getInstance().getTextures("suneyes");
        }
        
        private function onEyesTimerHandler(e:TimerEvent):void 
        {
            if (m_sun.scaleX > 1) {
                playEyes();
            }
        }
        
        //眼睛眨完了
        private function onSunEyesCom(e:Event):void 
        {
            sunEyes.data.curPlayNum ++;
            if (sunEyes.data.curPlayNum >= sunEyes.data.playNum) {
                _juggler.remove(sunEyes);
                sunEyes.data.curPlayNum = 0;
                sunEyes.data.playNum = 0;
                
                eyesTimer.reset();
                eyesTimer.start();
            }
        }
        
        
        private function onSunTouchHandler(e:TouchEvent):void 
        {
            var touchs : Vector.<Touch> = e.getTouches(m_sun);
            if (touchs.length == 2) {
                isActive = false;
                var finger1 : Touch = touchs[0];
                var finger2 : Touch = touchs[1];
                var distance : int;
                var dx : int;
                var dy : int;
                var scaleX : Number = 1;
                var scaleY : Number = 1;
                
                if (finger1.phase == TouchPhase.BEGAN && finger2.phase == TouchPhase.BEGAN) {
                    sunOldDx = Math.abs ( finger1.globalX - finger2.globalX );
                    sunOldDy = Math.abs ( finger1.globalY - finger2.globalY );
                    sunOldDictance = Math.sqrt(dx * dx + dy * dy);
                    isDown = true;
                }
                
                
                if ( finger1.phase == TouchPhase.MOVED && finger2.phase == TouchPhase.MOVED ) 
                {
                    dx = Math.abs ( finger1.globalX - finger2.globalX ); 
                    dy = Math.abs ( finger1.globalY - finger2.globalY ); 
                    
                    distance = Math.sqrt(dx * dx + dy * dy);
                    
                    if(sunOldDictance != 0){
                        scaleX = distance / sunOldDictance;
                        onGestureZoomHandler(scaleX);
                    }
                    sunOldDictance = distance;
                }
                
                if (finger1.phase == TouchPhase.ENDED || finger2.phase == TouchPhase.ENDED) {
                    isDown = false;
                    isActive = true;
                    if(m_sun.scaleX > oldScale){
                        SoundManager.getInstance().play("sun_big");
                        GameData.setWishComTime(0,getTimer());
                    }else if(m_sun.scaleX < oldScale){
                        SoundManager.getInstance().play("sun_small");
                    }
                    oldScale = m_sun.scaleX;
                }
            }else if (touchs.length == 1) {
                isActive = true;
                var touch : Touch = touchs[0]
                if (touch.phase == TouchPhase.MOVED) {
                    if(isDown){
                        onMouseMoveHandler(touch);
                    }
                    isActive = false;
                }else if (touch.phase == TouchPhase.BEGAN) {
                    isDown = true;
                    isActive = false;
                    m_sun.data.offX = touch.globalX/PosVO.scale - m_sun.x;
                    m_sun.data.offY = touch.globalY/PosVO.scale - m_sun.y;
                }else if (touch.phase == TouchPhase.ENDED) {
                    isDown = false;
                    isActive = true;
                    onMouseUpHandler();
                }
            }
        }
        
        private function onGestureZoomHandler(scaleX : Number):void 
        {
            
            m_sun.scaleX *= scaleX;
            m_sun.scaleY *= scaleX;
            
            if (m_sun.scaleX < scaleLevel1 * sunScale || m_sun.scaleY < scaleLevel1 * sunScale) 
            {
                if(m_sun.scaleX <= 1 * sunScale || m_sun.scaleY <= 1 * sunScale){
                    m_sun.scaleX = 1 * sunScale;
                    m_sun.scaleY = 1 * sunScale;	
                }
                isSunShine = false;
                sunShineTime = 0;
                
                startSunShine = false;
                sunTotalTime = 0;
                
                stopEyes();
                GameData.sunIsZoomOut = false;
                
                trace("sunScaleX : " + m_sun.scaleX);
                
            }else if (m_sun.scaleX <= scaleLevel2 * sunScale && m_sun.scaleX >= scaleLevel1 * sunScale ) {
                if(GameData.isSnowing == false && GameData.snowState == 0){
                    isSunShine = true;
                    oldSunShineTime = getTimer();
                    sunShineTime = 0;
                    trace("太阳能够蒸发水蒸了 : " + m_sun.scaleX);
                    startSunShine = false;
                    sunTotalTime = 0;
                }
                
                //太阳可以眨眼睛了
                playEyes();
                GameData.sunIsZoomOut = true;
                
                if (GameData.snowIsEnd == true && GameData.snowState > 0) {
                    trace("可以融化雪了");
                    startSunShine = true;
                    oldStartSunTime = getTimer();
                    sunTotalTime = 0;
                }
                
                
            }else if(m_sun.scaleX > scaleLevel2 * sunScale || m_sun.scaleY > scaleLevel2 * sunScale){
                m_sun.scaleX = scaleLevel2* sunScale;
                m_sun.scaleY = scaleLevel2 * sunScale;
                trace("sunScaleX : " + m_sun.scaleX);
                //成就1达成
                if (GameData.dayDesireList[0] == 0) {
                    PluginControl.BroadcastMsg(new PigHappyMsg());
                }
                GameData.dayDesireList[0] = 1;
                
                if (GameData.snowIsEnd == true && GameData.snowState > 0) {
                    startSunShine = true;
                    oldStartSunTime = getTimer();
                    sunTotalTime = 0;
                }
                
                GameData.sunIsZoomOut = true;
                
            }
        }
        
        private function playEyes():void {
            
            eyesTimer.stop();
            _juggler.add(sunEyes);
            sunEyes.currentFrame = 0;
            sunEyes.data.playNum = Math.random() * 3 + 2;
            sunEyes.data.curPlayNum = 0;
            sunEyes.play();
        }
        
        private function stopEyes():void {
            sunEyes.currentFrame = 0;
            _juggler.remove(sunEyes);
            sunEyes.data.playNum = 0;
            sunEyes.data.curPlayNum = 0;
            eyesTimer.stop();
            eyesTimer.reset();
        }
        
        
        private var sunX : Number = 0;
        private function onMouseMoveHandler(e : Touch):void 
        {
            if (e.globalX >= Screen.wdth) {
                sunX = 1024;
            }else if (e.globalX <= 0) {
                sunX = 0;
            }else {
                sunX = e.globalX/PosVO.scale;
            }
            
            var kIndex : int = GameData.getThek(sunX);
            var posY : Number;
            if (kIndex != -1) {
                
                if (e.globalX/PosVO.scale - m_sun.data.offX <= 0) {
                    m_sun.x = 0;
                }else if(e.globalX/PosVO.scale - m_sun.data.offX >= 1024){
                    m_sun.x = 1024;
                }else {
                    m_sun.x = e.globalX/PosVO.scale - m_sun.data.offX;
                }
                
                kIndex=GameData.getThek(m_sun.x);
                
                var k : Number = GameData.trackKList[kIndex];
                posY = k * (m_sun.x) + GameData.trackBList[kIndex];
                m_sun.y = posY;
                var index : int = GameData.getThePosAtoX(m_sun.x, m_sun.y);
                if (oldIndex != index) {
                    
                }
                if(index < 5){
                    broadMsg(index);	
                }
                
                oldIndex = index;
                isEnd = false;
            }
        
        }
        
        private function onMouseUpHandler( ):void {
            var index : int = GameData.getThePosAtoX(m_sun.x, m_sun.y);
            var newPosX : Number = GameData.trackList[index][0];
            var newPosY : Number = GameData.trackList[index][1];
            curIndex = index;
            broadMsg(index);
            oldIndex = index;
            isActive = true;
        }
        
        private function broadMsg(index : int):void {
            var sunMsg : SunMsg = new SunMsg();
            sunMsg.data = index;
            PluginControl.BroadcastMsg(sunMsg);
        }
    }
}

