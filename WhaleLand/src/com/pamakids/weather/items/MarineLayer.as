package com.pamakids.weather.items
{
    import com.greensock.TweenLite;
    import com.gslib.net.hires.debug.Stats;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.LoadIsLandMsg;
    import com.pamakids.core.msgs.NiceLightsMsg;
    import com.pamakids.core.msgs.PigThinkMsg;
    import com.pamakids.core.msgs.PlayFishMsg;
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.utils.ColorUtils;
    import com.pamakids.utils.DeviceInfo;
    import com.pamakids.utils.Screen;
    import com.pamakids.utils.dinput.Accel;
    import com.pamakids.utils.dinput.Micropoe;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    
    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import models.PosVO;
    
    import starling.animation.Juggler;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Quad;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    
    public class MarineLayer extends UIBase implements IItem
    {
        
        private var isLightClick : Boolean = false;
        public var isLightOn : Boolean = false;
        
        private var waterClickArea : Image;
        private var msg : PlayFishMsg = new PlayFishMsg();
        private var langList : Array = [];
        private var isActive : Boolean = false;
        
        private var m_ice : Image;
        private var icemarkList : Array = [];
        private var iceMarkDic : Array = [];
        private var _juggler : Juggler = new Juggler();
        
        private var thickOldTime : int = 0;
        private var thickIceTime : int = 0;
        private var thickIce : Image;
        private var thickIcAnimation : MovieClip;
        
        //小岛的投影
        private var islandShader : Image;
        //后面的小岛
        private var backIsland : Image;
        private var lighthouse : Image;
        private var lighthouse_light : Image;
        private var lighthouse_light2 : Image;
        //码头
        private var terminal : Image;
        
        //鲸鱼尾巴
        private var tail : Image;
        
        private var itemList : Array = [];
        
        private var niceLightMsg : NiceLightsMsg = new NiceLightsMsg();
        
        private var offsetY : Number = 10;
        private var offsetX : Number = 1;
        public function MarineLayer()
        {
            super();
        }
        
        public function init():void
        {
            setTexture();
            
            if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
                offsetY = 0;
                offsetX = 0;
            }else {
                offsetY = 11;
                offsetX = 1;
            }
            
            
            trace("海面初始化中..... : " + Stats.tFps);
            //水面
            waterClickArea = new Image(waterTexture);
            addChild(waterClickArea);
            
            if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
                
            }else {
                waterClickArea.height += 3;
            }
            
            waterClickArea.x = 0;
            waterClickArea.y = 768 - waterClickArea.height;
            
            trace("waterClick.y : " + waterClickArea.y);
            
            waterClickArea.addEventListener(TouchEvent.TOUCH, onTouchWater);
            
            //岛后面的小岛，放到这一层了
            backIsland = new Image(backIslandTexture);
            backIsland.touchable = false;
            addChild(backIsland);
            backIsland.x = UICoordinatesFactory.getNewPosX(175);
            backIsland.y = UICoordinatesFactory.getNewPosY(481 - offsetY);
            setDefaultColor(backIsland);
            itemList.push(backIsland);
            
            //灯塔
            lighthouse = new Image(lighthouseTexture);
            addChild(lighthouse);
            //lighthouse.touchable = false;
            lighthouse.x = UICoordinatesFactory.getNewPosX(60);
            lighthouse.y = UICoordinatesFactory.getNewPosY(389 - offsetY);
            setDefaultColor(lighthouse);
            itemList.push(lighthouse);
            
            var lightHouseArea : Quad = new Quad(lighthouse.width * 1.3, lighthouse.height, 0xFF0000);
            addChild(lightHouseArea);
            lightHouseArea.alpha = 0;
            lightHouseArea.x = UICoordinatesFactory.getNewPosX(30);
            lightHouseArea.y = UICoordinatesFactory.getNewPosY(389 - offsetY);
            
            if(DeviceInfo.getDeviceType().indexOf("iphone") == -1){
                lighthouse.addEventListener(TouchEvent.TOUCH, onTouchLightHouse);
                lightHouseArea.touchable = false;
            }else {
                lightHouseArea.addEventListener(TouchEvent.TOUCH, onTouchLightHouse);
            }
            
            
            //灯塔上的灯光
            lighthouse_light = new Image(lhLightTexture);
            addChild(lighthouse_light);
            lighthouse_light.touchable = false;
            lighthouse_light.x = UICoordinatesFactory.getNewPosX(77);
            lighthouse_light.y = UICoordinatesFactory.getNewPosY(417 - offsetY);
            lighthouse_light.visible = false;
            
            
            
            //鲸鱼尾巴
            tail = new Image(tailTexture);
            addChild(tail);
            tail.touchable = false;
            tail.x = UICoordinatesFactory.getNewPosX(865);
            tail.y = UICoordinatesFactory.getNewPosY(463 - offsetY);
            setDefaultColor(tail);
            itemList.push(tail);
            
            //码头
            terminal = new Image(terminalTexture);
            terminal.touchable = false;
            addChild(terminal);
            terminal.x = UICoordinatesFactory.getNewPosX(22);
            terminal.y = UICoordinatesFactory.getNewPosY(535 - offsetY);
            setDefaultColor(terminal);
            itemList.push(terminal);
            
            
            //小岛的投影
            islandShader = new Image(islandShaderTexture);
            addChild(islandShader);
            islandShader.touchable = false;
            islandShader.x = UICoordinatesFactory.getNewPosX(76);
            islandShader.y = UICoordinatesFactory.getNewPosY(539);
            setDefaultColor(islandShader);
            itemList.push(islandShader);
            
            initMarine();
        
        
        }
        
        public function reStart():void {
            isActive = true;
        }
        
        public function reset():void {
            initData();
            isActive = false;
            TweenLite.killTweensOf(lighthouse_light);
            if(lighthouse_light2){
                TweenLite.killTweensOf(lighthouse_light2);
            }
            
            updateDayState(0);
            
            hideWaterVapor();
        }
        
        private function initData():void {
            lighthouse_light.visible = false;
            isLightClick = false;
            isLightOn = false;
        }
        
        private var waterTexture : Texture;
        private var backIslandTexture : Texture;
        private var lighthouseTexture : Texture;
        private var lhLightTexture : Texture;
        private var tailTexture : Texture;
        private var terminalTexture : Texture;
        private var islandShaderTexture : Texture;
        private var langTextures : Vector.<Texture>;
        
        private function setTexture():void {
            waterTexture = AssetManager.getInstance().getTexture("seawater001");
            backIslandTexture = AssetManager.getInstance().getTexture("isle003");
            lighthouseTexture = AssetManager.getInstance().getTexture("lighthouse001");
            lhLightTexture = AssetManager.getInstance().getTexture("lighthouse002");
            tailTexture = AssetManager.getInstance().getTexture("isle002");
            terminalTexture = AssetManager.getInstance().getTexture("wharf001");
            islandShaderTexture = AssetManager.getInstance().getTexture("isle004");
            
            langTextures = AssetManager.getInstance().getTextures("hailang");
        }
        
        
        private function onTouchLightHouse(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(stage);
            if (touch) {
                if (touch.phase == TouchPhase.ENDED) {
                    if (GameData.dayState == 1) {
                        clickTheLightTower();
                    }
                }
            }
        }
        
        public function clickTheLightTower():void {
            if (!isLightClick) {
                isLightClick = true;
                if (isLightOn) {
                    isLightOn = false;
                    GameData.isTowerLightOn = false;
                    TweenLite.killTweensOf(lighthouse_light2);
                    TweenLite.to(lighthouse_light, 1, { alpha : 0,onComplete : lightClickCom , onCompleteParams : [lighthouse_light]} );
                    TweenLite.to(lighthouse_light2, 1, { alpha : 0,onComplete : lightClickCom,onCompleteParams : [lighthouse_light2] } );
                    SoundManager.getInstance().play("light_off");
                }else {
                    
                    if (lighthouse_light2) {
                        
                    }else {
                        setLightHouse2Texture();
                        lighthouse_light2 = new Image(lh2Textue);
                        addChild(lighthouse_light2);
                        lighthouse_light2.pivotY = lighthouse_light2.height * 0.5;
                        lighthouse_light2.touchable = false;
                        lighthouse_light2.x = UICoordinatesFactory.getNewPosX(82);
                        lighthouse_light2.y = UICoordinatesFactory.getNewPosY(304 - offsetY * 1.5) + lighthouse_light2.height * 0.5;
                        
                    }
                    
                    lighthouse_light.alpha = 0;
                    lighthouse_light2.alpha = 0;
                    lighthouse_light2.width = 459 * Screen.ratio;
                    lighthouse_light2.height = 245 * Screen.ratio;
                    TweenLite.to(lighthouse_light, 1, { alpha : 1,onComplete : lightClickCom,onCompleteParams : [null]} );
                    TweenLite.to(lighthouse_light2, 1, { alpha : 1,onComplete : lightClickCom,onCompleteParams : [null] });
                    lighthouse_light.visible = true;
                    lighthouse_light2.visible = true;
                    isLightOn = true;
                    GameData.isTowerLightOn = true;
                    SoundManager.getInstance().play("light_on");
                }
                trace("点击了灯塔");
            }
        }
        
        private var lh2Textue : Texture;
        private function setLightHouse2Texture():void {
            lh2Textue = AssetManager.getInstance().getTexture("lighthouse003");
        }
        
        private function lightClickCom(obj : Image):void 
        {
            
            if (obj == null) {
                TweenLite.to(lighthouse_light2,1.3,{width : 400 * Screen.ratio,scaleY : 1,alpha : 1,onComplete : flashLightCom,onCompleteParams : [0]});
            }else {
                TweenLite.killTweensOf(obj);
                obj.visible = false;
            }
            isLightClick = false;
            
            if (GameData.isTowerLightOn && GameData.isHouseLightOn) {
                niceLightMsg.data = 1;
            }else {
                niceLightMsg.data = 0;
            }
            PluginControl.BroadcastMsg(niceLightMsg);
        }
        
        private function flashLightCom(value : int):void 
        {
            if(value == 0){
                TweenLite.to(lighthouse_light2, 0.7, { width : 1050 * Screen.ratio,scaleY : 0.7, alpha : 0.3,onComplete : flashLightCom,onCompleteParams : [1] } );
            }else if (value == 1) {
                TweenLite.to(lighthouse_light2,1.3,{width : 400 * Screen.ratio,scaleY : 1,alpha : 1,onComplete : flashLightCom,onCompleteParams : [0]});
            }
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
        
        private function itemUpdateDayState(value : int = 0, list : Array = null):void {
            if(list != null){
                for (var i : int = 0; i < list.length;i ++ ) {
                    if (value == 0) {
                        changeToDefaultColor(list[i]);
                    }else if(value == 1){
                        changeToDefaultColor(list[i],1);	
                    }
                }
            }
        }
        
        /**
         * 更新当前状态，白天还是黑夜
         * 0:白天 1 : 晚上
         */
        public function updateDayState(value : int = 0):void {
            trace("晚上还是白天 : " + value);
            if (value == 0) {
                if (m_ice) {
                    m_ice.visible = false;
                }
                hideIceMark();
                if (thickIce) {
                    thickIce.visible = false;
                }
                
                itemUpdateDayState(0,itemList);
                
                GameData.thinkIceIsOk = false;
                GameData.isTowerLightOn = false;
                lighthouse_light.visible = false;
                isLightOn = false;
                isLightClick = false;
                if(lighthouse_light2){
                    lighthouse_light2.visible = false;
                }
            }else if (value == 1) {
                if (m_ice) {
                    m_ice.visible = true;
                }else {
                    setIceTexture();
                    m_ice = new Image(iceTexture);
                    addChildAt(m_ice,this.getChildIndex(waterClickArea) + 1);
                    m_ice.addEventListener(TouchEvent.TOUCH,onTouchIce);
                    m_ice.x = 0;
                    m_ice.y = Screen.hght - m_ice.height;
                }
                itemUpdateDayState(1, itemList);
                
                lighthouse_light.alpha = 0;
                lighthouse_light.visible = true;
                
                GameData.resetAchievements(1);
            }
        }
        
        private var iceTexture : Texture;
        private function setIceTexture():void {
            iceTexture = AssetManager.getInstance().getTexture("ice");
        }
        
        
        //-----------------------
        private var waterTexturs : Vector.<Texture>;
        private function setWaterTextures():void {
            waterTexturs = AssetManager.getInstance().getTextures("steam");
        }
        //-----------------------
        
        
        
        private var waterVaporList : Array = [];
        //产生水蒸气
        public function creatWaterVapor(data : Object):void {
            if (waterTexturs) {
                
            }else {
                setWaterTextures();
            }
            var waterVapor : MovieClip;
            if (waterVaporList.length < 1) {
                waterVapor = new MovieClip(waterTexturs);
                waterVaporList.push(waterVapor);
                addChild(waterVapor);
                waterVapor.pivotX = waterVapor.width * 0.5;
                waterVapor.pivotY = waterVapor.height * 0.5;
                waterVapor.touchable = false;
            }else{
                waterVapor = waterVaporList[0];
                waterVapor.visible = true;
            }
            waterVapor.data.oldTime = getTimer();
            waterVapor.x = data.posX;
            waterVapor.y = UICoordinatesFactory.getNewPosY(750);
            _juggler.add(waterVapor);
        }
        
        private function hideWaterVapor():void {
            for (var i : int = 0; i < waterVaporList.length;i ++ ) {
                waterVaporList[i].visible = false;
            }
        }
        
        
        //点击冰面出现裂痕
        private function onTouchIce(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(m_ice);
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    onMouseDownHandler(touch);
                }
            }
        }
        
        private function hideIceMark():void {
            for (var i : int = 0; i < icemarkList.length; i ++ ) {
                var icemark : MovieClip = icemarkList[i] as MovieClip;
                icemark.visible = false;
                icemark.currentFrame = 1;
                iceMarkDic.push(icemark);
                _juggler.remove(icemark);
            }
            icemarkList = [];
        }
        
        
        //------------------
        private var iceMarkTexture : Vector.<Texture>;
        private function setIceMarkTexture():void {
            iceMarkTexture = AssetManager.getInstance().getTextures("Crack");
        }
        //------------------
        
        private function onMouseDownHandler(e : Touch):void 
        {
            if (e.globalY/PosVO.scale >= 700) {
                if (icemarkList.length < 3) {
                    var icemark : MovieClip;
                    if (iceMarkDic.length > 0) {
                        icemark = iceMarkDic.shift();
                        icemark.visible = true;
                        icemark.alpha = 1;
                    }else {
                        setIceMarkTexture();
                        icemark = new MovieClip(iceMarkTexture,24);
                        icemark.touchable = false;
                        icemark.loop = false;
                        icemark.pivotX = icemark.width * 0.5;
                        icemark.pivotY = icemark.height * 0.5;
                        addChild(icemark);
                    }
                    icemarkList.push(icemark);
                    icemark.x = e.globalX/PosVO.scale;
                    icemark.y = e.globalY/PosVO.scale;
                    icemark.data.oldTime = getTimer();
                    _juggler.add(icemark);
                    icemark.play();
                    SoundManager.getInstance().play("ice_creak");
                }
            }
        }
        
        
        private function iceMarkTweenComHandler(display : MovieClip):void 
        {
            display.visible = false;
            display.currentFrame = 1;
            _juggler.remove(display);
            iceMarkDic.push(display);
        }
        
        /**
         * 点击水面会出鱼
         * @param	e
         */
        private function onTouchWater(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(stage);
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    trace("点击了水面啊~~~~~~~~~~~~~~~~~~~~~~~~~~");
                    if(touch.globalY/PosVO.scale >= 710){
                        msg.posX = touch.globalX/PosVO.scale;
                        msg.posY = touch.globalY/PosVO.scale;
                        PluginControl.BroadcastMsg(msg);
                    }
                }
            }
        }
        
        /**
         * 波浪效果
         */
        private function initMarine():void {
            
            //var langTextures : Vector.<Texture> = BitmapDataLibrary.getAllAtlas().getTextures("sea/sea");
            for (var i : int = 0; i < 4;i ++ ) {
                var m_langPlayer : MovieClip = new MovieClip(langTextures);
                m_langPlayer.fps = Math.random() * 10 + 10;
                m_langPlayer.x = (Math.random() * 800 + 200) * Screen.wRatio;
                m_langPlayer.y = (Math.random() * 100 + 680) * Screen.ratio;
                addChild( m_langPlayer );
                m_langPlayer.pivotX = m_langPlayer.width * 0.5;
                m_langPlayer.pivotY = m_langPlayer.height * 0.5;
                m_langPlayer.touchable = false;
                langList[i] = m_langPlayer;
                _juggler.add(m_langPlayer);
            }
            
            trace("海面初始化完成 : " + Stats.tFps);
            isActive = true;
            
            
            timer = new Timer(1000, 1);
            timer.start();
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComHandler);
        
        }
        
        private function onTimerComHandler(e:TimerEvent):void 
        {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComHandler);
            timer = null;
            
            PluginControl.BroadcastMsg(new LoadIsLandMsg());
        }
        
        private var timer : Timer;
        
        
        
        
//        private function onClickWater(e : MouseEvent):void 
//        {
//            var tar : * = e.target;
//            if(tar == waterClickArea){
//                msg.posX = Screen.stg.mouseX/PosVO.scale;
//                msg.posY = Screen.stg.mouseY/PosVO.scale;
//                PluginControl.BroadcastMsg(msg);
//            }
//        }
        
        
        
        private var iceATextures : Vector.<Texture>;
        private function setIceATextures():void {
            iceATextures = AssetManager.getInstance().getTextures("flash");
        }
        
        
        /**
         * 此处需要优化
         * @param	data
         */
        public function update(data:*):void
        {
            if (isActive) {
                _juggler.advanceTime(0.03);
                for (var i : int = 0; i < icemarkList.length;i ++ ) {
                    if ((getTimer() - (icemarkList[i] as MovieClip).data.oldTime) >= 4000) {
                        TweenLite.to(icemarkList[i] as MovieClip,1,{alpha : 0,onComplete : iceMarkTweenComHandler, onCompleteParams : [icemarkList[i]]});
                        icemarkList.splice(i,1);
                    }
                }
                
                for (i = 0; i < waterVaporList.length;i ++ ) {
                    if ((getTimer() - waterVaporList[i].data.oldTime) >= 3000) {
                        waterVaporList[i].visible = false;
                        _juggler.remove(waterVaporList[i]);
                        waterVaporList[i].data.oldTime = getTimer();
                    }
                }
                
                if (GameData.dayState == 1) {
                    if (thickIcAnimation) {
                        if(thickIcAnimation.isPlaying){
                            thickIcAnimation.x += 30 * Screen.ratio;
                            if (thickIcAnimation.x > Screen.wdth) {
                                thickIcAnimation.x = 100 * Screen.wRatio;
                                thickIcAnimation.visible = false;
                                thickIcAnimation.stop();
                                thickIcAnimation.currentFrame = 0;
                                _juggler.remove(thickIcAnimation);
                                
                            }
                        }
                    }
                    if (Micropoe.mactivityLevel >= GameData.MICACTIVELEVEL2) {
                        
                        //GameData.soundManger.play("wind",1);
                        thickIceTime += (getTimer() - thickOldTime);
                        //trace("thickIceTime : " + thickIceTime + "  gameTime : " + getTimer());
                        if (thickIceTime >= GameData.GETWINDTIME) {
                            thickOldTime = getTimer();
                            if (thickIce == null) {
                                var thickIceBmd : ThickIce = new ThickIce();
                                thickIce = new Image(Texture.fromBitmapData(thickIceBmd, false));
                                thickIce.scaleX = Screen.wRatio;
                                thickIce.scaleY = Screen.ratio;
                                addChildAt(thickIce,getChildIndex(m_ice) + 1);
                                thickIce.x = 0;
                                thickIce.y = UICoordinatesFactory.getNewPosY(456);
                                thickIce.visible = true;
                                
                                if (thickIcAnimation == null) {
                                    setIceATextures();
                                    thickIcAnimation = new MovieClip(iceATextures);
                                    addChild(thickIcAnimation);
                                    thickIcAnimation.x = UICoordinatesFactory.getNewPosX(100);
                                    thickIcAnimation.y = UICoordinatesFactory.getNewPosY(648);
                                    thickIcAnimation.touchable = false;
                                    _juggler.add(thickIcAnimation);
                                    thickIcAnimation.play();
                                }
                                
                            }else {
                                
                                thickIcAnimation.visible = true;
                                thickIce.visible = true;
                                if (!thickIcAnimation.isPlaying) {
                                    thickIcAnimation.x = 100 * Screen.wRatio;
                                    _juggler.add(thickIcAnimation);
                                    thickIcAnimation.play();
                                }
                                
                            }
                            
                            GameData.thinkIceIsOk = true;
                            thickIceTime = 0;
                        }else {
                        }
                    }else {
                        thickIceTime = 0;
                    }
                    thickOldTime = getTimer();
                }else {
                    
                    if (thickIcAnimation) {
                        thickIcAnimation.visible = false;
                    }
                    
                    thickOldTime = getTimer();
                    thickIceTime = 0;
                }
                thickOldTime = getTimer();
                
                for (i = 0; i < langList.length; i ++ ) {
                    if (GameData.dayState == 0) {
                        if ((langList[i] as MovieClip).visible) {
                            
                        }else{
                            (langList[i] as MovieClip).visible = true;
                        }
                        var vx : Number = 0;
                        if (Math.abs(Accel.incX) < 0.1) {
                            vx = (1.5 + Math.random()) * Screen.wRatio;
                        }else {
                            vx = ((Accel.incX) / 100) * (200 + 100 * Math.random()) * Screen.wRatio;
                        }
                        (langList[i] as MovieClip).x += -vx;
                        if ((langList[i] as MovieClip).x < 0) {
                            (langList[i] as MovieClip).x = 1000 * Screen.wRatio;
                        }else if ((langList[i] as MovieClip).x > 1000 * Screen.wRatio) {
                            (langList[i] as MovieClip).x = 10 * Screen.wRatio;
                        }
                    }else {
                        (langList[i] as MovieClip).visible = false;
                    }
                }
            }
        }
        
        public function destroy():void
        {
            removeChild(waterClickArea, true);
            for (var i : int = 0; i < itemList.length; i ++ ) {
                if(itemList[i]){
                    removeChild(itemList[i], true);
                }
            }
            
            for (i = 0; i < langList.length;i ++ ) {
                if (langList[i]) {
                    removeChild(langList[i],true);
                }
            }
            
            for (i = 0; i < icemarkList.length;i ++ ) {
                if (icemarkList[i]) {
                    removeChild(icemarkList[i],true);
                }
            }
            
            if (thickIce) {
                removeChild(thickIce,true);
            }
            
            if (thickIcAnimation) {
                removeChild(thickIcAnimation,true);
            }
        }
    }
}

