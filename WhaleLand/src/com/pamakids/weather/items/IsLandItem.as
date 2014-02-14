package com.pamakids.weather.items
{
    import com.greensock.TweenLite;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.FireMsg;
    import com.pamakids.core.msgs.LoadPigMsg;
    import com.pamakids.core.msgs.LoadSkyOtherItem;
    import com.pamakids.core.msgs.PigHappyMsg;
    import com.pamakids.core.msgs.PigThinkMsg;
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.utils.ColorUtils;
    import com.pamakids.utils.DeviceInfo;
    import com.pamakids.utils.Screen;
    import com.pamakids.utils.dinput.Accel;
    import com.pamakids.utils.dinput.Micropoe;
    import com.pamakids.utils.dinput.MouseDown;
    import com.pamakids.utils.dinput.MouseMove;
    import com.pamakids.utils.dinput.MouseUp;
    import com.pamakids.weather.factory.AMoviePlayer;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.system.System;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import models.PosVO;
    
    import starling.animation.Juggler;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.extensions.ParticleDesignerPS;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    import starling.utils.Color;
    
    public class IsLandItem extends UIBase implements IItem
    {
        public var callHelpFun : Function;	
        private var islandDayOffX : int = 67;
        private var islandDayOffY : int = 392;
        private var lightOffX : int = 221;
        private var lightOffY : int = 320;
        private var assetsList : Array = [];
        
        //变量
        private var isLightClick : Boolean = false;
        private var flashLightIsOk : Boolean = false;
        public var isLightOn : Boolean = false;
        public var curState : int = 0;//白天，黑夜
        public var snowState : int = -1;
        private var active : Boolean = false;
        private var signsIsPlay : Boolean = false;
        private var vaneIsPlay : Boolean = false;
        private var fireWoodLen : Number = 0;
        
        //
        private var m_ice : Image;
        private var m_iceMarkLayer : Sprite = new Sprite();
        private var treeItem : TreeItem;
        private var mailBox : Image;
        private var mailBoxLid : MovieClip;
        private var envelope : MovieClip;
        private var signs : MovieClip;
        private var signsShader : Image;
        private var signsSnow : MovieClip;
        private var vane : MovieClip;
        private var vaneSnow : MovieClip;
        private var musicBreak : MusicBreak = new MusicBreak();
        private var bird : Birds;
        private var m_island : MovieClip;
        private var m_house : HouseItem;
        //窗户上的光
        private var m_houseLight : Image;
        private var m_snowIsland : Image;
        private var m_snowIslandGhost : Image;
        private var flyWhales : FlyWhales;
        private var flashLight : Image;
        private var middleTree1 : Image;
        //柴火
        private var firewood : Image;
        //柴火上的雪
        private var firewoodSnow : MovieClip;
        //门下面的光
        private var islandAssets : Array = ["island_day", "island_day"];
        private var islandAssets_iphone : Array = ["island_day","island_day"];
        private var treeBackAssets : Array = ["TreeBack", "TreeBackNight"];
        private var treeFrontAssets : Array = ["TreeFront", "TreeFrontNight"];
        private var snowIsLandAssets : Array = ["day_snow1", "day_snow2", "day_snow3"];
        private var snowIslandAssets_iphone : Array = ["day_snow1","day_snow2","day_snow3"];
        //蘑菇
        private var mushroomNames : Array = ["mushroom001", "mushroom002", "mushroom003", "mushroom005", "mushroom006"];
        private var mushroonPosList : Array = [new Point(592,430),new Point(564,460),new Point(649,573),new Point(271,438),new Point(217,499)];
        private var mushroomsList : Array = [];
        //树
        private var backTreeNames : Array = ["tree001", "tree002", "tree003", "tree004"];
        private var backTreePosList : Array = [new Point(783,499),new Point(737,431),new Point(335,343),new Point(217,453)];
        private var treeList : Array = [];
        
        private var islandTextures : Vector.<Texture> = new Vector.<Texture>();
        private var snowDTextures : Vector.<Texture> = new Vector.<Texture>();
        private var texturesList : Array = [];
        
        private var curAssetsIsOK : Boolean = true;
        private var curAssets : Array = [];
        private var curTextures : Vector.<Texture>;
        private var _juggler : Juggler = new Juggler();
        //存放邮箱,风向标,路牌
        private var adornList : Array = [];
        //
        public function IsLandItem()
        {
            super();
        }
        
        public function init():void
        {
            trace("加载陆地资源 : ");
            if(DeviceInfo.getDeviceType().indexOf("iphone") == -1){
                assetsList = [islandAssets, snowIsLandAssets];
            }else {
                newItemPos();
                assetsList = [islandAssets_iphone,snowIslandAssets_iphone];
            }
            texturesList = [islandTextures, snowDTextures];
            
            oldTime = getTimer();
            //逐帧加载资源
            this.addEventListener(Event.ENTER_FRAME, onUpdate);
            //island
            bird = new Birds();
            bird.touchable = false;
            bird.init();
            addChild(bird);
        }
        
        public function creatWhale():void {
            flyWhales.alpha = 0;
            flyWhales.touchable = false;
            TweenLite.to(flyWhales,0.5,{alpha : 1,onComplete : onShowFlyWhaleCom});
            flyWhales.visible = true;
        }
        
        //鲸鱼眨眼睛
        public function whaleBlink():void {
            flyWhales.startBlink();
        }
        
        private function onShowFlyWhaleCom():void 
        {
            m_island.visible = false;
        }
        
        
        private function newItemPos():void {
            for (var i : int = 0; i < mushroonPosList.length;i ++ ) {
                mushroonPosList[i].x = UICoordinatesFactory.getNewPosX(mushroonPosList[i].x);
                mushroonPosList[i].y = UICoordinatesFactory.getNewPosY(mushroonPosList[i].y);
            }
            
            for (var j : int = 0; j < backTreePosList.length;j ++ ) {
                backTreePosList[j].x = UICoordinatesFactory.getNewPosX(backTreePosList[j].x);
                backTreePosList[j].y = UICoordinatesFactory.getNewPosY(backTreePosList[j].y);
            }
        }
        
        
        private var oldTime : int = 0;
        //这块的得优化
        private function onUpdate(e:Event):void 
        {
            if ((getTimer() - oldTime) >= 100) {
                trace("加载岛资源 : ");
                if (curAssetsIsOK) {
                    curAssets = assetsList.shift();
                    curTextures = texturesList.shift();
                    curAssetsIsOK = false;
                }else {
                    if (curAssets.length > 0) {
                        var texture : Texture = getIslandTextures();
                        curTextures.push(texture);
                    }else {
                        curAssetsIsOK = true;
                        if (assetsList.length < 1) {
                            this.removeEventListener(Event.ENTER_FRAME, onUpdate);
                            installationTextures();
                        }
                    }
                }
                oldTime = getTimer();
            }
        }
        
        
        private function getIslandTextures() : Texture {
            return AssetManager.getInstance().getTexture(curAssets.shift());
        }
        
        //更新静态树的白天黑夜状态
        private function treeUpdateDayState(value : int = 0, list : Array = null):void {
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
        
        
        
        private var treeResTextures : AssetManager;
        private function setTreeTextures():void {
            treeResTextures = AssetManager.getInstance();
        }
        
        public function reStart():void {
            active = true;
            
            bird.reStart();
            treeItem.reStart();
            m_house.reStart();
        }
        
        public function reset():void {
            
            fireWoodLen = 0;
            isLightOn = false;
            curState = 0;//白天，黑夜
            snowState = -1;
            active = false;
            signsIsPlay = false;
            vaneIsPlay = false;
            flashLightIsOk = false;
            isLightClick = false;
            fireWoodLen = 0;
            
            
            flyWhales.visible = false;
            m_island.visible = true;
            m_houseLight.visible = false;
            iceMusicLayer.visible = false;
            
            mailBoxLid.currentFrame = 0;
            envelope.currentFrame = 0;
            signs.currentFrame = 0;
            vane.currentFrame = 0;
            envelope.visible = false;
            
            if (firewood) {
                firewood.alpha = 0;
                firewood.visible = false;
                TweenLite.killTweensOf(firewood);
            }
            
            if (mParticleSystem) {
                mParticleSystem.visible = false;
            }
            
            if (flashLight) {
                flashLight.visible = false;
                TweenLite.killTweensOf(flashLight);
            }
            
            if (m_houseLight) {
                TweenLite.killTweensOf(m_houseLight);
            }
            
            if (m_snowIsland) {
                m_snowIsland.visible = false;
                TweenLite.killTweensOf(m_snowIsland);
            }
            if (m_snowIslandGhost) {
                TweenLite.killTweensOf(m_snowIslandGhost);
                m_snowIslandGhost.visible = false;
            }
            
            if (signsSnow) {
                signsSnow.visible = false;
            }
            
            if (vaneSnow) {
                vaneSnow.visible = false;
            }
            
            if (m_snowIce4) {
                m_snowIce4.visible = false;
                TweenLite.killTweensOf(m_snowIce4);
            }
            
            treeUpdateDayState(0,treeList);
            treeUpdateDayState(0,mushroomsList);
            treeUpdateDayState(0, adornList);
            
            
            m_house.reset();
            musicBreak.reset();
            bird.reset();
            flyWhales.reset();
            iceMusicLayer.reset();
            treeItem.reset();
            
            changeToDefaultColor(m_island);
        
        }
        private function installationTextures():void 
        {	
            
            trace("安装岛的素材 : ");
            //backTree
            setTreeTextures();
            for (var i : int = 0; i < backTreeNames.length;i ++ ) {
                var sTree : Image = new Image(treeResTextures.getTexture(backTreeNames[i]));
                addChild(sTree);
                setDefaultColor(sTree);
                sTree.touchable = false;
                sTree.x = backTreePosList[i].x;
                sTree.y = backTreePosList[i].y;
                treeList.push(sTree);
            }
            
            flyWhales = new FlyWhales();
            flyWhales.touchable = false;
            flyWhales.init();
            
            m_island = new MovieClip(islandTextures);
            addChild(m_island);
            addChild(flyWhales);
            flyWhales.visible = false;
            m_island.touchable = false;
            m_island.x = UICoordinatesFactory.getNewPosX(islandDayOffX);
            m_island.y = UICoordinatesFactory.getNewPosY(islandDayOffY);
            setDefaultColor(m_island);
            
            middleTree1 = new Image(treeResTextures.getTexture("tree006"));
            middleTree1.addEventListener(TouchEvent.TOUCH,onTouchMiddleTree);
            addChild(middleTree1);
            middleTree1.x = UICoordinatesFactory.getNewPosX(580);
            middleTree1.y = UICoordinatesFactory.getNewPosY(268);
            setDefaultColor(middleTree1);
            treeList.push(middleTree1);
            
            
            setOtherTexture();
            
            //风向标
            vane = new MovieClip(vaneTextures);
            addChild(vane);
            setDefaultColor(vane);
            vane.pause();
            vane.loop = true;
            vane.touchable = false;
            vane.x = UICoordinatesFactory.getNewPosX(405);
            vane.y = UICoordinatesFactory.getNewPosY(225);
            vane.addEventListener(Event.COMPLETE,onVaneComHandler);
            
            adornList.push(vane);
            
            
            //
            m_house = new HouseItem();
            addChild(m_house);
            m_house.houseClikFun = onHouseLightTouch;
            m_house.init();
            
            
            var middleTree2 : Image = new Image(treeResTextures.getTexture("tree005"));
            middleTree2.touchable = false;
            addChild(middleTree2);
            middleTree2.x = UICoordinatesFactory.getNewPosX(605);
            middleTree2.y = UICoordinatesFactory.getNewPosY(315);
            setDefaultColor(middleTree2);
            treeList.push(middleTree2);
            creatTree();
            
            
            //牌子阴影
            signsShader = new Image(signsShaderTexture);
            addChild(signsShader);
            signsShader.touchable = false;
            signsShader.x = UICoordinatesFactory.getNewPosX(686);
            signsShader.y = UICoordinatesFactory.getNewPosY(466);
            //logo牌
            signs = new MovieClip(signsTextures);
            addChild(signs);
            
            setDefaultColor(signs);
            signs.touchable = false;
            signs.x = UICoordinatesFactory.getNewPosX(650);
            signs.y = UICoordinatesFactory.getNewPosY(381);
            adornList.push(signs);
            signs.loop = false;
            signs.addEventListener(Event.COMPLETE,onSignsComHandler);
            
            
            //蘑菇
            for (i = 0; i < mushroomNames.length;i ++ ) {
                var mushrooms : Image = new Image(treeResTextures.getTexture(mushroomNames[i]));
                addChild(mushrooms);
                setDefaultColor(mushrooms);
                mushrooms.touchable = false;
                mushrooms.x = mushroonPosList[i].x;
                mushrooms.y = mushroonPosList[i].y;
                mushroomsList.push(mushrooms);
            }
            
            
            m_houseLight = new Image(houseLightTexture);
            addChild(m_houseLight);
            m_houseLight.x = UICoordinatesFactory.getNewPosX(lightOffX);
            m_houseLight.y = UICoordinatesFactory.getNewPosY(lightOffY);
            m_houseLight.visible = false;
            m_houseLight.touchable = false;
            
            //邮箱
            
            mailBox = new Image(mailBoxTexture);
            addChild(mailBox);
            setDefaultColor(mailBox);
            mailBox.x = UICoordinatesFactory.getNewPosX(118);
            mailBox.y = UICoordinatesFactory.getNewPosY(493);
            mailBox.touchable = false;
            adornList.push(mailBox);
            //add------------
            /*			var tmail : Quad = new Quad(mailBox.width,mailBox.height,0x00FF00);
                        addChild(tmail);
                        tmail.x = mailBox.x;
                        tmail.y = mailBox.y;
                        tmail.alpha = 0.5;*/
            
            //add---------------
            mailBoxLid = new MovieClip(mailBoxLidTextures);
            addChild(mailBoxLid);
            setDefaultColor(mailBoxLid);
            mailBoxLid.x = UICoordinatesFactory.getNewPosX(87);
            mailBoxLid.y = UICoordinatesFactory.getNewPosY(507);
            mailBoxLid.loop = false;
            adornList.push(mailBoxLid);
            mailBoxLid.addEventListener(TouchEvent.TOUCH, onTouchMailHandler);
            mailBoxLid.addEventListener(Event.COMPLETE,onMailBoxLid);
            
            envelope = new MovieClip(envelopeTextures,6);
            addChild(envelope);
            envelope.visible = false;
            setDefaultColor(envelope);
            envelope.x = UICoordinatesFactory.getNewPosX(112);
            envelope.y = UICoordinatesFactory.getNewPosY(506);
            envelope.loop = false;
            adornList.push(envelope);
            envelope.addEventListener(Event.COMPLETE, onEnvelCom);
            envelope.addEventListener(TouchEvent.TOUCH, onTouchEnvelop);
        
        
        /*			//add
                    m_snowIsland = new Image(snowDTextures[0]);
                    addChild(m_snowIsland);
                    m_snowIsland.x = UICoordinatesFactory.getNewPosX(46);
                    m_snowIsland.y = UICoordinatesFactory.getNewPosY(263);*/
        
        }
        
        private var vaneTextures : Vector.<Texture>;
        private var signsShaderTexture : Texture;
        private var signsTextures : Vector.<Texture>;
        private var houseLightTexture : Texture;
        private var mailBoxTexture : Texture;
        private var mailBoxLidTextures : Vector.<Texture>;
        private var envelopeTextures : Vector.<Texture>;
        
        private var fireWoodTexture : Texture;
        private function setOtherTexture():void {
            vaneTextures = AssetManager.getInstance().getTextures("vanenormal");
            signsShaderTexture = AssetManager.getInstance().getTexture("shadow001");
            signsTextures = AssetManager.getInstance().getTextures("brand");
            houseLightTexture = AssetManager.getInstance().getTexture("houselight");
            mailBoxTexture = AssetManager.getInstance().getTexture("mail001");
            mailBoxLidTextures = AssetManager.getInstance().getTextures("openmail");
            envelopeTextures =AssetManager.getInstance().getTextures("letter");
            
            fireWoodTexture = AssetManager.getInstance().getTexture("gouhuo");
        }
        
        private function onSignsComHandler(e:Event):void 
        {
            trace("播放完毕了");
            _juggler.remove(signs);
            signsIsPlay = false;
            signs.currentFrame = 0;
            if (signsSnow) {
                signsSnow.currentFrame = 0;
                _juggler.remove(signsSnow);
            }
        }
        
        private function onVaneComHandler(e:Event):void 
        {
            _juggler.remove(vane);
            vaneIsPlay = false;
            vane.currentFrame = 0;
            if (vaneSnow) {
                vaneSnow.currentFrame = 0;
                _juggler.remove(vaneSnow);
            }
        }
        
        private function onMailBoxLid(e:Event):void 
        {
            //信封飞出来
            SoundManager.getInstance().play("mailbox");
        }
        
        private function onTouchEnvelop(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(envelope);
            if (touch) {
                if (touch.phase == TouchPhase.ENDED) {
                    if (this.callHelpFun != null) {
                        this.callHelpFun();
                        trace("执行了么");
                        _juggler.remove(mailBoxLid);
                        mailBoxLid.currentFrame = 0;
                        envelope.visible = false;
                    }
                }
            }
        }
        
        private function onEnvelCom(e:Event):void 
        {
        
        }
        
        private function onTouchMiddleTree(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(middleTree1);
            if (touch) {
                if (touch.phase == TouchPhase.ENDED) {
                    creatBird(new Point(UICoordinatesFactory.getNewPosX(600),310 * Screen.ratio));
                }
            }
        }
        
        
        public function openTheMail():void {
            trace("打开邮箱");
            _juggler.add(mailBoxLid);
            mailBoxLid.play();
            
            trace("信封飞出来");
            envelope.currentFrame = 0;
            envelope.visible = true;
            _juggler.add(envelope);
            envelope.play();
            SoundManager.getInstance().play("letter");
        
        }
        
        private function onTouchMailHandler(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(mailBoxLid);
            if (touch) {
                if (touch.phase == TouchPhase.ENDED) {
                    if (this.callHelpFun != null) {
                        this.callHelpFun();
                        _juggler.remove(mailBoxLid);
                        mailBoxLid.currentFrame = 0;
                        envelope.visible = false;
                    }
                }
            }
        }
        
        private function creatTree():void 
        {
            treeItem = new TreeItem();
            addChild(treeItem);
            treeItem.callBack = creatIceMusic;
            treeItem.callBird = creatBird;
            treeItem.callWood = creatWood;
            treeItem.init();
        }
        
        private function creatWood():void 
        {
            if (firewood == null) {
                firewood = new Image(fireWoodTexture);
                addChild(firewood);
                setDefaultColor(firewood);
                firewood.color = ColorUtils.getNewColor(firewood.data.defaultColor,ColorUtils.firewoodTrans);
                firewood.x = UICoordinatesFactory.getNewPosX(520);
                firewood.y = UICoordinatesFactory.getNewPosY(544);
                firewood.alpha = 0;
                
            }
            firewood.addEventListener(TouchEvent.TOUCH,onTouchFireWood);
            firewood.visible = true;
            firewood.touchable = true;
            if(firewood.alpha == 0){
                TweenLite.to(firewood, 1, { alpha : 1 } );
            }
        }
        
        //private var fireWoodLen : Number = 0;
        private function onTouchFireWood(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(firewood);
            var touchs : Vector.<Touch> = e.getTouches(stage);
            if (touch) {
                if (touchs.length < 2) {
                    if (touch.phase == TouchPhase.BEGAN) {
                        
                    }else if (touch.phase == TouchPhase.MOVED) {
                        var dy : int = touch.globalY - touch.previousGlobalY;
                        var dx : int = touch.globalX - touch.previousGlobalX;
                        fireWoodLen += (Math.abs(dx) + Math.abs(dy));
                        if (fireWoodLen >= 1000 * Screen.ratio) {
                            trace("可以着火了");
                            creatFire();
                            fireWoodLen = 0;
                            firewood.touchable = false;
                            firewood.removeEventListener(TouchEvent.TOUCH,onTouchFireWood);
                        }
                        trace("fireLen : " + fireWoodLen);
                    }else if (touch.phase == TouchPhase.ENDED) {
                        fireWoodLen = 0;
                    }
                }
            }
        
        }
        
        
        private var mParticleSystem : ParticleDesignerPS;
        //火
        private function creatFire():void 
        {
            if(mParticleSystem == null){
                mParticleSystem = new ParticleDesignerPS(BitmapDataLibrary.getFireParticleXml(), BitmapDataLibrary.getparticleTexture()); 
                mParticleSystem.emitterX = UICoordinatesFactory.getNewPosX(520) + firewood.width * 0.5; 
                mParticleSystem.emitterY = UICoordinatesFactory.getNewPosY(584);
                mParticleSystem.maxNumParticles = 70 * Screen.ratio;
                mParticleSystem.speed = 70;
                mParticleSystem.lifespan *= Screen.ratio;
                mParticleSystem.start();
                addChild(mParticleSystem);
                mParticleSystem.touchable = false;
                Starling.juggler.add(mParticleSystem);
            }else {
                if(mParticleSystem.visible == false){
                    mParticleSystem.visible = true;
                    mParticleSystem.start();
                    Starling.juggler.add(mParticleSystem);
                }
            }
            
            
            if (GameData.nightDesireList[1] == 0) {
                //PluginControl.BroadcastMsg(new PigHappyMsg());
            }
            GameData.nightDesireList[1] = 1;
            
            trace("向外广播消息，火找了");
            PluginControl.BroadcastMsg(new FireMsg());
        }
        
        //熄灭火
        private function putOutFire():void {
        
        }
        
        
        
        public function showGuangDian():void {
            if (flashLight == null) {
                var texture : Texture;
                if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
                    texture = AssetManager.getInstance().getTexture("guangdian");
                }else {
                    texture = AssetManager.getInstance().getTexture("guangdian");
                }
                flashLight = new Image(texture);
                flashLight.touchable = false;
                addChild(flashLight);
                flashLight.alpha = 0;
                flashLight.x = UICoordinatesFactory.getNewPosX(204);
                flashLight.y = UICoordinatesFactory.getNewPosY(252);
            }
            if(GameData.dayState == 0){
                flashLight.visible = false;
            }else {
                flashLight.visible = true;
            }
            if(flashLight.alpha == 0){
                TweenLite.to(flashLight, 1, { alpha : 1 } );
            }
            
            flashLightIsOk = true;
        
        }
        
        
        public function hideTheDian():void {
            if (flashLight) {
                flashLightIsOk = false;
                if (flashLight.alpha == 1) {
                    trace("关灯");
                    TweenLite.to(flashLight, 0.5, { alpha : 0, onComplete : hideDianCom } );
                }
            }
        }
        
        private function hideDianCom():void 
        {
            flashLight.visible = false;
        }
        
        /**
         * 隐藏气球
         */
        public function hideTheBalloon():void {
            m_house.hideTheBalloon();
        }
        
        public function closeHouse():void {
            m_house.closeHouse();
        }
        
        public function hideTheWhales():void {
            flyWhales.visible = false;
            m_island.visible = true;
        }
        
        public function onHouseLightTouch():void 
        {
            if(GameData.dayState == 1){
                if (!isLightClick) {
                    isLightClick = true;
                    if (isLightOn) {
                        isLightOn = false;
                        GameData.isHouseLightOn = false;
                        TweenLite.to(m_houseLight, 1, { alpha : 0,onComplete : lightClickCom } );
                        SoundManager.getInstance().play("light_off");
                    }else {
                        if (m_houseLight.parent) {
                            m_houseLight.alpha = 0;
                            TweenLite.to(m_houseLight, 1, { alpha : 1,onComplete : lightClickCom } );
                            m_houseLight.visible = true;
                            this.addChildAt(m_houseLight,this.numChildren - 1);
                        }
                        isLightOn = true;
                        GameData.isHouseLightOn = true;
                        SoundManager.getInstance().play("light_on");
                    }
                    trace("点击了屋子");
                }
            }
        }
        
        /**
         * 点击了邮箱
         * @param	e
         */
        private function onMailBoxClickHandler(e:MouseEvent):void 
        {
            trace("点击了邮箱");
            if (this.callHelpFun != null) {
                this.callHelpFun();
            }
        }
        
        private function creatBird(pos : Point):void 
        {
            bird.creatBirds(pos);
        }
        
        
        private var iceMusicLayer : IceMusicLayer = new IceMusicLayer();
        
        private function creatIceMusic():void 
        {
            iceMusicLayer.instanll();
            iceMusicLayer.instanllCom = instanllComHandler;
            iceMusicLayer.callMusic = playIceMusic;
            addChild(iceMusicLayer);
            iceMusicLayer.visible = false;
        }
        
        private var timer : Timer;
        private function instanllComHandler():void 
        {
            timer = new Timer(1000, 1);
            timer.start();
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComHandler);
            
            trace("陆地加载完毕了,开始加载小猪 : ");
        
        
        }
        
        private function onTimerComHandler(e:TimerEvent):void 
        {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComHandler);
            timer = null;
            PluginControl.BroadcastMsg(new LoadPigMsg());
            active = true;
        }
        
        private function playIceMusic(posX : int,posY : int):void 
        {
            musicBreak.creatMusicBreak(new Point(posX, posY));
            if (musicBreak.parent) {
                
            }else {
                trace("点击音乐效果2");
                addChild(musicBreak);
                musicBreak.visible = true;
                musicBreak.touchable = false;
            }
            
            trace("点击音乐效果1");
        
        }
        
        import flash.utils.getTimer;	
        public function updateHouse(value : int = 0):void {
            isLightOn = false;
            if (value == 0) {
                //白天
                curState = 0;
                GameData.dayState = 0;
                GameData.isHouseLightOn = false;
                m_island.currentFrame = 0;
                //add
                changeToDefaultColor(m_island);
                //add
                m_house.updateDay();
                iceMusicLayer.updateIce();
                treeUpdateDayState(0,treeList);
                treeUpdateDayState(0,mushroomsList);
                treeUpdateDayState(0,adornList);
                
                m_houseLight.visible = false;
                m_iceMarkLayer.visible = false;
                if (flashLight) {
                    flashLightIsOk = false;
                    flashLight.visible = false;
                }
                
                if (firewood) {
                    firewood.alpha = 0;
                    firewood.visible = false;
                }
                
                if (mParticleSystem) {
                    mParticleSystem.stop();
                    Starling.juggler.remove(mParticleSystem);
                    mParticleSystem.visible = false;
                }
                
                trace("GameData.snowState : " + GameData.snowState);
                if (GameData.snowState > 0) {
                    m_snowIslandGhost.alpha = 1;
                    m_snowIsland.alpha = 0;
                    TweenLite.to(m_snowIsland,1,{alpha : 1,onComplete : snowTweenComHandler, onCompleteParams : [GameData.snowState,"0"]});
                    m_snowIsland.texture = snowDTextures[int(GameData.snowState-1)];
                    if (m_snowIsland.color == m_snowIsland.data.defaultColor) {
                        
                    }else {
                        m_snowIsland.color = m_snowIsland.data.defaultColor;
                    }
                    
                    if (m_snowIce4 && GameData.snowState == 3) {
                        m_snowIce4.alpha = 0;
                        TweenLite.to(m_snowIce4,1,{alpha : 1});
                        m_snowIce4.color = m_snowIce4.data.defaultColor;
                    }
                }
                
            }else if (value ==1) {
                //晚上
                curState = 1;
                GameData.dayState = 1;
                m_island.currentFrame = 1;
                //add
                changeToDefaultColor(m_island,1);
                //add
                m_house.updateNight();
                treeUpdateDayState(1,treeList);
                treeUpdateDayState(1, mushroomsList);
                treeUpdateDayState(1,adornList);
                if (GameData.snowState > 0) {
                    m_snowIsland.alpha = 0;
                    TweenLite.to(m_snowIsland,1,{alpha : 1,onComplete : snowTweenComHandler, onCompleteParams : [GameData.snowState,"1"]});
                    m_snowIsland.texture = snowDTextures[int(GameData.snowState-1)];
                    m_snowIsland.color = ColorUtils.getNewColor(m_snowIsland.data.defaultColor,ColorUtils.snowColorTrans);
                    
                    if (m_snowIce4 && GameData.snowState == 3) {
                        m_snowIce4.alpha = 0;
                        TweenLite.to(m_snowIce4,1,{alpha : 1});
                        m_snowIce4.color = ColorUtils.getNewColor(m_snowIce4.data.defaultColor,ColorUtils.snowColorTrans);
                    }
                }
                iceMusicLayer.updateIce();
                if (GameData.snowState == 3) {
                    iceMusicLayer.visible = true;
                }
            }
            
            treeItem.updateDayState();
        }
        
        
        private function tweenComHandler(value : int):void {
            if (m_snowIslandGhost.visible) {
                
            }else{
                m_snowIslandGhost.visible = true;
            }
        
        }
        
        private function snowTweenComHandler(value : int,str : String):void {
            m_snowIslandGhost.texture = snowDTextures[int(value - 1)];
            if (str == "0") {
                m_snowIslandGhost.color = m_snowIslandGhost.data.defaultColor;
            }else {
                m_snowIslandGhost.color = ColorUtils.getNewColor(m_snowIslandGhost.data.defaultColor,ColorUtils.islandColorTrans);
            }
            m_snowIslandGhost.visible = true;
            if (m_snowIslandGhost.alpha != 1) {
                m_snowIslandGhost.alpha = 1;
            }else {
                m_snowIslandGhost.alpha = 0;
            }
        }
        
        private var signsSnowTextures : Vector.<Texture>;
        private var vaneSnowTextures : Vector.<Texture>;
        private function setSignSnowTexture():void {
            signsSnowTextures = AssetManager.getInstance().getTextures("middlesnow");
            vaneSnowTextures = AssetManager.getInstance().getTextures("vanesnow");
        }
        
        public function updateSnowState(value : int):void {
            GameData.snowState = value;
            if (m_snowIsland) {
                
            }else {
                m_snowIslandGhost = new Image(snowDTextures[0]);
                m_snowIsland = new Image(snowDTextures[0]);
                addChild(m_snowIslandGhost);
                m_snowIslandGhost.data.defaultColor = m_snowIslandGhost.color;
                m_snowIslandGhost.touchable = false;
                m_snowIslandGhost.x = UICoordinatesFactory.getNewPosX(46);
                m_snowIslandGhost.y = UICoordinatesFactory.getNewPosY(263);
                m_snowIslandGhost.visible = false;	
                
                
                m_snowIsland.data.defaultColor = m_snowIsland.color;
                m_snowIsland.touchable = false;
                m_snowIsland.x = UICoordinatesFactory.getNewPosX(46);
                m_snowIsland.y = UICoordinatesFactory.getNewPosY(263);
                m_snowIsland.alpha = 0;
                this.setChildIndex(treeItem, this.numChildren - 1);
                this.setChildIndex(iceMusicLayer, this.numChildren - 1);
                addChild(m_snowIsland);
                
                this.setChildIndex(mailBoxLid, this.numChildren - 1);
                if(musicBreak.parent){
                    this.setChildIndex(musicBreak,this.numChildren - 1);
                }
                
                this.setChildIndex(signs, this.numChildren - 1);
                
                setSignSnowTexture();
                
                signsSnow = new MovieClip(signsSnowTextures);
                addChild(signsSnow);
                setDefaultColor(signsSnow);
                adornList.push(signsSnow);
                signsSnow.loop = false;
                
                signsSnow.touchable = false;
                signsSnow.x = UICoordinatesFactory.getNewPosX(650);
                signsSnow.y = UICoordinatesFactory.getNewPosY(381);
                signsSnow.pause();
                
                
                vaneSnow = new MovieClip(vaneSnowTextures);
                this.addChildAt(vaneSnow,this.getChildIndex(vane) + 1);
                setDefaultColor(vaneSnow);
                adornList.push(vaneSnow);
                vaneSnow.loop = false;
                vaneSnow.touchable = false;
                vaneSnow.x = UICoordinatesFactory.getNewPosX(405);
                vaneSnow.y = UICoordinatesFactory.getNewPosY(225);
                vaneSnow.pause();
                
                if(flashLight){
                    this.setChildIndex(flashLight, (this.numChildren - 1));
                }
            }
            
            trace("value : " + value);
            if (value == 0) {
                trace("雪该化没了吧");
                snowState = 0;
                
                GameData.resetAchievements(0);
                
                TweenLite.to(m_snowIsland,1,{alpha : 0});
                TweenLite.to(m_snowIslandGhost, 1, { alpha : 0 } );
                
                signsSnow.visible = false;
                vaneSnow.visible = false;
            }else {
                signsSnow.visible = true;
                vaneSnow.visible = true;
            }
            
            if (curState == 0) {
                //白天
                if (value == 4) {
                    TweenLite.to(m_snowIsland,1,{alpha : 0});
                }else {
                    snowState = value;
                    if(value == -1){
                        
                    }else if(value >= 1){
                        if (value >= int(getCurIndex(m_snowIsland.texture)) + 1) {
                            if (value == 1) {
                                m_snowIslandGhost.alpha = 0;
                            }else {
                                m_snowIslandGhost.alpha = 1;
                            }
                            
                            m_snowIsland.alpha = 0;
                            m_snowIsland.texture = snowDTextures[int(value - 1)];
                            m_snowIsland.color = m_snowIsland.data.defaultColor;
                            TweenLite.to(m_snowIsland, 1, { alpha : 1, onComplete : snowTweenComHandler, onCompleteParams : [value, "0"] } );
                            
                            //雪上的冰
                            if(value == 3){
                                creatSnow4();
                                m_snowIce4.color = m_snowIce4.data.defaultColor;
                                TweenLite.to(m_snowIce4, 1, { alpha : 1 } );
                            }
                        }else {
                            m_snowIslandGhost.alpha = 1;
                            m_snowIslandGhost.texture = snowDTextures[int(value - 1)];
                            m_snowIslandGhost.color = m_snowIslandGhost.data.defaultColor;
                            m_snowIsland.alpha = 1;
                            TweenLite.to(m_snowIsland, 1, { alpha : 0, onComplete : snowLossComHandler, onCompleteParams : [value, "0"] } );
                            
                            //
                            if(value == 2){
                                m_snowIce4.color = m_snowIce4.data.defaultColor;
                                m_snowIce4.alpha = 1;
                                TweenLite.to(m_snowIce4, 1, { alpha : 0 } );
                            }
                        }
                        m_snowIslandGhost.visible = true;
                        m_snowIsland.visible = true;
                    }
                    
                    if (value == 2) {
                        iceMusicLayer.visible = false;
                    }
                    
                    //add
                    //add
                    
                    changeToDefaultColor(signsSnow, 0);
                    changeToDefaultColor(vaneSnow,0);
                }
            }else if (curState == 1) {
                
                //灭掉火把
                if (mParticleSystem) {
                    firewood.touchable = false;
                    mParticleSystem.stop();
                    Starling.juggler.remove(mParticleSystem);
                    mParticleSystem.visible = false;
                }
                
                
                snowState = value;
                if (value == 4) {
                    trace("下雪下到4了啊？");
                    TweenLite.to(m_snowIsland,1,{alpha : 0});
                }else {
                    snowState = value;
                    if (value == -1) {
                        
                    }else if(value >= 1) {
                        if (value >= int(getCurIndex(m_snowIsland.texture)) + 1) {
                            
                            if (value == 1) {
                                m_snowIslandGhost.alpha = 0;
                            }else {
                                m_snowIslandGhost.alpha = 1;
                            }
                            
                            m_snowIsland.alpha = 0;
                            m_snowIsland.texture = snowDTextures[int(value - 1)];
                            m_snowIsland.color = ColorUtils.getNewColor(m_snowIsland.data.defaultColor,ColorUtils.snowColorTrans);
                            TweenLite.to(m_snowIsland, 1, { alpha : 1, onComplete : snowTweenComHandler, onCompleteParams : [value, "1"] } );
                            
                            //
                            if(value == 3){
                                creatSnow4();
                                m_snowIce4.color = ColorUtils.getNewColor(m_snowIce4.data.defaultColor,ColorUtils.snowColorTrans);
                                TweenLite.to(m_snowIce4, 1, { alpha : 1 } );
                            }
                            
                        }else {
                            m_snowIslandGhost.alpha = 1;
                            m_snowIslandGhost.texture = snowDTextures[int(value - 1)];
                            m_snowIslandGhost.color = ColorUtils.getNewColor(m_snowIslandGhost.data.defaultColor,ColorUtils.islandColorTrans);;
                            m_snowIsland.alpha = 1;
                            TweenLite.to(m_snowIsland, 1, { alpha : 0, onComplete : snowLossComHandler, onCompleteParams : [value, "1"] } );
                            
                            //
                            if(value == 2){
                                m_snowIce4.color = ColorUtils.getNewColor(m_snowIce4.data.defaultColor,ColorUtils.snowColorTrans);
                                m_snowIce4.alpha = 1;
                                TweenLite.to(m_snowIce4, 1, { alpha : 0 } );
                            }
                        }
                        
                        
                        if (value == 3) {
                            iceMusicLayer.visible = true;
                        }
                        
                        m_snowIslandGhost.visible = true;
                        m_snowIsland.visible = true;
                        
                    }
                }
                
                changeToDefaultColor(signsSnow, 1);
                changeToDefaultColor(vaneSnow,1);
            }
            treeItem.updateSnowState();
        }
        
        private var m_snowIce4 : Image;
        //下第三层雪的时候，上面要盖一层冰
        private function creatSnow4():void {
            if (m_snowIce4) {
                
            }else {
                
                var texture : Texture;
                if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
                    texture = AssetManager.getInstance().getTexture("day_snow4");
                }else {
                    texture = AssetManager.getInstance().getTexture("day_snow4");
                }
                
                m_snowIce4 = new Image(texture);
                addChild(m_snowIce4);
                m_snowIce4.touchable = false;
                setDefaultColor(m_snowIce4);
            }
            m_snowIce4.visible = true;
            m_snowIce4.alpha = 0;
            m_snowIce4.x = UICoordinatesFactory.getNewPosX(192);
            m_snowIce4.y = UICoordinatesFactory.getNewPosY(432);
        }
        
        private function getCurIndex(texure : Texture):int {
            for (var i : int = 0; i < snowDTextures.length;i ++ ) {
                if (texure == snowDTextures[i]) {
                    return i;
                    break;
                }
            }
            return -1;
        }
        
        private function snowLossComHandler(value : int,str : String):void 
        {	
            m_snowIsland.texture = snowDTextures[int(value - 1)];
            if (str == "0") {
                m_snowIsland.color = m_snowIsland.data.defaultColor;
            }else {
                m_snowIsland.color = ColorUtils.getNewColor(m_snowIsland.data.defaultColor,ColorUtils.snowColorTrans);
            }
        }
        
        
        private function lightClickCom():void 
        {
            isLightClick = false;
            if (GameData.isTowerLightOn && GameData.isHouseLightOn) {
                showGuangDian();
            }else {
                hideTheDian();
            }
        }
        
        
        private var signOldTime : uint;
        private var signTotalTime : uint;
        public function update(data:*):void
        {	
            if (active) {
                treeItem.update(null);
                _juggler.advanceTime(0.03);
                
                if (Micropoe.mactivityLevel >= GameData.MICACTIVELEVEL_SIGN) {
                    trace("麦克风");
                    
                    signTotalTime += 1000 / GameData.frameRate;
                    
                    if(signTotalTime >= GameData.GETSIGNTIME){
                        signTotalTime = 0;
                        if(flashLightIsOk == false && isLightOn == false){
                            if (signsIsPlay == false) {
                                signsIsPlay = true;
                                signs.currentFrame = 0;
                                signs.play();
                                _juggler.add(signs);
                                
                                SoundManager.getInstance().play("signs");
                                if (signsSnow) {
                                    signsSnow.currentFrame = 0;
                                    signsSnow.play();
                                    _juggler.add(signsSnow);
                                }
                                
                            }
                        }
                        
                        if (vaneIsPlay == false) {
                            vaneIsPlay = true;
                            vane.currentFrame = 0;
                            vane.play();
                            _juggler.add(vane);
                            SoundManager.getInstance().play("vane");
                            if (vaneSnow) {
                                vaneSnow.currentFrame = 0;
                                vaneSnow.play();
                                _juggler.add(vaneSnow);
                            }
                        }
                    }
                    
                    
                }else{
                    //
                    signTotalTime = 0;
                }
                
            }else{
                signTotalTime = 0;
            }
            musicBreak.update();	
            bird.update(null);
        }
        
        public function destroy():void
        {
            
            
            
            /*			m_house.destory();
                        removeChild(m_house, true);*/
            
            m_house.reset();
            musicBreak.reset();
            bird.reset();
            flyWhales.reset();
            iceMusicLayer.reset();
            treeItem.reset();
            //removeChild(treeItem, true);
            //removeChild(musicBreak, true);
            
            //bird.destroy();
            //removeChild(bird,true);
            
            //flyWhales.destroy();
            //removeChild(flyWhales, true);
            
            //iceMusicLayer.destory();
            //removeChild(iceMusicLayer,true);
            
            
            //treeItem.destroy();
            //removeChild(treeItem,true);
            
            
            removeEventListeners();
            removeChildren();
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

