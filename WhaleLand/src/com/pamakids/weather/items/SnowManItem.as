package com.pamakids.weather.items
{
    
    import com.greensock.TweenLite;
    import com.greensock.plugins.*;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.SnowBallGameMsg;
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.factory.UICoordinatesFactory;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    //雪人换装界面
    public class SnowManItem extends UIBase
    {
        private var showimg : Image;
        private var tou : Image;
        private var shenti : Image;
        
        public var callBack : Function;
        private var lian : Array = ["zhuangbanlian001","zhuangbanlian002","zhuangbanlian003"];
        private var shou : Array = ["zhuangbanshou001","zhuangbanshou002","zhuangbanshou003"];
        private var weibo : Array = ["zhuangbantou001","zhuangbantou002","zhuangbantou003"];
        
        private var manlian : Array = new Array();
        private var manshou : Array = new Array();
        private var manweibo : Array = new Array();
        
        
        private var clox : Number = 480;
        private var cloy : Number = 0;
        private var defaultY : Number = 200;
        private var julix : int = 100;
        
        private var snowman:Sprite = new Sprite();
        private var snowlian:Image;
        private var snowshou:Image;
        private var snowmaoweibo:Image;
        
        private var fanhuilian:String
        private var fanhuishou:String
        private var fanhuiweibo:String
        
        private var sp:Sprite;
        
        private var tBg:Quad;
        
        private var geziheight:Number=121* Screen.ratio;
        private var geziwight:Number=92* Screen.ratio;
        private var lianx:Number=27* Screen.ratio;;
        private var liany:Number=60* Screen.ratio;;
        private var shoux:Number=15* Screen.ratio;;
        private var shouy:Number=5* Screen.ratio;;
        TweenPlugin.activate([AutoAlphaPlugin]);
        public function SnowManItem() 
        {
        
        }
        
        private var resTextures : AssetManager;
        public function init(d1:String=null,d2:String=null,d3:String=null):void
        {
            var bg2Texture : Texture;
            var bg1Texture : Texture;
            var returnBtnTexture : Texture;
            var headTexture : Texture;
            var bodyTexture : Texture;
            bg2Texture = AssetManager.getInstance().getTexture("huanzhuangui2");
            bg1Texture = AssetManager.getInstance().getTexture("huanzhuangui");
            returnBtnTexture =AssetManager.getInstance().getTexture("back");
            headTexture = AssetManager.getInstance().getTexture("snowman001");
            
            bodyTexture = AssetManager.getInstance().getTexture("snowman002");
            
            resTextures = AssetManager.getInstance();
            
            var bg2 : Image = new Image(bg2Texture)
            addChild(bg2);
            bg2.x = UICoordinatesFactory.getNewPosX(493);
            bg2.y = UICoordinatesFactory.getNewPosY(148);
            
            var bg1 : Image = new Image(bg1Texture)
            addChild(bg1);
//			bg1.x = Screen.offX;
            addChild(snowman);
            
            var fanhui:Image = new Image(returnBtnTexture)
            fanhui.addEventListener(TouchEvent.TOUCH, fanhuiTouchHandler);
            addChild(fanhui);
            fanhui.x = UICoordinatesFactory.getNewPosX(100);
            fanhui.y = UICoordinatesFactory.getNewPosY(100);
            
            
            trace("雪人加载中......");
            tou = new Image(headTexture);
            snowman.addChild(tou)
            
            shenti = new Image(bodyTexture);
            snowman.addChild(shenti)
            
            snowman.x = UICoordinatesFactory.getNewPosX(110);
            snowman.y = UICoordinatesFactory.getNewPosY(100);
            
            trace('雪人加载完毕')
            
            for(var i : int = 0;i<3;i++)
            {
                sp=new Sprite();
                tBg = new Quad(geziwight,geziheight, 0xFFFFFF);
                tBg.alpha = 0;
                sp.addChild(tBg);
                
                this.addChild(sp);
                
                showimg = new Image(resTextures.getTexture(weibo[i]));
                showimg.scaleX = 0.3;
                showimg.scaleY = 0.3;
                manweibo.push(showimg);
                sp.name = weibo[i].toString();
                sp.addEventListener(TouchEvent.TOUCH, onSunTouchHandler3);
                sp.addChild(manweibo[i]);
                
                sp.x = UICoordinatesFactory.getNewPosX(clox + 110);
                clox = clox + 110;
                sp.y = UICoordinatesFactory.getNewPosY(defaultY);
                trace('sp1'+ sp.y)
                
                
            }
            //脸坐标
            clox = 480;
            cloy = defaultY + 125;
            
            for(i = 0;i<3;i++)
            {
                sp=new Sprite();
                
                tBg = new Quad(geziwight,geziheight, 0xFFFFFF);
                tBg.alpha = 0;
                sp.addChild(tBg);
                
                this.addChild(sp);
                
                showimg = new Image(resTextures.getTexture(lian[i]));
                manlian.push(showimg);
                sp.name=lian[i].toString();
                showimg.x=lianx
                showimg.y=liany
                sp.addEventListener(TouchEvent.TOUCH, onSunTouchHandler1);
                showimg.scaleX = 0.3;
                showimg.scaleY = 0.3;
                sp.addChild(manlian[i])
                sp.x = UICoordinatesFactory.getNewPosX(clox + 110);
                clox = clox + 110;
                sp.y = UICoordinatesFactory.getNewPosY(cloy);
                trace('sp2'+ sp.y)
                
            }
            
            clox = 480;
            cloy = cloy + 125;
            
            for(i = 0;i<3;i++)
            {
                sp=new Sprite();
                
                tBg = new Quad(geziwight,geziheight, 0xFFFFFF);
                tBg.alpha = 0;
                sp.addChild(tBg);
                
                this.addChild(sp);
                
                showimg = new Image(resTextures.getTexture(shou[i]));
                showimg.scaleX=0.3;
                showimg.scaleY=0.3;
                manshou.push(showimg);
                sp.name=shou[i].toString();
                showimg.x=shoux
                showimg.y=shouy
                sp.addEventListener(TouchEvent.TOUCH, onSunTouchHandler2);
                sp.addChild(manshou[i])
                sp.x = UICoordinatesFactory.getNewPosX(clox + 110);
                clox = clox + 110;
                sp.y = UICoordinatesFactory.getNewPosY(cloy);
            }
            
            
            if(d1!=null)
            {
                if(snowman.contains(snowlian))
                {
                    snowman.removeChild(snowlian);
                    
                }
                snowlian = new Image(resTextures.getTexture(d1));
                
                snowlian.x = 226* Screen.ratio;
                snowlian.y = UICoordinatesFactory.getNewPosY(140);
                snowman.addChild(snowlian);
                
                GameData.hasDressUp = true;
            }
            if(d2!=null)
            {
                if(snowman.contains(snowshou))
                {
                    snowman.removeChild(snowshou);
                }
                
                snowshou = new Image(resTextures.getTexture(d2));
                snowshou.x = 0;
                snowshou.y = UICoordinatesFactory.getNewPosY(56);
                snowman.addChild(snowshou);
                
                GameData.hasDressUp = true;
            }
            if(d3!=null)
            {
                if(snowman.contains(snowmaoweibo))
                {
                    snowman.removeChild(snowmaoweibo);
                    
                }
                
                snowmaoweibo = new Image(resTextures.getTexture(d3));
                snowmaoweibo.x = 87* Screen.ratio;
                snowmaoweibo.y = UICoordinatesFactory.getNewPosY(6);
                snowman.addChild(snowmaoweibo);			
                
                GameData.hasDressUp = true;
            }
        
        }
        private function onSunTouchHandler1(e:TouchEvent):void 
        {
            
            var touch : Touch = e.getTouch(stage);
            
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    trace('如何')
                    SoundManager.getInstance().play("btn_click");
                    if(snowman.contains(snowlian))
                    {
                        snowman.removeChild(snowlian);
                        
                    }
                    snowlian = new Image(resTextures.getTexture((e.currentTarget as DisplayObject).name));
                    fanhuilian=(e.currentTarget as DisplayObject).name;
                    snowlian.x = 226* Screen.ratio;
                    snowlian.y = UICoordinatesFactory.getNewPosY(140);
                    snowman.addChild(snowlian);
                    snowlian.alpha=0;
                    TweenLite.to(snowlian, 1.5, {autoAlpha:1});
                    
                    
                }
            }
        }
        private function onSunTouchHandler2(e:TouchEvent):void 
        {
            
            var touch : Touch = e.getTouch(stage);
            
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    
                    trace('段及了')
                    SoundManager.getInstance().play("btn_click");
                    if(snowman.contains(snowshou))
                    {
                        snowman.removeChild(snowshou);
                    }
                    
                    snowshou = new Image(resTextures.getTexture((e.currentTarget as DisplayObject).name));
                    fanhuishou=(e.currentTarget as DisplayObject).name;
                    snowshou.x = 0;
                    snowshou.y = UICoordinatesFactory.getNewPosY(56);
                    snowman.addChild(snowshou);
                    snowshou.alpha=0;
                    TweenLite.to(snowshou, 1.5, {autoAlpha:1});
                    
                }
            }		
        }
        private function onSunTouchHandler3(e:TouchEvent):void 
        {
            
            
            var touch : Touch = e.getTouch(stage);
            
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    
                    SoundManager.getInstance().play("btn_click");
                    if(snowman.contains(snowmaoweibo))
                    {
                        snowman.removeChild(snowmaoweibo);
                        
                    }
                    
                    snowmaoweibo = new Image(resTextures.getTexture((e.currentTarget as DisplayObject).name));
                    fanhuiweibo=(e.currentTarget as DisplayObject).name;
                    snowmaoweibo.x = 87 * Screen.ratio;
                    snowmaoweibo.y = UICoordinatesFactory.getNewPosY(6);
                    snowman.addChild(snowmaoweibo);
                    snowmaoweibo.alpha=0;
                    TweenLite.to(snowmaoweibo, 1.5, {autoAlpha:1});				
                }
            }			
        }
        private function fanhuiTouchHandler(e:TouchEvent):void
        {
            var touch : Touch = e.getTouch(stage);
            if (touch) {
                if (touch.phase == TouchPhase.BEGAN) {
                    
                    //sound
                    SoundManager.getInstance().play("btn_click");
                    
                    //大雪人向小雪人发送消息
                    trace("大雪人向小雪人发送消息");
                    var msg : SnowBallGameMsg = new SnowBallGameMsg();
                    msg.faceType = this.fanhuilian;
                    msg.handType = this.fanhuishou;
                    msg.collarType = this.fanhuiweibo;
                    msg.msgType = 1;
                    PluginControl.BroadcastMsg(msg);
                    this.destroy();
                    this.dispose();
                    this.sp.removeChildren();
                    this.snowman.removeChildren();
                    this.removeChildren();
                }
            }
        }
        public function destroy():void
        {
            showimg.dispose();
            tou.dispose()
            shenti.dispose()
        
        }
        public function update(data : *):void
        {
        
        }
    
    }
}

