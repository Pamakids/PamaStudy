package com.pamakids.weather.items
{	
    
    
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.PigHappyMsg;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.geom.Matrix;
    import flash.media.SoundChannel;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import models.PosVO;
    
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    
    public class SmallSnowManItem extends Sprite
    {
        
        public var callSnowBallGame : Function;
        
        private var roty:Number=0;
        private var rotx:Number=0;
        private var distance:Number = 0;
        private var distancet:Number=0;
        private var lastdistance:Number=0;
        private var _snowmc1 : snowmc1 = new snowmc1();
        private var bmd1:BitmapData;
        private var hit:Boolean=true;
        private var timer:Timer=new Timer(1000)
        private var timertuoli:Timer=new Timer(1000,1)
        private var timerball:Timer=new Timer(1000,2)
        
        private var bg:Quad;
        
        private var soundIsOk : Boolean = true;
        private var snowSounChannel : SoundChannel;
        public function SmallSnowManItem()
        {
            
            bg = new Quad(800 * Screen.ratio,258 * Screen.ratio);
            
            _snowmc1.scaleX = _snowmc1.scaleY = Screen.ratio;
            bmd1 = new BitmapData(_snowmc1.width, _snowmc1.height, false, 0);
            var matrix : Matrix = new Matrix();
            matrix.scale(Screen.ratio,Screen.ratio);
            bmd1.draw(_snowmc1,matrix);
        
        
        }
        public function SnowaddEventListener():void
        {
            if(GameData.snowmanshow.tou.visible!=true)
            {
                this.addEventListener(TouchEvent.TOUCH, MoveTouchHandler)
                GameData.snowmanshow.ball.addEventListener(TouchEvent.TOUCH, onzhuanTouchHandler);
            }
        }
        public function SnowremoveEventListener():void
        {
            roty=0;
            rotx=0;
            distance=0;
            lastdistance=0;
            timer.reset();
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,Timeframe)
            this.removeEventListener(TouchEvent.TOUCH, MoveTouchHandler);
            
            if(GameData.snowmanshow.ball){
                GameData.snowmanshow.ball.removeEventListener(TouchEvent.TOUCH, onzhuanTouchHandler);
            }
        
        }
        public function init():void
        {
            bg.alpha = 0;
            bg.y = UICoordinatesFactory.getNewPosY(428);
            bg.x = UICoordinatesFactory.getNewPosX(134);
            this.addChild(bg)
            
            roty=0;
            rotx=0;
            distance=0;
            lastdistance=0;
            
            
            _snowmc1.x = UICoordinatesFactory.getNewPosX(98);
            _snowmc1.y = UICoordinatesFactory.getNewPosY(420);
            
            
            trace("数据层初始化");
            GameData.snowmanshow.ball.addEventListener(TouchEvent.TOUCH, onzhuanTouchHandler);
            this.addEventListener(TouchEvent.TOUCH, MoveTouchHandler)
        
        
        }
        //抹擦出现雪球
        private function MoveTouchHandler(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(stage);
            var hitColor:uint=bmd1.getPixel(touch.globalX/PosVO.scale-_snowmc1.x,touch.globalY/PosVO.scale-_snowmc1.y);
            {
                
                if (touch.phase == TouchPhase.MOVED) {
                    //trace('移动')
                    thisMove(touch);
                }
                else if (touch.phase == TouchPhase.BEGAN) {
                    
                    trace("点击雪人事件层");
                    timer.stop();
                    timer.reset();
                    
                    timer.removeEventListener(TimerEvent.TIMER,Timeframe)
                }
                else if (touch.phase == TouchPhase.ENDED) {
                    
                    roty=0;
                    rotx=0;
                    distance=0;
                    lastdistance=0;
                    
                    this.removeEventListener(TouchEvent.TOUCH, MoveTouchHandler)
                    timer.start();
                    timer.addEventListener(TimerEvent.TIMER,Timeframe)
                    
                    
                }			
            }
        }
        //控制雪球
        private function onzhuanTouchHandler(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(stage);
            if (touch.phase == TouchPhase.MOVED) {
                thisMove(touch)
                
            }
            else if (touch.phase == TouchPhase.BEGAN) {
                if(GameData.snowmanshow.ball.alpha>0.9)
                {
                    timer.stop();
                    timer.reset();
                    timer.removeEventListener(TimerEvent.TIMER,Timeframe)
                }
                
            }else if (touch.phase == TouchPhase.ENDED) {
                this.removeEventListener(TouchEvent.TOUCH, MoveTouchHandler)
                timer.start();
                timer.addEventListener(TimerEvent.TIMER,Timeframe)
            }			
        }
        //松手
        private function Timeframe(e:TimerEvent):void
        {
            trace('timer.currentCount '+ timer.currentCount)
            if(e.currentTarget.currentCount==3)
            {
                roty=0;
                rotx=0;
                distance=0;
                lastdistance=0;
                
                TweenLite.to(GameData.snowmanshow.ball, 1, {autoAlpha:0});
            }
            if(e.currentTarget.currentCount==4)
            {
                GameData.snowmanshow.ball.scaleX=0.1
                GameData.snowmanshow.ball.scaleY=0.1
                timer.removeEventListener(TimerEvent.TIMER,Timeframe)
                timer.reset();
                timer.stop();
                this.addEventListener(TouchEvent.TOUCH, MoveTouchHandler)
            }
        }
        //慢慢出现雪球
        private function thisMove(e:Touch):void
        {
            var hitColor:uint=bmd1.getPixel(e.globalX/PosVO.scale-_snowmc1.x,e.globalY/PosVO.scale-_snowmc1.y);
            if(hitColor==uint(0)){
                if(GameData.snowmanshow.ball.x<rotx)
                {
                    GameData.snowmanshow.ball.rotation -= 0.5;
                }
                else
                {
                    GameData.snowmanshow.ball.rotation += 0.5;
                }
                
            }else{
                //trace("出现滑雪球的声音");
                
                if (soundIsOk == true) {
                    soundIsOk = false;
                    snowSounChannel = SoundManager.getInstance().soundDic["xueqiu"].play(0, 1);
                    snowSounChannel.addEventListener(Event.SOUND_COMPLETE,onSoundComHandler);
                }
                trace("e.globalY : " + e.globalY);
                trace("e.globalX : " + e.globalX);
                GameData.snowmanshow.ball.x=e.globalX/PosVO.scale
                GameData.snowmanshow.ball.y=e.globalY/PosVO.scale
                
                if(GameData.snowmanshow.ball.x<rotx)
                {
                    distance=rotx-GameData.snowmanshow.ball.x;
                    GameData.snowmanshow.ball.rotation -= 0.5;
                }
                else
                {
                    distance=GameData.snowmanshow.ball.x-rotx;
                    
                    GameData.snowmanshow.ball.rotation += 0.5;
                }
                if (GameData.snowmanshow.ball.y < roty)
                {
                    distancet=roty-GameData.snowmanshow.ball.y;
                }
                else
                {
                    distancet=GameData.snowmanshow.ball.y-roty;
                }
                lastdistance=Number(lastdistance)+Number(distance)+Number(distancet)
                
                
                
                if(lastdistance>=700 * Screen.ratio)
                {
                    if(GameData.snowmanshow.ball.alpha<0.9)
                    {
                        
                        TweenLite.to(GameData.snowmanshow.ball, 1, {autoAlpha:1});
                    }
                    else
                    {
                        GameData.snowmanshow.ball.scaleX=GameData.snowmanshow.ball.scaleX+0.05
                        GameData.snowmanshow.ball.scaleY=GameData.snowmanshow.ball.scaleY+0.05
                        lastdistance=0;
                        
                        if(GameData.snowmanshow.ball.scaleX>=0.3)
                        {
                            
                            
                            GameData.snowmanshow.ball.removeEventListener(TouchEvent.TOUCH, onzhuanTouchHandler);
                            this.removeEventListener(TouchEvent.TOUCH, MoveTouchHandler)
                            TweenMax.to(GameData.snowmanshow.ball, 1, {bezierThrough:[{x:GameData.snowmanshow.ball.x, y:GameData.snowmanshow.ball.y-50 * Screen.ratio}], orientToBezier:true});
                            timertuoli.start();
                            timertuoli.addEventListener(TimerEvent.TIMER_COMPLETE,tuoli)
                            
                        }			
                    }
                    
                }
                
                rotx = e.globalX/PosVO.scale;
                roty = e.globalY/PosVO.scale;	
                
            }
        }
        
        private function onSoundComHandler(e:Event):void 
        {
            soundIsOk = true;
            snowSounChannel.removeEventListener(Event.SOUND_COMPLETE,onSoundComHandler);
        }
        //移动方向
        private function tuoli(e:TimerEvent):void
        {
            timerball.stop();
            timerball.reset();
            timerball.removeEventListener(TimerEvent.TIMER_COMPLETE,chuxian)
            if(GameData.snowmanshow.shenti.visible==false)
            {
                TweenMax.to(GameData.snowmanshow.ball, 3, {bezierThrough:[{x:UICoordinatesFactory.getNewPosX(790), y:UICoordinatesFactory.getNewPosY(514)}], orientToBezier:true, alpha:0});
                timerball.start()
                timerball.addEventListener(TimerEvent.TIMER_COMPLETE,chuxian)
            }
            else
            {
                TweenMax.to(GameData.snowmanshow.ball, 3, {bezierThrough:[{x:UICoordinatesFactory.getNewPosX(790), y:UICoordinatesFactory.getNewPosY(480)}], orientToBezier:true, alpha:0});
                timerball.start()
                timerball.addEventListener(TimerEvent.TIMER_COMPLETE,chuxian)	
            }
        }
        //出现雪人
        private function chuxian(e:TimerEvent):void
        {
            trace("出现一个雪球");
            if(GameData.snowmanshow.shenti.visible==false)
            {
                timerball.stop();
                timerball.reset();		
                timerball.removeEventListener(TimerEvent.TIMER_COMPLETE,chuxian)
                GameData.snowmanshow.ball.scaleX=0.1
                GameData.snowmanshow.ball.scaleY=0.1
                GameData.snowmanshow.shenti.alpha=0
                GameData.snowmanshow.shenti.visible=true;
                TweenLite.to(GameData.snowmanshow.shenti, 1, {autoAlpha:1});
                this.addEventListener(TouchEvent.TOUCH, MoveTouchHandler)
                GameData.snowmanshow.ball.addEventListener(TouchEvent.TOUCH, onzhuanTouchHandler);
            }
            else
            {
                timerball.reset();
                timerball.stop();
                timerball.removeEventListener(TimerEvent.TIMER_COMPLETE,chuxian)
                GameData.snowmanshow.tou.alpha=0;
                GameData.snowmanshow.tou.visible=true;
                TweenLite.to(GameData.snowmanshow.tou, 1, {autoAlpha:1});
                
                GameData.snowmanshow.snowman.addEventListener(TouchEvent.TOUCH, onSunTouchHandler);
                GameData.snowmanshow.setChildIndex(GameData.snowmanshow.snowman,GameData.snowmanshow.numChildren-1);
                this.removeChild(GameData.snowmanshow.ball);
            }
            
            PluginControl.BroadcastMsg(new PigHappyMsg());
            GameData.snowballNum ++;
            if (GameData.snowballNum >= 2) {
                GameData.dayDesireList[3] = 1;
                
                GameData.setWishComTime(3,getTimer());
            }
        }
        private function SnowUp(e:Touch):void 
        {
        
        }
        
        private function onSunTouchHandler(e:TouchEvent):void 
        {
            var touch : Touch = e.getTouch(stage);
            
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    SoundManager.getInstance().play("btn_click");
                    GameData.snowmanshow.addsmall();
                }
            }
        
        }
    }
}

