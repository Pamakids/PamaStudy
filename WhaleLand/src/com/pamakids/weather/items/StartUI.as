package com.pamakids.weather.items
{
    import com.greensock.TweenLite;
    import com.greensock.easing.Bounce;
    import com.pamakids.core.msgs.StartUIEndMsg;
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.uimanager.UIGlobal;
    import com.pamakids.uimanager.UIManager;
    import com.pamakids.utils.DateUtils;
    import com.pamakids.utils.Screen;
    import com.pamakids.utils.dinput.Micropoe;
    import com.pamakids.utils.dinput.MouseDown;
    import com.pamakids.utils.dinput.MouseMove;
    import com.pamakids.utils.dinput.MouseUp;
    import com.pamakids.utils.dinput.TouchEvent3D;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.AssetsFactory;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.GradientType;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.BlurFilter;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.system.System;
    import flash.text.TextRenderer;
    import flash.utils.getTimer;
    
    import as3logger.Logger;
    
    import models.PosVO;
    
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.RenderTexture;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    public class StartUI extends starling.display.Sprite
    {
        public var isActive : Boolean = false;
        public var callBack : Function;
        public var callAboutUI : Function;
        
        private var lineSize : Number = 25;
        private var doDraw : Boolean = false;
        private var resumeDrawing : Boolean = false;
        
        private var erasableBitmapData : BitmapData;
        private var erasableBitmap : Bitmap;
        private var erasableTexture : Texture;
        private var erasableImg : Image;
        private var eraserClip : Sprite = new Sprite();
        
        private var oldX : Number = 0;
        private var oldY : Number = 0;
        
        private var bgTexture : Texture;
        private var bgImg : Image;
        
        private var bmd : BitmapData;
        private var bmp : Bitmap;
        
        private var snow : SnowItem;
        private var isMove : Boolean = false;
        
        private var scaleValue : Number = 2;
        
        private var bmdLib : BitmapDataLibrary;
        
        private var uiTextureAls : TextureAtlas;
        
        private var startBtn : MovieClip;
        private var aboutBtn : MovieClip;
        private var logoCn : MovieClip;
        
        private var enBtn : MovieClip;
        private var cnBtn : MovieClip;
        
        private var leftstick : Image;
        private var rightStick : Image;
        
        private var btnList : Array = [];
        
        private var curMouseX : Number;
        private var curMouseY : Number;
        
        private var galssChannel : SoundChannel;
        private var galssSoundIsOk : Boolean = true;
        
        private var frontBg : Image;
        
        private var startBtnRect : Rectangle;
        private var startBtnIsOK : Boolean = false;
        
        private var aboutBtnRect : Rectangle;
        private var aboutBtnIsOk : Boolean = false;
        
        private var cnBtnRect : Rectangle;
        private var cnBtnIsOk : Boolean = false;
        
        private var enBtnRect : Rectangle;
        private var enBtnIsOk : Boolean = false;
        
        private var curHasClick : Boolean = false;
        
        private var mRenderTexture : RenderTexture;
        
        private var mBrush : Image;
        public function StartUI()
        {
            super();
        }
        
        public function init():void
        {	
            
            lineSize *= Screen.ratio;
            SoundManager.getInstance().play("btn_click",1,0,new SoundTransform(0));
            SoundManager.getInstance().play("start_ui",999);
            //bg
            //判断当前是白天还是黑夜，显示不同的背景
            var isDay : Boolean = DateUtils.returnIsDay();
            if (isDay) {
                bgTexture = AssetsFactory.getInstance().getStartUIBgTexture(0);
            }else {
                bgTexture = AssetsFactory.getInstance().getStartUIBgTexture(1);
            }
            
            bgImg = new Image(bgTexture);
            addChild(bgImg);
            
            trace("timer9 : " + getTimer());
            
            //snow
            snow = new SnowItem();
            snow.yV = 2;
            snow.init();
            snow.enabled();
            snow.canBroadcastMsg = false;
            snow.numFlakes = 20;
            addChild(snow);
            
            
            trace("timer10 : " + getTimer());
            
            leftstick = new Image(AssetManager.getInstance().getTexture("stick_left"));
            leftstick.touchable = false;
            addChild(leftstick);
            leftstick.x = UICoordinatesFactory.getNewPosX(70);
            leftstick.y = UICoordinatesFactory.getNewPosY(495);
            btnList.push(leftstick);
            
            
            rightStick = new Image(AssetManager.getInstance().getTexture("stick_right"));
            addChild(rightStick);
            rightStick.touchable = false;
            rightStick.x = UICoordinatesFactory.getNewPosX(702);
            rightStick.y = UICoordinatesFactory.getNewPosY(189 + 20);
            btnList.push(rightStick);
            
            //logo
            logoCn = new MovieClip(AssetManager.getInstance().getTextures("logo_"));
            addChild(logoCn);
            logoCn.touchable = false;
            logoCn.x = UICoordinatesFactory.getNewPosX(680) + logoCn.width * 0.5;
            logoCn.y = UICoordinatesFactory.getNewPosY(290) + logoCn.height * 0.5;
            centerObject(logoCn);
            btnList.push(logoCn);
            
            //startbtn
            startBtn = new MovieClip(AssetManager.getInstance().getTextures("start_"));
            addChild(startBtn);
            startBtn.x = UICoordinatesFactory.getNewPosX(706) + startBtn.width * 0.5;
            startBtn.y = UICoordinatesFactory.getNewPosY(483 + 30) + startBtn.height * 0.5;
            centerObject(startBtn);
            startBtnRect = startBtn.getBounds(this);
            
            btnList.push(startBtn);
            
            //aboutBtn
            aboutBtn = new MovieClip(AssetManager.getInstance().getTextures("about_"));
            addChild(aboutBtn);
            centerObject(aboutBtn);
            aboutBtn.x = UICoordinatesFactory.getNewPosX(692) + aboutBtn.width * 0.5;
            aboutBtn.y = UICoordinatesFactory.getNewPosY(600) + aboutBtn.height * 0.5;
            btnList.push(aboutBtn);
            
            aboutBtnRect = aboutBtn.getBounds(this);
            
            //cnbtn
            cnBtn = new MovieClip(AssetManager.getInstance().getTextures("language_cn"));
            addChild(cnBtn);
            cnBtn.x = UICoordinatesFactory.getNewPosX(30) + cnBtn.width * 0.5;
            cnBtn.y = UICoordinatesFactory.getNewPosY(490) + cnBtn.height * 0.5;
            centerObject(cnBtn);
            btnList.push(cnBtn);
            cnBtnRect = cnBtn.getBounds(this);
            
            //enbtn
            enBtn = new MovieClip(AssetManager.getInstance().getTextures("language_en"));
            addChild(enBtn);
            enBtn.x = UICoordinatesFactory.getNewPosX(56) + enBtn.width * 0.5;
            enBtn.y = UICoordinatesFactory.getNewPosY(591) + enBtn.height * 0.5;
            centerObject(enBtn);
            btnList.push(enBtn);
            
            enBtnRect = enBtn.getBounds(this);
            
            //erasable
            eraserClip.graphics.lineStyle(lineSize, 0xFFFFFF);
            eraserClip.filters = [new BlurFilter(5, 5, 1)];
            eraserClip.mouseEnabled = false;
            
            var srcBmd : BitmapData
            if (isDay) {
                srcBmd = AssetsFactory.getInstance().getStartUIFogTexture(0);
            }else {
                srcBmd = AssetsFactory.getInstance().getStartUIFogTexture(1);
            }
            var martx : Matrix = new Matrix();
            martx.scale(0.5,0.5);
            trace(Screen.wdth,Screen.hght);
            erasableBitmapData = new BitmapData(1024*PosVO.scale * 0.5,768*PosVO.scale * 0.5,true);
            erasableBitmapData.draw(srcBmd, martx);
            erasableTexture = Texture.fromBitmapData(erasableBitmapData,false);
            erasableImg = new Image(erasableTexture);
            addChild(erasableImg);
            erasableImg.touchable = false;
            
            
            //add
            mRenderTexture = new RenderTexture(1024*PosVO.scale * 0.5, 768*PosVO.scale * 0.5);
            mRenderTexture.draw(erasableImg);
            erasableImg.texture = mRenderTexture;
            erasableImg.scaleX = erasableImg.scaleY = scaleValue;
            //------------
            
            mBrush = new Image(AssetManager.getInstance().getTexture("brush"));
            mBrush.pivotX = mBrush.width / 2;
            mBrush.pivotY = mBrush.height / 2;
            mBrush.blendMode = BlendMode.ERASE;
            mBrush.scaleX = mBrush.scaleY = 0.3;
            
            frontBg = new Image(AssetsFactory.getInstance().getStartUIFrontBg());
            addChild(frontBg);
            frontBg.touchable = false;
            
            
            addEventListener(Event.ENTER_FRAME, update);
            isActive = true;
            this.addEventListener(TouchEvent.TOUCH,onTouchThisHandler);
        }
        
        private function onTouchThisHandler(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(stage);
            var touchs : Vector.<Touch> = e.getTouches(stage);
            if (touch) {
                
                var px:Number=touch.globalX;
                var py:Number=touch.globalY;
                
                if(touch.phase == TouchPhase.ENDED){
                    var firstClik : Touch = touchs[0];
                    if (firstClik.target == cnBtn) {
                        if(cnBtnIsOk && isMove == false){
                            oncnBtnTouch();
                        }
                    }else if (firstClik.target == enBtn) {
                        if(enBtnIsOk && isMove == false){
                            onenBtnTouch();
                        }
                    }else if (firstClik.target == startBtn) {
                        if(startBtnIsOK && isMove == false){
                            onStartBtnTouch();
                        }
                    }else if (firstClik.target == aboutBtn) {
                        if(aboutBtnIsOk && isMove == false){
                            onAboutBtnTouch();
                        }
                    }
                    
                    isMove = false;
                    doDraw = false;
                    resumeDrawing = false;	
                }else if (touch.phase == TouchPhase.BEGAN) {
                    curMouseX = px;
                    curMouseY = py;
                    oldX = px;
                    oldY = py;
                    //eraserClip.graphics.moveTo(touch.globalX * 0.5,touch.globalY * 0.5);
                    doDraw = true;
                }else if (touch.phase == TouchPhase.MOVED) {
                    curMouseX = px;
                    curMouseY = py;
                    isMove = true;
                    btnIsActive(touch);
                }
            }
        }
        
        private function btnIsActive(touch : Touch):void {
            var px:Number=touch.globalX/PosVO.scale;
            var py:Number=touch.globalY/PosVO.scale;
            
            if(startBtnIsOK == false){
                if (startBtnRect.contains(px, py)) {
                    startBtnIsOK = true;
                }
            }
            
            if (aboutBtnIsOk == false) {
                if (aboutBtnRect.contains(px, py)) {
                    aboutBtnIsOk = true;
                }
            }
            
            if (enBtnIsOk == false) {
                if (enBtnRect.contains(px, py)) {
                    enBtnIsOk = true;
                }
            }
            
            if (cnBtnIsOk == false) {
                if (cnBtnRect.contains(px, py)) {
                    cnBtnIsOk = true;
                }
            }
        }
        
        private function centerObject(obj : DisplayObject):void {
            obj.pivotX = obj.width * 0.5;
            obj.pivotY = obj.height * 0.5;
        }
        
        private function onStartBtnTouch():void 
        {
            if (curHasClick == false) {
                curHasClick = true;
                SoundManager.getInstance().play("btn_click");
                TweenLite.to(startBtn, 0.1, { scaleX:0.7, scaleY:0.7, onComplete : nextTweenHandler, onCompleteParams : [startBtn] } );
                isActive = false;
                startBtn.dispose();
            }
        }
        
        private function onAboutBtnTouch( ):void
        {
            if (curHasClick == false) {
                curHasClick = true;
                SoundManager.getInstance().play("btn_click");
                TweenLite.to(aboutBtn, 0.1, { scaleX:0.7, scaleY:0.7, onComplete : nextTweenHandler, onCompleteParams : [aboutBtn] } );
            }
        }
        
        private function onenBtnTouch( ):void 
        {
            SoundManager.getInstance().play("btn_click");
            GameData.curLangage = "en";
            TweenLite.to(enBtn, 0.1, { scaleX:0.7, scaleY:0.7, onComplete : nextTweenHandler, onCompleteParams : [enBtn] } );
            if (startBtn.currentFrame == 0) {
                startBtn.currentFrame = 1;
            }
            if (aboutBtn.currentFrame == 0) {
                aboutBtn.currentFrame = 1;
            }
            if (logoCn.currentFrame == 0) {
                logoCn.currentFrame = 1;
            }
        
        }
        
        private function oncnBtnTouch( ):void 
        {
            SoundManager.getInstance().play("btn_click");
            GameData.curLangage = "cn";
            TweenLite.to(cnBtn, 0.1, { scaleX:0.7, scaleY:0.7, onComplete : nextTweenHandler, onCompleteParams : [cnBtn] } );
            if (startBtn.currentFrame == 1) {
                startBtn.currentFrame = 0;
            }
            
            if (aboutBtn.currentFrame == 1) {
                aboutBtn.currentFrame = 0;
            }
            
            if(logoCn.currentFrame == 1){
                logoCn.currentFrame = 0;
            }
        }
        
        private function nextTweenHandler(btn : DisplayObject):void 
        {
            TweenLite.to(btn, 0.5, {scaleX:1, scaleY:1, ease : Bounce.easeOut,onComplete : tweenOverHandler,onCompleteParams : [btn]});
        }
        
        
        private function tweenOverHandler(obj : DisplayObject):void{
            if (obj == startBtn) {
                curHasClick = false;
                if (this.callBack!=null) {
                    this.callBack();
                }
            }else if (obj == aboutBtn) {
                curHasClick = false;
                if (this.callAboutUI != null) {
                    this.callAboutUI();
                }
            }
        }
        
        public function enabled():void {
            for (var i : int = 0; i < btnList.length;i ++ ) {
                btnList[i].visible = true;
            }
            this.addEventListener(TouchEvent.TOUCH,onTouchThisHandler);
        }
        
        public function denabled():void {
            for (var i : int = 0; i < btnList.length;i ++ ) {
                btnList[i].visible = false;
            }
            this.removeEventListener(TouchEvent.TOUCH,onTouchThisHandler);
        }
        
        
        private function stopDrawing(e : MouseEvent):void 
        {
            isMove = false;
            doDraw = false;
            resumeDrawing = false;	
        }
        
        public function update(e : Event):void
        {
            if (isActive) {
                if (oldX == curMouseX && oldY == curMouseY)
                {
                    
                }
                else
                {
                    if (doDraw)
                    {
                        /*						eraserClip.graphics.lineTo(curMouseX * 0.5, curMouseY * 0.5);
                                                erasableBitmapData.draw(eraserClip, null, null, BlendMode.ERASE);
                                                erasableImg.texture = Texture.fromBitmapData(erasableBitmapData, false);*/
                        
                        //mRenderTexture.drawBundled(function():void
                        //{
                        //var touches:Vector.<Touch> = event.getTouches(mCanvas);
                        
                        //for each (var touch:Touch in touches)
                        //{
                        /*								if (touch.phase == TouchPhase.BEGAN)
                                                            mColors[touch.id] = Math.random() * uint.MAX_VALUE;
                        
                                                        if (touch.phase == TouchPhase.HOVER || touch.phase == TouchPhase.ENDED)
                                                            continue;*/
                        
                        //var location:Point = touch.getLocation(mCanvas);
                        
                        mBrush.x = curMouseX * 0.5/PosVO.scale;
                        mBrush.y = curMouseY * 0.5/PosVO.scale;
                        //mBrush.color = mColors[touch.id];
                        mBrush.rotation = Math.random() * Math.PI * 2.0;
                        
                        mRenderTexture.draw(mBrush);
                        
                        var tmp5 : Number = 0;
                        var tmp6 : Number = this.dif(oldX, curMouseX);
                        var tmp7 : Number = this.dif(oldY, curMouseY);
                        if (tmp6 > tmp7)
                        {
                            tmp5 = tmp6;
                        }
                        else
                        {
                            tmp5 = tmp7;
                        }
                        var tmp8 : Number = (curMouseX - this.oldX) / tmp5;
                        var tmp9 : Number = (curMouseY - this.oldY) / tmp5;
                        var tmp10 : Number = this.oldX + tmp8 * tmp12;
                        var tmp11 : Number = this.oldY + tmp9 * tmp12;
                        var tmp12 : Number = 0;
                        //trace("loc5 : " + tmp5);
                        
                        while (tmp12 < tmp5 * 0.5)
                        {
                            
                            tmp10 = this.oldX + tmp8 * tmp12;
                            tmp11 = this.oldY + tmp9 * tmp12;
                            this.mBrush.x = tmp10 * 0.5/PosVO.scale;
                            this.mBrush.y = tmp11 * 0.5/PosVO.scale;
                            this.mRenderTexture.draw(this.mBrush);
                            tmp12 += 5 * Screen.ratio;
                        }
                        oldX = curMouseX;
                        oldY = curMouseY;
                        //}
                        //});
                        
                        //Logger.log("test : " + getTimer(),0);
                        
                        if (galssSoundIsOk) {
                            galssSoundIsOk = false;
                            galssChannel = SoundManager.getInstance().soundDic["glass" + int(Math.random() * 6 + 1)].play(0, 1);
                            galssChannel.addEventListener(flash.events.Event.SOUND_COMPLETE,onSoundComPleteHandler);
                        }
                            //trace("sssssssssssssssssssssk");
                    }
                }
                //oldX = curMouseX;
                //oldY = curMouseY;
                
                snow.update(null);
            }
        }
        
        private function dif(value1:Number, value2:Number) : Number
        {
            if (value1 > value2)
            {
                return value1 - value2;
            }
            return value2 - value1;
        }// end function
        
        private function onSoundComPleteHandler(e : flash.events.Event):void 
        {
            galssSoundIsOk = true;
        }
        
        public function start():void {
            isActive = true;
            SoundManager.getInstance().play("start_ui");
        }
        
        public function destroy():void
        {	
            isActive = false;
            SoundManager.getInstance().stop("start_ui");
        }
    }
}

