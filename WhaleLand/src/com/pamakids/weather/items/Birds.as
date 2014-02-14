package com.pamakids.weather.items
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Quart;
	import com.pamakids.core.PluginControl;
	import com.pamakids.core.msgs.RemindPigMsg;
	import com.pamakids.uimanager.UIBase;
	import com.pamakids.utils.DeviceInfo;
	import com.pamakids.utils.DeviceType;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.model.GameData;
	import com.pamakids.weather.model.Nodes;
	import com.pamakids.weather.model.SoundManager;
	import com.urbansquall.ginger.Animation;
	import com.urbansquall.ginger.AnimationPlayer;
	import com.urbansquall.ginger.tools.AnimationBuilder;
	import com.urbansquall.ginger.tools.AnimationPlayerFactory;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	
	public class Birds extends Sprite implements IItem
	{
		private var bdLib : BitmapDataLibrary;
		private var animationFactory : AnimationPlayerFactory;
		
		private var birdsList : Array = [];
		private var owlList : Array = [];
		
		private var birdsPool : Array = [];
		private var owlPool : Array = [];
		
		private var isActive : Boolean = false;
		
		private var birdTextures : Vector.<Texture>;
		private var owlTexture : Texture;
		
		
		private var juggler : Juggler = new Juggler();
		
		private var owlPosList : Array = [];
		
		private var owlPosNode : Nodes = new Nodes();
		
		private var ration : Number = 1;
		public function Birds()
		{
			super();
			//垃圾写法，需要修正
			var node1 : Nodes = new Nodes();
			node1.startPos = new Point(302,350);
			node1.endPos = new Point(302, 293);
			
			var node2 : Nodes = new Nodes();
			node2.startPos = new Point(447,290);
			node2.endPos = new Point(447, 227);
			
			var node3 : Nodes = new Nodes();
			node3.startPos = new Point(576,322);
			node3.endPos = new Point(576, 257);
			
			var node4 : Nodes = new Nodes();
			node4.startPos = new Point(632,316);
			node4.endPos = new Point(632, 222);
			
			owlPosList.push(node1,node2,node3,node4);
			
			newData();
			
		}
		
		public function init():void
		{	
			setTextures();
			AssetManager.getInstance()
			birdTextures = AssetManager.getInstance().getTextures("bird");
			owlTexture = AssetManager.getInstance().getTexture("maotouying");
			isActive = true;
		}
		
		public function reStart():void {
			isActive = true;
		}
		
		public function reset():void {
			for (var i : int = 0; i < birdsList.length;i ++ ) {
				var bird : MovieClip = birdsList[i] as MovieClip;
				birdsList.splice(i, 1);
				birdsPool.push(bird);
				bird.visible = false;
			}
			
			for (var j : int = 0; j < owlList.length;j ++ ) {
				var owl : MovieClip = owlList[j] as MovieClip;
				TweenLite.killTweensOf(owl);
				owlList.splice(j, 1);
				owlPool.push(owl);
				owl.visible = false;
			}
			
			isActive = false;
		}
		
		
		//如果白天的话出小鸟，晚上的话出猫头鹰
		public function creatBirds(pos : Point):void {
			//广播提醒小猪
			PluginControl.BroadcastMsg(new RemindPigMsg());
			
			var scale : Number;
			if(GameData.dayState == 0){
				if(birdsList.length < int(10 * Screen.ratio * ration)){
					var randomNum : int = Math.random() * 2 * Screen.ratio + 1;
					if (birdsPool.length < randomNum) {
						var lackNum : int = randomNum - birdsPool.length;
						for (var i : int = 0; i < lackNum;i ++ ) {
							var birds : MovieClip = new MovieClip(birdTextures);
							birds.pivotX = birds.width * 0.5;
							birds.pivotY = birds.height * 0.5;
							addChild(birds);
							birds.touchable = false;
							birds.data.oldTime = getTimer();
							birds.x = pos.x + Math.random() * 20;
							birds.y = pos.y;
							birdsList.push(birds);
							scale = Math.random() * 0.5 + 0.5;
							if (Math.random() < 0.5) {
								birds.scaleX = birds.scaleY = scale;
								birds.data.vx =  (-Math.random() * 3 - 1) * Screen.wRatio;
							}else {
								birds.scaleX = -1 * scale;
								birds.scaleY = scale;
								birds.data.vx =  (Math.random() * 3 + 1) * Screen.wRatio;
							}
							birds.data.vy = (-Math.random() * 3 - 1) * Screen.ratio;
							juggler.add(birds);
							birds.loop = true;
							trace("birds.framNUm : " + birds.numFrames);
							birds.play();
						}
					}else {
						for (var j : int = 0; j < randomNum;j ++ ) {
							var poolBirds : MovieClip = birdsPool.shift();
							poolBirds.x = pos.x + Math.random() * 20;
							poolBirds.y = pos.y;
							poolBirds.data.oldTime = getTimer();
							birdsList.push(poolBirds);
							poolBirds.visible = true;
							scale = Math.random() * 0.5 + 0.5;
							if (Math.random() < 0.5) {
								poolBirds.scaleX = poolBirds.scaleY = scale;
								poolBirds.data.vx =  (-Math.random() * 3 - 1) * Screen.wRatio;
							}else {
								poolBirds.scaleX = -1 * scale;
								poolBirds.scaleY = scale;
								poolBirds.data.vx =  (Math.random() * 3 + 1) * Screen.wRatio;
							}
							poolBirds.data.vy = (-Math.random() * 3 - 1) * Screen.ratio;
							juggler.add(poolBirds);
							poolBirds.play();
						}
					}
					SoundManager.getInstance().play("bird");
				}
				trace("birds.length : " + (birdsList.length));
			}else {
				
				if (owlList.length < 2) {
					
					if (pos.x < UICoordinatesFactory.getNewPosX(500)) {
						owlPosNode = owlPosList[int(Math.random() * 2)];
					}else {
						owlPosNode = owlPosList[int(Math.random() * 2 + 2)];
					}
					trace("owlPosNode : " + owlPosNode);
					if(owlPool.length < 1){
						var owlBird : Image = new Image(owlTexture);
						owlBird.x = owlPosNode.startPos.x;
						owlBird.y = owlPosNode.startPos.y;
						owlBird.data.oldY = pos.y;
						owlBird.data.endY = owlPosNode.endPos.y;
						addChild(owlBird);
						owlList.push(owlBird);
						owlBird.touchable = false;
						TweenLite.to(owlBird, 0.5, { y : (owlPosNode.endPos.y), ease:Quart.easeIn, onComplete : keepTimer, onCompleteParams : [owlBird] } );
					}else {
						var poolOwl : Image = owlPool.shift();
						poolOwl.visible = true;
						poolOwl.x = owlPosNode.startPos.x;
						poolOwl.y = owlPosNode.startPos.y;
						owlList.push(poolOwl);
						poolOwl.data.oldY = pos.y;
						poolOwl.data.endY = owlPosNode.endPos.y;
						TweenLite.to(poolOwl,0.5,{y : (owlPosNode.endPos.y),ease:Quart.easeIn,onComplete : keepTimer,onCompleteParams : [poolOwl]});
					}
					SoundManager.getInstance().play("owlSound");
				}else {

				}
			}
		}
		
		private function keepTimer(obj : Image):void 
		{
			TweenLite.to(obj, 2, { y : (obj.data.endY), onComplete : hideOwlHandler, onCompleteParams : [obj] } );
		}
		
		private function hideOwlHandler(obj : Image):void 
		{
			TweenLite.to(obj,0.5,{y : obj.data.oldY,ease:Quart.easeIn,onComplete : xiaoshiHandler,onCompleteParams : [obj]});
		}
		
		private function xiaoshiHandler(obj : Image):void 
		{
			for (var i : int = 0; i < owlList.length; i ++ ) {
				var towl : Image = owlList[i];
				if (towl == obj) {
					towl.visible = false;
					owlList.splice(i, 1);
					owlPool.push(towl);
					
				}
			}
		}
		
		
		private function newData():void {
			if(DeviceInfo.getDeviceType().indexOf("iphone") == -1){

			}else {
				for (var i : int = 0; i < owlPosList.length;i ++ ) {
					var node : Nodes = owlPosList[i] as Nodes;
					node.startPos.x = UICoordinatesFactory.getNewPosX(node.startPos.x);
					node.startPos.y = UICoordinatesFactory.getNewPosY(node.startPos.y);
					node.endPos.x = UICoordinatesFactory.getNewPosX(node.endPos.x);
					node.endPos.y = UICoordinatesFactory.getNewPosY(node.endPos.y);
				}
			}
		}
		
		
		private var birdResTextures : TextureAtlas;
		private var owlResTextures : TextureAtlas;
		private function setTextures():void {
			if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
				ration = 1;
			}else {
				ration = 0.5;
			}
		}
		
		
		
		public function update(data:*):void
		{
			if (isActive) {
				
				juggler.advanceTime(0.03);
				for (var i : int = 0; i < birdsList.length;i ++ ) {
					var bird : MovieClip = birdsList[i] as MovieClip;
					bird.x += bird.data.vx;
					bird.y += bird.data.vy;
					if (bird.x > (Screen.wdth + bird.width)|| bird.x < (0 - bird.width) || bird.y < (0 - bird.height) ) {
						bird.x = Screen.wdth + 100;
						bird.visible = false;
						juggler.remove(bird);
						birdsList.splice(i, 1);
						birdsPool.push(bird);
					}
				}
			}
		}
		
		public function destroy():void
		{
			for (var i : int = 0; i < birdsList.length;i ++ ) {
				if (birdsList[i]) {
					removeChild(birdsList[i],true);
				}
			}
			
			removeEventListeners();
			removeChildren();
		}
	}
}