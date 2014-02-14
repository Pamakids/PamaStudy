package com.pamakids.weather.ui{
    
    
    import com.greensock.TweenLite;
    import com.gskinner.motion.GTweenTimeline;
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.dhelp.HelpCloud;
    import com.pamakids.weather.dhelp.HelpFire;
    import com.pamakids.weather.dhelp.HelpFly;
    import com.pamakids.weather.dhelp.HelpIcePig;
    import com.pamakids.weather.dhelp.HelpSnowBall;
    import com.pamakids.weather.dhelp.HelpSnowMan;
    import com.pamakids.weather.dhelp.HelpSun;
    import com.pamakids.weather.dhelp.HelpWind;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.MovieClip;
    import flash.display.Stage;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.SharedObject;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import as3logger.Logger;
    
    import models.PosVO;
    
    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    
    
    public class Help extends UIBase
    {	
        //private var helplist : Array = ["help01","help02","help03","help04","help05","help06","help07","help08"];
        
        //private var showimg:Image;
        private var Emailimge:Image;
        private var Homeimg : Button;
        
        private var mouseXnum:Number;
        private var num:int;
        private var clickNum:int;
        
        private var mouseXdown:int;
        private var mouseXup:int;
        
        private var dateOld:Date = new Date(1940,6,27);
        private var dateNum:Number;
        private var dateOldNum:Number;
        
        private var picBmpList : Array = new Array();
        private var myx:int;
        private var myy:int;
        private var picNum:int = 9;
        
        private var picLayer : Sprite = new Sprite();
        
        
        
        private var _tiaodong:Sprite;
        
        private var callBack : Function;
        
        private var timer:Timer = new Timer(1000, 1);
        
        
        private var tBg : Quad;
        
        private var helpIndexList : Array = [0, 0, 1, 2, 3, 4, 5, 5, 7, 6];
        
        
        private var help01 : HelpSun = new HelpSun();
        private var help02:HelpCloud = new HelpCloud();
        private var help03:HelpSnowBall = new HelpSnowBall();
        private var help04:HelpSnowMan = new HelpSnowMan();
        private var help05:HelpIcePig = new HelpIcePig();
        private var help06:HelpFire = new HelpFire();
        private var help07:HelpWind = new HelpWind();
        private var help08:HelpFly = new HelpFly();
        
        private var helpdonghua:Array=new Array();
        
        public function Help()
        {
            tBg = new Quad(Screen.wdth, Screen.hght, 0xFFFFFF);
            addChild(tBg);
            tBg.alpha = 0;
        
        }
        public function init(wei:int=0) : void
        {	
            
            trace("wei : " + wei);
            
            wei = helpIndexList[wei];
            
            var startTime : uint = getTimer();
            
            setTexture();
            
            for (var i : int = 1; i <picNum; i++ )
            {
                
                var bg:Sprite=new Sprite();
                
                Emailimge = new Image(bgTexture)
                bg.addChild(Emailimge);
//				Emailimge.x = Screen.offX;
                
                /*				showimg = new Image(AssetManager.getInstance().getTexture("help0" + i));
                
                                showimg.height = 445
                                showimg.width = 810;
                                showimg.x = UICoordinatesFactory.getNewPosX(149);
                                showimg.y = UICoordinatesFactory.getNewPosY(180);
                                bg.addChild(showimg);*/
                
                Homeimg = new Button(btnTexture)
                Homeimg.addEventListener(Event.TRIGGERED, fanhui);
                Homeimg.x = UICoordinatesFactory.getNewPosX(130);
                Homeimg.y = UICoordinatesFactory.getNewPosY(100);
                bg.addChild(Homeimg);
                helpdonghua.push(this['help0'+i])
                bg.addChild(helpdonghua[i-1]);
                picBmpList.push(bg);
            }
            var xx : int = 0;
            picLayer.x = -1024*wei;
            picBmpList[wei].x = 1024 * wei + xx
            
            
            picLayer.addChild(picBmpList[wei]);	
            myx = picBmpList[wei].x
            myy = picBmpList[wei].y = 0;
            num = wei;		
            helpdonghua[wei].play();
            
            this.addChild(picLayer);
            
            picLayer.addEventListener(TouchEvent.TOUCH, toch);
        
        
        }
        
        public function enabled():void {
            //picLayer.touchable = true;
            picLayer.addEventListener(TouchEvent.TOUCH, toch);
        }
        
        public function denabled():void {
            //picLayer.touchable = false;
            picLayer.removeEventListener(TouchEvent.TOUCH, toch);
        }
        
        public function fanhui(e : Event):void
        {
            if (this.callBack != null) {
                this.callBack();
            }
        }
        public function setCallBack(func : Function):void {
            this.callBack = func;
        }
        
        public function toch(e:TouchEvent) : void
        {
            var touch : Touch = e.getTouch(picLayer);
            if(touch){
                if (touch.phase == TouchPhase.MOVED) {
                    trace('萨克拉进')
                    enterFramepicLayer(touch)
                }
                else if (touch.phase == TouchPhase.BEGAN) {
                    handleDown(touch);
                }else if (touch.phase == TouchPhase.ENDED) {
                    handleUp(touch);
                }
            }
        }
        
        
        private var bgTexture : Texture;
        private var btnTexture : Texture;
        private function setTexture():void {
            bgTexture = AssetManager.getInstance().getTexture("email");
            btnTexture = AssetManager.getInstance().getTexture("back");
        }
        
        private function handleDown(e:Touch):void
        {
            
            trace('picLayer '+ picLayer.x)
            trace('myx '+ myx)
            trace('myy '+ myy)
            if (num != (picNum - 1))
            {
                mouseXnum = e.globalX/PosVO.scale;
                
                
                
                mouseXdown =   e.globalX/PosVO.scale;
                if (picBmpList[num + 1] != null)
                {
                    
                    if (picLayer.contains(picBmpList[num + 1]))
                    {
                        
                    }
                    else
                    {
                        trace('右')
                        picBmpList[num+1].x = myx+1024;
                        picBmpList[num+1].y =myy;
                        picLayer.addChild(picBmpList[num + 1]);					
                    }
                }
                
                
                if (picBmpList[num -1] != null)
                {
                    if (picLayer.contains(picBmpList[num - 1]))
                    {
                        
                    }
                    else
                    {
                        trace('左')
                        picBmpList[num-1].x = myx-1024;
                        picBmpList[num-1].y =myy;
                        picLayer.addChild(picBmpList[num - 1]);
                    }
                }
                
                
                
                var date:Date = new Date();
                dateNum = date.getTime();
            }
            else
            {
                
            }
        }
        
        private function handleUp(e:Touch):void
        {	
            
            trace('放手了')
            mouseXup = e.globalX/PosVO.scale;
            var dateOld:Date = new Date();
            dateOldNum = dateOld.getTime();
            if( (dateOldNum - dateNum) < 300  && (mouseXup - mouseXdown) > 40 )
            {
                if(num == 0)
                {
                    
                    num = 0;
                }
                else
                {
                    helpdonghua[num].stop();
                    num--;
                    myx = myx - 1024
                    try
                    {
                        picLayer.removeChild(picBmpList[num + 2])
                        
                    }
                    catch (e : Error) { }
                    
                }
                
            }
            else if ((mouseXdown - e.globalX/PosVO.scale) < -1024 * 0.5 && (mouseXup - mouseXdown) > 0)
            {
                if(num == 0)
                {
                    
                    num = 0;
                }
                else
                {
                    helpdonghua[num].stop();
                    num--;
                    myx = myx - 1024;
                    try
                    {
                        picLayer.removeChild(picBmpList[num + 2])
                        
                    }
                    catch (e : Error) { }
                    
                }
            }
            if ((dateOldNum - dateNum) < 300  && (mouseXup - mouseXdown) < -40 )
            {			
                if(num == picNum-2)
                {
                    num = picNum-2;
                }
                else
                {
                    helpdonghua[num].stop();
                    num++;
                    myx = myx + 1024;
                    try
                    {
                        picLayer.removeChild(picBmpList[num - 2])
                        
                    }
                    catch (e:Error) { };
                }  
            }
            else if((mouseXdown-e.globalX/PosVO.scale) > 1024 * 0.5 && (mouseXup - mouseXdown) < 0)
            {
                
                if(num == picNum-2)
                {
                    num = picNum-2;
                    
                }
                else
                {
                    helpdonghua[num].stop();
                    num++;
                    myx = myx + 1024;
                    try
                    {
                        picLayer.removeChild(picBmpList[num - 2])
                        
                    }
                    catch (e : Error) { };
                }
                
                
            }
            
            try{
                if (picBmpList[num + 1] != null)
                {
                    
                    if (picLayer.contains(picBmpList[num + 1]))
                    {
                        
                    }
                    else
                    {
                        trace('右')
                        picBmpList[num+1].x = myx+1024;
                        picBmpList[num+1].y =myy;
                        picLayer.addChild(picBmpList[num + 1]);					
                    }
                }
            }
            catch(e:Error){}
            
            try{
                if (picBmpList[num -1] != null)
                {
                    if (picLayer.contains(picBmpList[num - 1]))
                    {
                        
                    }
                    else
                    {
                        trace('左')
                        picBmpList[num-1].x = myx-1024;
                        picBmpList[num-1].y =myy;
                        picLayer.addChild(picBmpList[num - 1]);
                    }
                }
            }catch(e:Error)
            {
                
            }
            
            //Logger.log('num  '+num)
            TweenLite.to(picLayer,0.45,{x:-(1024 * num)})
            //Logger.log('picLayer.x '+ picLayer.x)
            helpdonghua[num].play();
        
        }
        
        private function enterFramepicLayer(e:Touch):void
        {
            
            trace('picLayer.x '+ picLayer.x)
            
            //Logger.log('picLayer.x '+ picLayer.x)
            picLayer.x = picLayer.x - (mouseXnum - e.globalX/PosVO.scale);
            mouseXnum = e.globalX/PosVO.scale;
            
            if (picLayer.x >= 450 )
            {
                picLayer.x = 450;
            }
            if(picLayer.x <= -((picNum-2)*1000+555))
            {
                trace('到头了')
                picLayer.x =  -((picNum-2)*1000+555);
            }
        /*if (picLayer.contains(picBmpList[num + 1]))
        {
        }
        else{
            try{
                trace('中间')
                picBmpList[num].x = myx;
                picBmpList[num].y =myy;
                picLayer.addChild(picBmpList[num]);
            }catch(e : Error){}
            //_tiaodong.gotoAndStop(num+1)
            //mouseXnum = e.globalX;
        
        }*/
        }
        
        public function destroy():void {
            picLayer.dispose();
            tBg.dispose();
            //showimg.dispose();
            Emailimge.dispose();
            Homeimg.dispose();
            
            this.removeChildren();
        }
    
    
    }


}


