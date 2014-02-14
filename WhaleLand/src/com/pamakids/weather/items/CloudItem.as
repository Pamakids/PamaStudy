package com.pamakids.weather.items
{
    import com.greensock.TweenLite;
    import com.greensock.easing.Bounce;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.DarkCloudMsg;
    import com.pamakids.core.msgs.PigHappyMsg;
    import com.pamakids.core.msgs.SnowMsg;
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.utils.ColorUtils;
    import com.pamakids.utils.DeviceInfo;
    import com.pamakids.utils.Screen;
    import com.pamakids.utils.math.MathRect;
    import com.pamakids.weather.factory.AMoviePlayer;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    
    import models.PosVO;
    
    import starling.display.DisplayObject;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    
    public class CloudItem extends UIBase
    {
        
        public var callBack : Function;
        
        //常量参数
        private var bounce : Number = 0.9;
        private var smallW : int = 140;
        private var smallH : int = 92;
        private var cloudStatesStr : Array = ["minismall","smallcloud", "midllecloud", "biggerCloud","bigcloud"];
        //可以下雪的条件
        private var maxM : int = 6;
        //天空中可以存在云的状态之和峰值
        private var maxTotalM : int = 10;
        
        //变量
        private var m_clouds : Array = [];
        private var cloudPool : Array = [];
        private var active : Boolean = false;
        private var hasSnowed : Boolean = false;
        //0 : 白天 1 : 黑夜
        private var curDayStr : String = "0";
        
        //
        private var m_darkCloud : DarkCloud;
        private var m_cloud : AMoviePlayer;
        public function CloudItem()
        {
            super();
        }
        
        public function init():void
        {
            trace("云彩加载中 : ");
            setCloudTextureAtls();
            //1号云彩
            var mostSmallTextures : Vector.<Texture> = new Vector.<Texture>();
            var mostSmallTexture : Texture = cloudResTextureAlts.getTexture("cloudnew001");
            mostSmallTextures.push(mostSmallTexture);
            mostSmallTextures.push(mostSmallTexture);
            //2号云彩
            var smallCloudTextures : Vector.<Texture> = new Vector.<Texture>();
            var smallCloudTexture : Texture = cloudResTextureAlts.getTexture("cloud001");
            smallCloudTextures.push(smallCloudTexture);
            smallCloudTextures.push(smallCloudTexture);
            //3号云彩
            var middlerCloudTextures : Vector.<Texture> = new Vector.<Texture>();
            var middleCloudTexture : Texture = cloudResTextureAlts.getTexture("cloud002");
            middlerCloudTextures.push(middleCloudTexture);
            middlerCloudTextures.push(middleCloudTexture);
            
            //4号云彩
            var biggerCloudTextures : Vector.<Texture> = new Vector.<Texture>();
            var biggerCloudTexture : Texture = cloudResTextureAlts.getTexture("cloudnew002");
            biggerCloudTextures.push(biggerCloudTexture);
            biggerCloudTextures.push(biggerCloudTexture);
            //5号云彩
            var bigCloudTextures : Vector.<Texture> = new Vector.<Texture>();
            var bigCloudTexture : Texture = cloudResTextureAlts.getTexture("cloud003");
            bigCloudTextures.push(bigCloudTexture);
            bigCloudTextures.push(bigCloudTexture);
            
            m_cloud = new AMoviePlayer();
            m_cloud.addAniamtions("minismall", mostSmallTextures);
            m_cloud.addAniamtions("smallcloud", smallCloudTextures);
            m_cloud.addAniamtions("midllecloud", middlerCloudTextures);
            m_cloud.addAniamtions("biggerCloud", biggerCloudTextures);
            m_cloud.addAniamtions("bigcloud", bigCloudTextures);
            m_cloud.pivotX = m_cloud.width * 0.5;
            m_cloud.pivotY = m_cloud.height * 0.5;
            m_cloud.gotoFrame(0,"minismall");
            registerCloud();
            m_darkCloud = new DarkCloud();
            
            if (this.callBack != null) {
                this.callBack();
            }
        }
        
        public function reset():void {
            //m_clouds = [];
            //cloudPool = [];
            active = false;
            hasSnowed = false;
            curDayStr = "0";
            
            //隐藏所有云彩
            clearAllCloud();
            m_darkCloud.visible = false;
            m_darkCloud.reset();
        }
        
        public function reStart():void {
            registerCloud();
        }
        
        public function destroy():void
        {
            m_darkCloud.destroy();
            if (m_darkCloud.parent) {
                removeChild(m_darkCloud, true);
            }
            
            removeEventListeners();
            removeChildren();
        }
        
        public function update(data:*):void
        {
            m_darkCloud.update(null);
            if (active) {	
                var len:int = m_clouds.length;
                for( var i:int = 0; i < m_clouds.length; i++ )
                {
                    var cloud : AMoviePlayer = (m_clouds[i] as AMoviePlayer);
                    if(cloud && cloud.data.active == true){
                        cloud.x += cloud.data.vx;
                        cloud.data.vx *= bounce;
                        if(Math.abs(cloud.data.vx) < 0.1){
                            cloud.data.vx = 0;
                        }
                        if(cloud.x > Screen.wdth){
                            cloud.x = cloud.width * 0.5 + 10;
                        }else if(cloud.x <= 0){
                            cloud.x = Screen.wdth - cloud.width * 0.5 -10;
                        }
                    }
                }
            }
        }
        
        /**
         * 白天
         * */
        public function startDay():void {
            curDayStr = "0";
            var len : int = m_clouds.length;
            for (var i : int = 0; i < len; i ++ ) {
                var state : int = (m_clouds[i] as AMoviePlayer).data.state;
                (m_clouds[i] as AMoviePlayer).gotoFrame(int(curDayStr), cloudStatesStr[state - 1]);
                (m_clouds[i] as AMoviePlayer).curImage.color = (m_clouds[i] as AMoviePlayer).curAnimation.defaultColor;
            }	
        }
        
        /**
         * 晚上
         * */
        public function startNight():void {
            curDayStr = "1";
            var len : int = m_clouds.length;
            for (var i : int = 0; i < len; i ++ ) {
                var state : int = (m_clouds[i] as AMoviePlayer).data.state;
                (m_clouds[i] as AMoviePlayer).gotoFrame(int(curDayStr), cloudStatesStr[state - 1]);
                var color : int = (m_clouds[i] as AMoviePlayer).curAnimation.defaultColor;
                (m_clouds[i] as AMoviePlayer).curImage.color = ColorUtils.getNewColor(color,ColorUtils.cloudColorTrans);
            }
        }
        
        public function creatNewCloud(data : Object):void {
            //如果天空中云彩的状态相加小于10
            var totalCount : int = getTheCloudM();
            GameData.cloudsM = totalCount;
            if(totalCount < maxTotalM){
                var cloud : AMoviePlayer = getTheCloudFromPool();
                if (cloud == null) {
                    cloud = m_cloud.copy();
                    this.addChildAt(cloud,this.numChildren - 1);
                    cloud.addEventListener(TouchEvent.TOUCH, onCloudTouch);
                }else {
                    this.setChildIndex(cloud,this.numChildren - 1);	
                }
                cloud.data.vx = 0;
                cloud.data.active = false;
                cloud.data.hasTouch = false;
                cloud.data.state = 1;
                cloud.data.m = cloud.data.state + 1;
                cloud.x = data.posX;
                cloud.y = 750 ;
                cloud.data.defaultX = cloud.x;
                cloud.data.defaultY = cloud.y;
                cloud.visible = true;
                cloud.touchable = false;
                cloud.gotoFrame(0, "minismall");
                cloud.scaleX = cloud.scaleY = 0.6;
                cloud.curImage.color = cloud.curAnimation.defaultColor;
                m_clouds.push( cloud );
                TweenLite.to(cloud, 0.5, {x:data.posX, y:660 ,onComplete : cloudCreatOver,onCompleteParams : [cloud,data]});	
            }else {
                trace("天空中已经10朵云彩了");
                GameData.dayDesireList[1] = 1;
            }
            totalCount = getTheCloudM();
            GameData.cloudsM = totalCount;
            if (totalCount >= maxM) {
                GameData.setWishComTime(1,getTimer());
                if (GameData.dayDesireList[1] == 0) {
                    PluginControl.BroadcastMsg(new PigHappyMsg());
                }
                GameData.dayDesireList[1] = 1;
            }
            trace("cloudList.length : " + m_clouds.length);
        }
        
        
        //如果下雪的话清除所有残留的云彩
        public function clearAllCloud():void {
            for (var i : int = 0; i < m_clouds.length; i ++ ) {
                m_clouds[i].visible = false;
                TweenLite.killTweensOf(m_clouds[i]);
                cloudPool.push(m_clouds[i]);
            }
            m_clouds = [];
        }
        
        
        private var cloudResTextureAlts : AssetManager;
        private function setCloudTextureAtls():void {
            cloudResTextureAlts = AssetManager.getInstance();
        }
        
        private function onCloudTouch(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(e.currentTarget as starling.display.DisplayObject);
            var curTar : AMoviePlayer = e.currentTarget as AMoviePlayer;
            var dir : int = 0;
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    curTar.data.beginTime = getTimer();
                    curTar.data.oldX = touch.globalX/PosVO.scale;
                    curTar.data.offX = touch.globalX/PosVO.scale - curTar.x;
                    curTar.data.offY = touch.globalY/PosVO.scale - curTar.y;
                    curTar.data.hasTouch = true;
                }else if (touch.phase == TouchPhase.MOVED) {
                    curTar.data.isMove = true;
                    
                    if (touch.globalX/PosVO.scale - curTar.data.offX - curTar.width * 0.5 <= 0) {
                        curTar.x = curTar.width * 0.5;
                    }else if (touch.globalX/PosVO.scale - curTar.data.offX + curTar.width * 0.5 >= 1024) {
                        curTar.x = 1024 - curTar.width * 0.5;
                    }else {
                        curTar.x = touch.globalX/PosVO.scale - curTar.data.offX;
                    }
                    
                    if (touch.globalY/PosVO.scale - curTar.data.offY - curTar.height * 0.5 <= 0) {
                        curTar.y = curTar.height * 0.5;
                    }else if (touch.globalY/PosVO.scale - curTar.data.offY + curTar.height * 0.5 >= 220 ) {
                        curTar.y = 220  - curTar.height * 0.5;
                    }else {
                        curTar.y = touch.globalY/PosVO.scale - curTar.data.offY;
                    }
                    checkCollsion(curTar);
                }else if (touch.phase == TouchPhase.ENDED) {
                    if (curTar.data.isMove) {
                        var hasPassTime : uint = getTimer() - curTar.data.beginTime;
                        dir = (touch.globalX/PosVO.scale - curTar.data.oldX) * 1 > 0?1 : -1;
                        var passLen : Number = (touch.globalX/PosVO.scale - curTar.data.oldX);
                        if (hasPassTime < 200 && Math.abs(passLen) >= 20) {
                            curTar.data.vx = (touch.globalX/PosVO.scale - curTar.data.oldX) / (300 - hasPassTime) * 30 ;
                            active = true;
                        }
                    }else {
                        onCLoudClick(e);
                    }
                    curTar.data.isMove = false;
                    curTar.data.hasTouch = false;
                }
            }
        }
        
        private function onCLoudClick(e : TouchEvent):void {
            TweenLite.to(e.currentTarget, 0.1, { scaleX:0.7, scaleY:0.7, onComplete : nextTweenHandler, onCompleteParams : [e.currentTarget] } );
            (e.currentTarget as AMoviePlayer).data.vx = 0;
        }
        
        private function registerCloud():void {
            m_clouds = [];	
            trace("sss : " + Screen.wRatio + "  " + Screen.ratio);
            var clouRect : Rectangle = new Rectangle(100 ,100 ,900 ,200 );
            var posList : Array = MathRect.getPosList(clouRect,[new Point(smallW ,smallH )],4);
            for( var i:int = 0; i < 2; i++ )
            {
                
                //
                var cloud : AMoviePlayer = getTheCloudFromPool();
                if (cloud == null) {
                    cloud = m_cloud.copy();
                    addChild(cloud);
                    cloud.addEventListener(TouchEvent.TOUCH, onCloudTouch);
                }else {
                    this.setChildIndex(cloud,this.numChildren - 1);	
                }
                cloud.data.vx = 0;
                cloud.data.active = true;
                cloud.data.hasTouch = false;
                cloud.data.state = 1;
                cloud.data.m = cloud.data.state + 1;
                
                
                cloud.x = (posList[i] as Point).x;
                cloud.y = (posList[i] as Point).y;
                cloud.data.defaultX = cloud.x;
                cloud.data.defaultY = cloud.y;
                
                
                cloud.visible = true;
                cloud.touchable = true;
                cloud.gotoFrame(0, "minismall");
                cloud.curImage.color = cloud.curAnimation.defaultColor;
                m_clouds.push( cloud );
            }
        }
        
        
        private function nextTweenHandler(cloud : AMoviePlayer):void {
            TweenLite.to(cloud, 0.5, {scaleX:1, scaleY:1, ease : Bounce.easeOut,onComplete : tweenOverHandler,onCompleteParams : [cloud]});
        }
        
        private function tweenOverHandler(cloud : AMoviePlayer):void {
            //cloud.data.active = true;
        }
        
        private function getTheCloudFromPool() : AMoviePlayer {
            if (cloudPool.length > 0) {
                return cloudPool.shift();
            }
            return null;
        }
        
        private function cloudCreatOver(cloud : AMoviePlayer,data : Object):void 
        {
            TweenLite.to(cloud,0.3,{alpha : 0,onComplete : cloudVisile,onCompleteParams : [cloud,data]});
        }
        
        private function cloudVisile(cloud : AMoviePlayer,data : Object):void 
        {
            cloud.y = data.posY;
            cloud.alpha = 0;
            TweenLite.to(cloud, 1, { y:data.posY - 10 , alpha : 1, scaleX : 1,scaleY : 1,ease:Bounce.easeOut,onComplete : creatIsOkHandler,onCompleteParams : [cloud]} );
            SoundManager.getInstance().play("newcloud");
        }
        
        private function creatIsOkHandler(cloud:AMoviePlayer):void 
        {
            cloud.data.active = true;
            cloud.touchable = true;
        }
        
        
        /**
         * 获得天空中各种云的状态和
         * 小云 --- 0
         * 中云 ----2
         * 大云 --- 4
         * */
        private function getTheCloudM() : int {
            var count : int = 0;
            for (var i : int = 0; i < m_clouds.length;i ++ ) {
                var state : int = (m_clouds[i] as AMoviePlayer).data.state;
                count += state;
            }
            return count;
        }
        
        
        private function getLen(list : Array):int{
            var count : int = 0;
            for(var i : int = 0;i < list.length;i ++){
                if((list[i] as AMoviePlayer).data.hasTouch){
                    count ++;
                }
            }
            
            return count;
        }
        
        private function checkCollsion(tar : AMoviePlayer):void {
            var objectA : AMoviePlayer  = tar; 
            for (var j : int =  m_clouds.length - 1; j >= 0; j --) {
                if(objectA){
                    var objectB : AMoviePlayer = m_clouds[j];
                    if (objectB&&objectA!=objectB) 
                    {
                        if (objectA.hitTestByRect(objectB.aRect) && objectA.data.active == true && objectB.data.active == true && objectA != objectB) {
                            if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
                                
                            }else {
                                objectA.data.hasTouch = true;
                                objectB.data.hasTouch = true;
                            }
                            if(objectA.data.hasTouch && objectB.data.hasTouch){
                                if ((objectA.data.state + objectB.data.state) < 6) {
                                    var tlen : int;
                                    tlen = getLen(m_clouds);
                                    if (tlen == 2) {
                                        objectA.touchable = false;
                                        objectB.touchable = false;
                                        objectA.data.hasTouch = false;
                                        objectB.data.hasTouch = false;
                                        objectA.data.active = false;
                                        objectB.data.active = false;
                                        objectB.visible = false;
                                        objectA.x = objectA.x + (objectB.x - objectA.x) * 0.5;
                                        objectA.y = objectA.y + (objectB.y - objectA.y) * 0.5;
                                        var curState : int = objectA.data.state;
                                        TweenLite.to(objectA, 0.2, { scaleX:0.7, scaleY:0.7, onComplete : tweenBig, onCompleteParams : [objectA, (curState +  objectB.data.state)] } );
                                        trace("cloudM~~~~~~~~~~~~~ : " + getTheCloudM());
                                        objectA.data.state = objectA.data.state + objectB.data.state;
                                        m_clouds.splice(j, 1);
                                        cloudPool.push(objectB);
                                        GameData.cloudsM = getTheCloudM();
                                        SoundManager.getInstance().play("cloud", 1, 0, SoundManager.getInstance().cloudSoundTransform);
                                        break;
                                    }
                                }else if((objectA.data.state + objectB.data.state) >= maxM){
                                    var tlen : int;
                                    tlen = getLen(m_clouds);
                                    if (tlen == 2) {
                                        objectA.data.active = false;
                                        objectA.data.hasTouch = false;
                                        objectA.touchable = false;
                                        objectB.touchable = false;
                                        objectA.data.hasTouch = false;
                                        objectB.data.hasTouch = false;
                                        objectA.data.active = false;
                                        objectB.data.active = false;
                                        
                                        TweenLite.to(objectA,1,{alpha : 0,onComplete : tweenComHandler, onCompleteParams : [objectA]});
                                        TweenLite.to(objectB,1,{alpha : 0,onComplete : tweenComHandler, onCompleteParams : [objectB]});
                                        m_clouds.splice(j,1);
                                        removeCurCloud(objectA);
                                        cloudPool.push(objectA);
                                        cloudPool.push(objectB);
                                        trace("cloudM~~~~~~~~~~~~~ : " + getTheCloudM());
                                        GameData.cloudsM = getTheCloudM();
                                        startDarkCloud();
                                        break;
                                    }
                                }
                            }
                        }
                    } 
                }
            }
        }
        
        private function removeCurCloud(tar : AMoviePlayer):void {
            for (var i : int = m_clouds.length - 1; i >= 0;i -- ) {
                if (m_clouds[i] == tar) {
                    m_clouds.splice(i,1);
                    break;
                }
            }
        }
        
        private function tweenBig(cloud : AMoviePlayer,curState : int):void 
        {
            cloud.scaleX = 0.5;
            cloud.scaleY = 0.5;
            cloud.gotoFrame(int(curDayStr), cloudStatesStr[curState - 1]);
            if (curDayStr == "0") {
                cloud.curImage.color = cloud.curAnimation.defaultColor;
            }else if(curDayStr == "1"){
                var color : int = cloud.curAnimation.defaultColor;
                cloud.curImage.color = ColorUtils.getNewColor(color,ColorUtils.cloudColorTrans);
            }
            TweenLite.to(cloud, 0.5, {scaleX:1, scaleY:1, ease : Bounce.easeOut,onComplete : tweenBigOverHandler,onCompleteParams : [cloud]});
        }
        
        private function tweenBigOverHandler(cloud : AMoviePlayer):void 
        {
            cloud.data.active = true;
            cloud.touchable = true;
        }
        
        
        private function tweenComHandler(tar : starling.display.DisplayObject):void {
            tar.visible = false;
            tar.alpha = 1;
        }
        
        
        private function startDarkCloud():void 
        {
            hasSnowed = false;
            GameData.isDarkCloud = true;
            m_darkCloud.init();
            m_darkCloud.visible = true;
            addChild(m_darkCloud);
            var msg : DarkCloudMsg = new DarkCloudMsg();
            msg.data = true;
            PluginControl.BroadcastMsg(msg);
            var snowMsg : SnowMsg = new SnowMsg();
            snowMsg.data = 1;
            PluginControl.BroadcastMsg(snowMsg);
            GameData.setWishComTime(2,getTimer());
        }
    }
}

