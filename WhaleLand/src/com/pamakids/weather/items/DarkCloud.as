package com.pamakids.weather.items
{
    import com.greensock.TweenLite;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.DarkCloudMsg;
    import com.pamakids.core.msgs.SnowMsg;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.model.GameData;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    
    import models.PosVO;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    
    public class DarkCloud extends Sprite implements IItem
    {
        //变量
        private var darkStartTime : uint = 0;
        private var oldX : Number = 0;
        private var speed : Number = 0;
        private var isActive : Boolean = false;
        private var index : Number = 0;
        
        private var hasCreated : Boolean = false;
        private var cloudList : Array = [];
        private var cloudLayer : Sprite;
        private var smallCloudW : Number = 261;
        public function DarkCloud()
        {
            super();
        }
        
        public function init():void
        {
            smallCloudW = 261;
            smallCloudW *= Screen.ratio;
            if (hasCreated == false) {
                hasCreated = true;
                setTexture();
                cloudLayer = new Sprite();
                addChild(cloudLayer);
                cloudLayer.y = -150 * Screen.ratio;
                for (var i : int = 0; i < 6;i ++ ) {
                    var smallCloud : Image = new Image(darlCloudTexture);
                    cloudLayer.addChild(smallCloud);
                    cloudList.push(smallCloud);
                    smallCloud.x = -smallCloudW + i * smallCloudW;
                    smallCloud.y = 0;
                }
            }
            
            cloudLayer.visible = true;
            TweenLite.to(cloudLayer, 1, { x : 0, y : 0, onComplete : tweenCom,onCompleteParams : [0]} );
        }
        
        public function reset():void {
            if(hasCreated){
                TweenLite.killTweensOf(cloudLayer);
                cloudLayer.y = -150 * Screen.ratio;
            }
            initData();
        }
        
        public function destroy():void
        {
            if (cloudLayer) {
                removeChild(cloudLayer);
                cloudLayer.dispose();
                cloudLayer.removeChildren();
                cloudLayer.removeEventListeners();
            }
            cloudList = [];
            index = 0;
            removeEventListeners();
            removeChildren();
        }
        
        private function initData() : void {
            isActive = false;	
            darkStartTime = 0;
            oldX = 0;
            speed = 0;
            index = 0;
            
            for (var i : int = 0; i < cloudList.length;i ++ ) {
                cloudList[i].x = -smallCloudW + i * smallCloudW;
                cloudList[i].y = 0;
            }
        }
        
        private var darlCloudTexture : Texture;
        private function setTexture():void {
            darlCloudTexture = AssetManager.getInstance().getTexture("cloud_dark");
        }
        
        private function tweenCom(value : int):void 
        {	
            darkStartTime = getTimer();
            isActive = true;
            cloudLayer.addEventListener(TouchEvent.TOUCH, onTouchDarkCloud);
        }
        
        private function onTouchDarkCloud(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(cloudLayer);
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    oldX = touch.globalX;
                }else if (touch.phase == TouchPhase.MOVED) {
                    onMousMoveHandler(touch);
                }else if (touch.phase == TouchPhase.ENDED) {
                    
                }
            }
        }
        
        
        private function onMousMoveHandler(e : Touch):void 
        {
            var newX : Number = e.globalX;
            var v : Number = newX - oldX;
            var msg : SnowMsg = new SnowMsg();
            
            if(Math.abs(v) >= 20 * Screen.wRatio){
                speed = v / Math.abs(v) * 20 * Screen.wRatio;
            }else{
                speed = v;
            }
            
            if (Math.abs(v) > 30 * Screen.wRatio) {
                if (Math.abs(v) > 100 * Screen.wRatio) {
                    v = 100 * Screen.ratio;
                }
                msg.data = Math.abs(v) / (10 * Screen.ratio);
            }else {
                msg.data = 2;
            }
            PluginControl.BroadcastMsg(msg);
            oldX = newX;
        }
        
        public function update(data:*):void
        {
            if (isActive) {
                var passTime : uint = getTimer() - darkStartTime;
                if (passTime < 30000) {
                    
                }else {
                    var msg : DarkCloudMsg = new DarkCloudMsg();
                    msg.data = false;
                    PluginControl.BroadcastMsg(msg);
                    GameData.isDarkCloud = false;
                    TweenLite.to(cloudLayer, 1, { y : -150 * Screen.ratio,onComplete : darkCloudOver} );
                    speed = 0;
                    isActive = false;
                }
                
                if (Math.abs(speed) > 0.5 * Screen.wRatio) {
                    for (var i : int = cloudList.length - 1; i >= 0 ;i-- ) {
                        cloudList[i].x += speed;
                    }
                    index = cloudList[1].x;
                    if(index >= smallCloudW * 0.5){
                        cloudList.unshift(cloudList.pop());
                        cloudList[0].x = cloudList[1].x - smallCloudW;
                    }else if(index <= -smallCloudW * 0.5){
                        cloudList.push(cloudList.shift());
                        cloudList[5].x = cloudList[4].x + smallCloudW;
                    }
                    speed *= 0.98;
                }
            }
        
        }
        
        private function darkCloudOver():void 
        {
            cloudLayer.visible = false;
            cloudLayer.removeEventListener(TouchEvent.TOUCH, onTouchDarkCloud);
        }
    }
}

