package com.pamakids.weather.items
{
    import com.greensock.TweenLite;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.MoonMsg;
    import com.pamakids.core.msgs.StartSunMsg;
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.utils.Screen;
    import com.pamakids.utils.dinput.MouseDown;
    import com.pamakids.utils.dinput.MouseMove;
    import com.pamakids.utils.dinput.MouseUp;
    import com.pamakids.utils.dinput.TouchBegin;
    import com.pamakids.utils.dinput.TouchEnd;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.GameStatic;
    import com.urbansquall.ginger.Animation;
    import com.urbansquall.ginger.AnimationPlayer;
    import com.urbansquall.metronome.Ticker;
    import com.urbansquall.metronome.TickerEvent;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.InteractiveObject;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    
    import models.PosVO;
    
    import starling.display.Image;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    
    public class MoonItem extends UIBase implements IItem
    {
        
        public var isActive : Boolean;
        
        private var m_moon : Image;
        private var stepNum : int = 8;
        
        public var interTime : int = 30;
        public var startTime : int = 0;
        
        private var particles : Array = [];
        private var curIndex : int = 0;
        private var oldIndex : int = 0;
        private var isEnd : Boolean = false;
        private var isDown : Boolean = false;
        private var speed : Number = 0.5;
        
        
        public function MoonItem()
        {
            super();
        }
        
        public function init():void
        {	
            // Create an animation manually
            
            setMoonTexture();
            speed *= Screen.ratio;
            m_moon = new Image(moonTexture);
            addChild(m_moon);
            m_moon.visible = false;
            m_moon.pivotX = m_moon.width * 0.5;
            m_moon.pivotY = m_moon.height * 0.5;
            m_moon.x = -200;
            m_moon.y = GameData.trackList[0][1];
            
            m_moon.addEventListener(TouchEvent.TOUCH, onTouchMoon);
            
            startTime = getTimer();
        }
        
        public function reset():void {
            isDown = false;
            isActive = false;
            curIndex = 0;
            oldIndex = curIndex;
            m_moon.visible = false;
            isEnd = false;
            m_moon.x = -200;
            m_moon.y = GameData.trackList[0][1];
        }
        
        private var moonTexture : Texture;
        private function setMoonTexture():void {
            moonTexture = AssetManager.getInstance().getTexture("moon001");
        }
        
        
        private function onTouchMoon(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(stage);
            var touchs : Vector.<Touch> = e.getTouches(stage);
            if(touchs.length == 1){
                //if (e.currentTarget == m_moon) {
                isActive = true;
                if (touch.phase == TouchPhase.BEGAN) {
                    isDown = true;
                    isActive = false;
                    m_moon.data.offX = touch.globalX/PosVO.scale - m_moon.x;
                    m_moon.data.offY = touch.globalY/PosVO.scale - m_moon.y;
                }else if (touch.phase == TouchPhase.MOVED) {
                    isActive = false;
                    if(isDown == true){
                        onMouseMoveHandler(touch);
                    }
                }else if (touch.phase == TouchPhase.ENDED) {
                    isDown = false;
                    onMouseUpHandler();
                    isActive = true;
                }
                    //}
            }else {
                isDown = false;
            }
        }
        
        public function moonPosInit():void {
            if(m_moon){
                m_moon.x = -200;
                m_moon.y = GameData.trackList[0][1];
                stop();
            }
        }
        
        private var moonX : Number = 0;
        private function onMouseMoveHandler(e : Touch):void 
        {
            if (e.globalX >= Screen.wdth) {
                moonX = 1024;
            }else if (e.globalX <= 0) {
                moonX = 0;
            }else {
                moonX = e.globalX/PosVO.scale;
            }
            
            var kIndex : int = GameData.getThek(moonX);
            
            //trace("moonKindex : " + kIndex);
            var posY : Number;
            if (kIndex != -1) {
                
                if (e.globalX/PosVO.scale - m_moon.data.offX <= 0) {
                    m_moon.x = 0;
                }else if(e.globalX/PosVO.scale - m_moon.data.offX >= 1024){
                    m_moon.x = 1024;
                }else {
                    m_moon.x = e.globalX/PosVO.scale - m_moon.data.offX;
                }
                
                kIndex=GameData.getThek(m_moon.x);
                
                var k : Number = GameData.trackKList[kIndex];
                posY = k * e.globalX/PosVO.scale + GameData.trackBList[kIndex];
                
                m_moon.y = posY;
                
                var index : int = GameData.getThePosAtoX(m_moon.x, m_moon.y);
                if (oldIndex != index) {
                    broadMsg(index);
                }
                oldIndex = index;
                isEnd = false;
            }
        }
        
        
        private function onMouseUpHandler( ):void 
        {
            MouseUp.unsubscribe(onMouseUpHandler);
            MouseMove.unsubscribe(onMouseMoveHandler);
            var index : int = GameData.getThePosAtoX(m_moon.x, m_moon.y);
            var newPosX : Number = GameData.trackList[index][0];
            var newPosY : Number = GameData.trackList[index][1];
            curIndex = index;
            oldIndex = index;
            isActive = true;
        }
        
        private function tweenCom(value : int):void 
        {
            if(value != 5){
                broadMsg(value);
                isActive = true;
            }else {
                isActive = false;
            }
        
        }
        
        private function broadMsg(index : int):void {
            var moonMsg : MoonMsg = new MoonMsg();
            moonMsg.data = index + 5;
            PluginControl.BroadcastMsg(moonMsg);
        }
        
        public function start():void{
            isActive = true;
            curIndex = 0;
            isEnd = false;
            m_moon.visible = true;
            m_moon.x = GameData.trackList[0][0];
            m_moon.y = GameData.trackList[0][1];
            //broadMsg(0);
        
        }
        
        public function reStart():void {
        
        }
        
        public function stop():void{
            isActive = false;
        }
        
        /*		private function getThePosAngle():int{
                    var tmpList : Array = [];
                    for(var i : int = 0;i < stepNum;i ++){
                        var pos : Point = trackList[i] as Point;
                        var dx : Number = (m_moon.x - pos.x) * (m_moon.x - pos.x);
                        var dy : Number = (m_moon.y - pos.y) * (m_moon.y - pos.y);
                        var len : Number = dx + dy;
                        var object : Object = {};
                        object.index = i;
                        object.data = len;
                        tmpList.push(object);
                    }
        
                    tmpList.sortOn("data",Array.NUMERIC);
        
                    var index : int = tmpList[0].index;
                    return index;
                }*/
        
        
        public function update(data:*):void
        {	
            if(isActive){
                if (getTimer() - startTime > interTime) {
                    startTime = getTimer();
                    if (curIndex < GameData.trackList.length - 1 ) {
                        var kIndex : int = GameData.getThek(m_moon.x);
                        var posY : Number;
                        if (kIndex != -1) {
                            var k : Number = GameData.trackKList[kIndex];
                            m_moon.x += speed;
                            posY = k * m_moon.x + GameData.trackBList[kIndex];
                            m_moon.y = posY;
                            var index : int = GameData.getThePosAtoX(m_moon.x, m_moon.y);
                            if (oldIndex != index) {
                                if(index < 5){
                                    broadMsg(index);
                                    
                                }
                            }
                            oldIndex = index;
                        }
                        curIndex = oldIndex;
                        if (curIndex == GameData.trackList.length - 2 && m_moon.x > GameData.trackList[curIndex][0]) {
                            if (!isEnd) {
                                isEnd = true;
                                trace("通知太阳开始出来了");
                                PluginControl.BroadcastMsg(new StartSunMsg());
                            }
                        }
                    }else {
                        isActive = false;
                    }
                }
            }else {
                startTime = getTimer();
            }
        }
        
        public function destroy():void
        {
            particles[0].state = 0;
            m_moon.x = -1000;
        }
    }
}

