package com.pamakids.weather.items
{
    import com.greensock.TweenLite;
    import com.greensock.TweenMax;
    import com.greensock.easing.Linear;
    import com.greensock.plugins.BezierPlugin;
    import com.greensock.plugins.BezierThroughPlugin;
    import com.greensock.plugins.TweenPlugin;
    import com.pamakids.core.PluginControl;
    import com.pamakids.core.msgs.RemindPigMsg;
    import com.pamakids.uimanager.UIBase;
    import com.pamakids.utils.Screen;
    import com.pamakids.weather.factory.AssetManager;
    import com.pamakids.weather.factory.BitmapDataLibrary;
    import com.pamakids.weather.model.GameData;
    import com.pamakids.weather.model.SoundManager;
    import com.urbansquall.ginger.Animation;
    import com.urbansquall.ginger.AnimationPlayer;
    import com.urbansquall.ginger.events.AnimationEvent;
    import com.urbansquall.ginger.tools.AnimationBuilder;
    
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    
    import models.PosVO;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    public class Fishs extends UIBase implements IItem
    {
        private var fishList : Array = [];
        private var isEnd : Boolean = true;
        private var fishPlayer : MovieClip;
        private var isActive : Boolean = false;
        private var fishTextures : Texture;
        public function Fishs()
        {
            super();
            TweenPlugin.activate([BezierThroughPlugin, BezierPlugin]);
        }
        
        public function init():void
        {
            
            setWavesTextures();
            fishPlayer = new MovieClip(wavesTextures, 24);
            fishPlayer.pivotX = fishPlayer.width * 0.5;
            fishPlayer.pivotY = fishPlayer.height * 0.8;
            addChild(fishPlayer);
            fishPlayer.pause();
            fishPlayer.advanceTime(30);
            fishPlayer.touchable = false;
            fishPlayer.visible = false;
            fishPlayer.addEventListener(Event.COMPLETE, onMovieCom);
        }
        
        private var wavesTextures : Vector.<Texture>;
        private function setWavesTextures():void {
            wavesTextures = AssetManager.getInstance().getTextures("fishwater");
        }
        
        
        private function onMovieCom(e:Event):void 
        {
            trace("鱼跃水动画播放完毕了");
            fishPlayer.visible = false;
            Starling.juggler.remove(fishPlayer);
        }
        
        public function creatdFish(pos : Point):void {
            var fish : FishMC;
            if(fishList.length < 1){
                fish = new FishMC();
                fish.scaleX = fish.scaleY = PosVO.scale;
            }else {
                if (isEnd) {
                    fish = fishList[0];	
                }
            }
            if (fish) {
                fish.visible = true;
                PluginControl.BroadcastMsg(new RemindPigMsg());
                isEnd = false;
                isActive = true;
                fishPlayer.x = pos.x;
                fishPlayer.y = pos.y;
                Starling.juggler.add(fishPlayer);
                fishPlayer.play();
                fishPlayer.visible = true;
                //
                SoundManager.getInstance().play("fishjump",1);
                //
                fish.x = pos.x* PosVO.scale;
                fish.y = pos.y* PosVO.scale;
                Starling.current.nativeStage.stage.addChild(fish);
                
                fish.touchable = false;
                fishList.push(fish);
                TweenMax.to(fish, 0.75, { bezierThrough:[ { x:(pos.x - 130) * PosVO.scale, y:(pos.y - 150) * PosVO.scale }, { x:(pos.x - 250) * PosVO.scale, y:pos.y*PosVO.scale } ], orientToBezier:true, ease:Linear.easeNone, onComplete : tweenComHandler } );	
            }
        }
        
        private function tweenComHandler():void 
        {
            fishPlayer.x = fishList[0].x;
            fishPlayer.y = fishList[0].y;
            fishPlayer.play();
            fishPlayer.visible = true;
            Starling.juggler.add(fishPlayer);
            SoundManager.getInstance().play("fishin",1);
            fishList[0].x = 1200 * Screen.wRatio;
            fishList[0].visible = false;
            isEnd = true;
        }
        
        public function update(data:*):void
        {
            if(isActive){
                //fishPlayer.update(30);
            }
        }
        
        public function reSart():void {
        
        }
        
        public function reset():void {
            if (fishList.length > 0) {
                TweenLite.killTweensOf(fishList[0]);
                fishList[0].visible = false;
            }
            
            fishPlayer.visible = false;
            isEnd = true;
        }
        
        public function destroy():void
        {
            removeChild(fishPlayer,true);
            fishPlayer = null;
        }
    }
}

