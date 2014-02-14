package com.pamakids.weather.items
{
    import com.greensock.TweenLite;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.WorldEndMsg;
    import com.pamakids.core.msgs.WorldPeaceMsg;
    import com.pamakids.utils.ColorUtils;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import models.PosVO;
    
    import starling.animation.Juggler;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.TextureAtlas;
    
    public class HouseItem extends Sprite
    {
        public var houseClikFun : Function;
        
        private var aroof : MovieClip;
        private var chimney : Image;
        private var mainHouse : Image;
        private var broof : MovieClip;
        private var roof : Image;
        
        private var balloonLayer : BalloonLayer;
        private var _juggler : Juggler = new Juggler();
        public function HouseItem()
        {
            super();
        }
        
        public function hideTheBalloon():void {
            TweenLite.to(balloonLayer, 0.2, {y : -200 * Screen.ratio, onComplete : hideComHandler } );
        }
        
        public function reStart():void {
            aroof.addEventListener(Event.COMPLETE, onARoofComHandler);
        }
        
        public function reset():void {
            aroof.changePlayMode(0);
            broof.changePlayMode(0);
            aroof.currentFrame = 0;
            broof.currentFrame = 0;
            aroof.removeEventListener(Event.COMPLETE, onARoofComHandler);
            if(this.hasEventListener(Event.ENTER_FRAME)){
                this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
            }
            updateDay();
            
            balloonLayer.visible = false;
            balloonLayer.y = 0;
            
            balloonLayer.reset();
        }
        
        private function hideComHandler():void 
        {	balloonLayer.stop();
            balloonLayer.visible = false;
            balloonLayer.y = 0;
        }
        
        
        private var resTextures : AssetManager;
        private function setResTextures():void {
            resTextures = AssetManager.getInstance();
        }
        
        public function init():void {
            
            setResTextures();
            
            aroof = new MovieClip(resTextures.getTextures("aroof"),6);
            addChild(aroof);
            setDefaultColor(aroof);
            aroof.touchable = false;
            aroof.pause();
            aroof.loop = false;
            aroof.x = UICoordinatesFactory.getNewPosX(439);
            aroof.y = UICoordinatesFactory.getNewPosY(289);
            aroof.changePlayMode(0);
            aroof.addEventListener(Event.COMPLETE,onARoofComHandler);
            
            
            chimney = new Image(resTextures.getTexture("chimney"));
            addChild(chimney);
            setDefaultColor(chimney);
            chimney.touchable = false;
            chimney.x = UICoordinatesFactory.getNewPosX(521);
            chimney.y = UICoordinatesFactory.getNewPosY(273);
            
            balloonLayer = new BalloonLayer();
            addChild(balloonLayer);
            balloonLayer.touchable = false;
            
            
            mainHouse = new Image(resTextures.getTexture("house"));
            addChild(mainHouse);
            setDefaultColor(mainHouse);
            mainHouse.x = UICoordinatesFactory.getNewPosX(369);
            mainHouse.y = UICoordinatesFactory.getNewPosY(308);
            
            mainHouse.addEventListener(TouchEvent.TOUCH,onTouchHouseHnadler);
            
            broof = new MovieClip(resTextures.getTextures("broof"),6);
            addChild(broof);
            setDefaultColor(broof);
            broof.touchable = false;
            broof.pause();
            broof.loop = false;
            broof.x = UICoordinatesFactory.getNewPosX(331);
            broof.y = UICoordinatesFactory.getNewPosY(289);
            broof.changePlayMode(0);
            
            
            roof = new Image(resTextures.getTexture("roof"));
            addChild(roof);
            setDefaultColor(roof);
            roof.touchable = false;
            roof.x = UICoordinatesFactory.getNewPosX(535);
            roof.y = UICoordinatesFactory.getNewPosY(304);
        
        }
        
        public function destory():void {
            balloonLayer.destroy();
            removeChild(balloonLayer, true);
            
            removeChild(aroof,true);
            removeChild(broof,true);
            removeChild(mainHouse,true);
            removeChild(roof,true);
            removeChild(chimney,true);
            
            removeEventListeners();
            removeChildren();
        }
        
        
        private function onTouchHouseHnadler(e:TouchEvent):void 
        {
            
            if (GameData.dayState == 1) {
                var touch : Touch = e.getTouch(mainHouse);
                var touchs : Vector.<Touch> = e.getTouches(mainHouse);
                
                
                if (touchs.length == 2 && GameData.isSnowing == false && GameData.snowState == 0 && GameData.is2012 == false) {
                    var finger1:Touch = touchs[0]; 
                    var finger2:Touch = touchs[1]; 
                    var distance:int; 
                    var dx:int; 
                    var dy:int; 
                    // if both fingers moving (dragging) 
                    if ( finger1.phase == TouchPhase.MOVED && finger2.phase == TouchPhase.MOVED ) 
                    { 
                        // calculate the distance between each axes 
                        dx = Math.abs ( finger1.globalX - finger2.globalX ); 
                        dy = Math.abs ( finger1.globalY - finger2.globalY ); 
                        
                        // calculate the distance 
                        distance = Math.sqrt(dx*dx+dy*dy); 
                        
                        if (distance >= 200 * Screen.ratio) {
                            PluginControl.BroadcastMsg(new WorldEndMsg());
                            GameData.is2012 = true;
                            trace("世界末日到来了，哈哈哈哈哈哈");
                            runHappyTime();
                        }
                        
                            //trace ("distance : " + distance); 
                    } 
                }
                
                if (touch) {
                    if(touchs.length == 1){
                        if (touch.phase == TouchPhase.ENDED) {
                            if (houseClikFun != null && GameData.is2012 == false) {
                                this.houseClikFun();
                            }
                        }
                    }
                }
            }	
        }
        
        private function runHappyTime():void {
            trace("开始欢乐时刻了~~~~~~~~~~~~~~~~~~~");
            balloonLayer.visible = true;
            this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
            aroof.changePlayMode(0);
            broof.changePlayMode(0);
            aroof.play();
            broof.play();
            if (aroof.hasEventListener(Event.COMPLETE)) {
                
            }else{
                aroof.addEventListener(Event.COMPLETE, onARoofComHandler);
            }
            _juggler.add(aroof);
            _juggler.add(broof);
        }
        
        private function onARoofComHandler(e:Event):void 
        {
            trace("屋檐动画播放完毕~~~~~~~~~~~~~~~~~~~~~~~~~~");
            _juggler.remove(aroof);
            _juggler.remove(broof);
            balloonLayer.start();
            aroof.removeEventListener(Event.COMPLETE,onARoofComHandler);
        }
        
        public function closeHouse():void {
            
            trace("屋子可以关闭!");
            aroof.changePlayMode(1);
            broof.changePlayMode(1);
            aroof.play();
            broof.play();
            _juggler.add(aroof);
            _juggler.add(broof);
            
            aroof.addEventListener(Event.COMPLETE, onCloseHouseOver);
        }
        
        private function onCloseHouseOver(e:Event):void 
        {
            trace("播放完毕了");
            
            PluginControl.BroadcastMsg(new WorldPeaceMsg());
            _juggler.remove(aroof);
            _juggler.remove(broof);
            aroof.removeEventListener(Event.COMPLETE, onCloseHouseOver);
            this.removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
        }
        
        private function onEnterFrameHandler(e:Event):void 
        {
            _juggler.advanceTime(0.05);
            balloonLayer.update();
        }
        
        public function updateDay():void {
            changeToDefaultColor(aroof);
            changeToDefaultColor(chimney);
            changeToDefaultColor(mainHouse);
            changeToDefaultColor(broof);
            changeToDefaultColor(roof);
        
        }
        
        public function updateNight():void {
            changeToDefaultColor(aroof,1);
            changeToDefaultColor(chimney,1);
            changeToDefaultColor(mainHouse,1);
            changeToDefaultColor(broof,1);
            changeToDefaultColor(roof,1);
        }
        
        //记录默认颜色
        private function setDefaultColor(obj : Image):void {
            obj.data.defaultColor = obj.color;
        }
        
        //设置颜色
        //@mode 0 : 恢复默认颜色 1 : 生成新的颜色
        private function changeToDefaultColor(obj : Image, mode : int = 0):void {
            if (mode == 0) {
                obj.color = obj.data.defaultColor;
            }else if (mode == 1) {
                obj.color = ColorUtils.getNewColor(obj.data.defaultColor,ColorUtils.islandColorTrans);
            }
        }
    }
}

