package com.pamakids.weather.items
{
	import com.pamakids.utils.ColorUtils;
	import com.pamakids.utils.Screen;
	import com.pamakids.utils.dinput.MouseDown;
	import com.pamakids.utils.dinput.MouseMove;
	import com.pamakids.utils.dinput.MouseUp;
	import com.pamakids.weather.factory.AMoviePlayer;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.model.GameData;
	import com.pamakids.weather.model.SoundManager;
	
	import flash.geom.Point;
	
	import starling.animation.Juggler;
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
	
	public class TreeItem extends Sprite implements IItem
	{
		public var callBack : Function;
		public var callBird : Function;
		public var callWood : Function;
		
		private var m_tree : MovieClip;
		private var m_tree_snow : MovieClip;
		private var m_snow_left : MovieClip;
		private var m_snow_right : MovieClip;
		
		private var isActive : Boolean = false;
		private var isMoved : Boolean = false;
		private var juggler : Juggler = new Juggler();
		
		private var curAlpha : Number = 1;
		public function TreeItem()
		{
			super();
		}
		
		public function init():void
		{	
			instanll();
		}
		
		public function updateDayState():void {
			trace("更新树的天色情况");
			if (GameData.dayState == 0) {
				if(isMoved == false){
					changeToDefaultColor(m_snow_right, 0);
					changeToDefaultColor(m_snow_left, 0);
					changeToDefaultColor(m_tree, 0,false);
					changeToDefaultColor(m_tree_snow, 0);
					m_tree_snow.alpha = curAlpha;
				}
			}else {
				if (isMoved == false) {	
					trace("晚上树上的雪变了么");
					changeToDefaultColor(m_snow_right, 1);
					changeToDefaultColor(m_snow_left, 1);
					changeToDefaultColor(m_tree, 1,false);
					changeToDefaultColor(m_tree_snow, 1);
					m_tree_snow.alpha = curAlpha;
				}
			}
		}
		
		public function changeColor(obj : Quad,color : uint):void {
			obj.color = color;
		}
		
		public function updateSnowState():void {
			
			if (GameData.isSnowing) {
				if (GameData.snowState == 1) {	
					trace("树上的雪显示出来");
					m_tree_snow.visible = true;
					m_tree_snow.data.hasSnow = true;
					m_tree_snow.alpha = 0.4;
					curAlpha = 0.4;
					addChild(m_tree_snow);
				}else if (GameData.snowState == 2) {
					m_tree_snow.alpha = 0.8;
					curAlpha = 0.8;
				}else if (GameData.snowState == 3) {
					m_tree_snow.alpha = 1;
					curAlpha = 1;
				}
			}else {
				trace("树上的雪融化了!");
				if (GameData.snowState == 2) {
					m_tree_snow.alpha = 0.8;
					curAlpha = 0.8;
				}else if (GameData.snowState == 1) {
					m_tree_snow.alpha = 0.4;
					curAlpha = 0.4;
				}else if (GameData.snowState == 0) {
					m_tree_snow.visible = false;
					m_tree_snow.data.hasSnow = false;
					curAlpha = 0;
				}
			}

		}
		
		public function update(data:*):void
		{
			if (isActive) {
				juggler.advanceTime(0.03);
			}
		}
		
		public function reStart():void {
			isActive = true;
			initEvents();
		}
		
		public function reset():void {
			trace("树开始重置~~~~~~~~~~~~~~~~~~~~~~~`");
			isActive = false;
			initData();
			removeEvents();
		}
		
		public function destroy():void
		{
			removeChild(m_tree,true);
			removeEventListeners();
			removeChildren();
		}
		
		private function initData():void {
			changeToDefaultColor(m_tree, 0, false);
			changeToDefaultColor(m_snow_left, 0);
			changeToDefaultColor(m_snow_right, 0);
			changeToDefaultColor(m_tree_snow, 0);
			
			m_snow_left.visible = false;
			m_snow_right.visible = false;
			m_tree_snow.visible = false;
			m_tree_snow.alpha = 1;
			isMoved = false;
			curAlpha = 1;
		}
		
		private function removeEvents():void {
			m_tree.removeEventListener(Event.COMPLETE, onMoiveComHandler);
			m_snow_left.removeEventListener(Event.COMPLETE, onSnowLeftComHandler);
			m_snow_right.removeEventListener(Event.COMPLETE, onSnowRightComHandler);
			m_tree.removeEventListener(TouchEvent.TOUCH, onTouchTree);
		}
		
		private function initEvents():void {
			m_tree.addEventListener(Event.COMPLETE, onMoiveComHandler);
			m_snow_left.addEventListener(Event.COMPLETE, onSnowLeftComHandler);
			m_snow_right.addEventListener(Event.COMPLETE, onSnowRightComHandler);
			m_tree.addEventListener(TouchEvent.TOUCH, onTouchTree);
		}
		
		
		private var resTextureAtls : AssetManager;
		private var snowTextureAtls : AssetManager;
		private function setTexture():void {
			resTextureAtls = AssetManager.getInstance();
			snowTextureAtls = AssetManager.getInstance();
		}
		
		private function instanll():void {
			setTexture();
			
			var treeTextureAtls : Vector.<Texture> = resTextureAtls.getTextures("treemove");
			m_tree = new MovieClip(treeTextureAtls, 15);
			addChild(m_tree);
			setDefaultColor(m_tree);
			changeToDefaultColor(m_tree,0,false);
			
			m_tree.x = UICoordinatesFactory.getNewPosX(244);
			m_tree.y = UICoordinatesFactory.getNewPosY(310);
			m_tree.loop = false;
			m_tree.addEventListener(Event.COMPLETE, onMoiveComHandler);
			
			//左雪
			
			var leftTexturs : Vector.<Texture> = snowTextureAtls.getTextures("leftsnow");
			m_snow_left = new MovieClip(leftTexturs, 12);
			m_snow_left.pivotX = m_snow_left.width * 0.5;
			m_snow_left.pivotY = m_snow_left.height * 0.5;
			m_snow_left.scaleX = -1;
			m_snow_left.x = UICoordinatesFactory.getNewPosX(240);
			m_snow_left.y = UICoordinatesFactory.getNewPosY(359);
			m_snow_left.loop = true;
			addChild(m_snow_left);
			m_snow_left.visible = false;
			m_snow_left.touchable = false;
			setDefaultColor(m_snow_left);
			changeToDefaultColor(m_snow_left, 0);
			
			m_snow_left.addEventListener(Event.COMPLETE,onSnowLeftComHandler);
			
			//右雪
			var rightTexturs : Vector.<Texture> = snowTextureAtls.getTextures("rightlsnow");
			m_snow_right = new MovieClip(rightTexturs, 12);
			m_snow_right.pivotX = m_snow_right.width * 0.5;
			m_snow_right.pivotY = m_snow_right.height * 0.5;
			m_snow_right.scaleX = -1;
			m_snow_right.x = UICoordinatesFactory.getNewPosX(366);
			m_snow_right.y = UICoordinatesFactory.getNewPosY(328);
			m_snow_right.loop = true;
			addChild(m_snow_right);
			m_snow_right.visible = false;
			m_snow_right.touchable = false;
			setDefaultColor(m_snow_right);
			changeToDefaultColor(m_snow_right, 0);
			
			m_snow_right.addEventListener(Event.COMPLETE,onSnowRightComHandler);
			
			
			
			var snowTreeTextureAtls : Vector.<Texture> = resTextureAtls.getTextures("snowmove");
			m_tree_snow = new MovieClip(snowTreeTextureAtls, 15);
			m_tree_snow.x = UICoordinatesFactory.getNewPosX(244);
			m_tree_snow.y = UICoordinatesFactory.getNewPosY(310);
			m_tree.loop = false;
			m_tree_snow.touchable = false;
			setDefaultColor(m_tree_snow);
			changeToDefaultColor(m_tree_snow,0);
			
			if (this.callBack != null) {
				this.callBack();
			}
			
			isActive = true;
			m_tree.addEventListener(TouchEvent.TOUCH, onTouchTree);
		}
		
		private function onSnowRightComHandler(e:Event):void 
		{
			trace("右边雪播放完毕了");
			m_snow_right.visible = false;
			m_snow_right.currentFrame = 0;
			juggler.remove(m_snow_right);
		}
		
		private function onSnowLeftComHandler(e:Event):void 
		{
			trace("左边雪播放完毕了");
			m_snow_left.visible = false;
			m_snow_left.pause();
			m_snow_left.currentFrame = 0;
			juggler.remove(m_snow_left);
			
			juggler.add(m_snow_right);
			m_snow_right.play();
			
		}
		
		private function onMoiveComHandler(e:Event):void 
		{
			m_tree.stop();
			juggler.remove(m_tree);
			
			if (m_tree_snow.parent) {
				m_tree_snow.stop();
				juggler.remove(m_tree_snow);
			}
			
			if (GameData.snowState == 0 && GameData.isSnowing == false&&GameData.dayState == 1 ) {
				if (this.callWood != null) {
					this.callWood();
				}
			}
		}
		
		
		
		
		private function onTouchTree(e:TouchEvent):void 
		{
			var touch : Touch = e.getTouch(stage);
			if (touch) {
				if (touch.phase == TouchPhase.BEGAN) {
					onMouseDownHandler(touch);
				}else if (touch.phase == TouchPhase.MOVED) {
					onMouseMoveHandler(touch);
				}else if (touch.phase == TouchPhase.ENDED) {
					if (isMoved == false) {
						if (this.callBird != null) {
							this.callBird(new Point(m_tree.x + 80 * Screen.ratio,m_tree.y + 100 * Screen.ratio));
						}
					}else {
						onMouseUpHandler(touch);
					}
					isMoved = false;
				}
			}
		}
		
/*		private function onTreeChangeHandler(e:AnimationEvent):void 
		{
			if (e.begin == false) {
				m_snow_left.pause();
				m_snow_right.pause();
				trace("暂停了啊--------------------------------");
				m_snow_left.visible = false;
				m_snow_right.visible = false;
			}
		}*/
		
		private function onMouseDownHandler(e : Touch):void 
		{
			m_tree.data.oldX = e.globalX;
			m_tree.data.oldY = e.globalY;
		}
		
		private function onMouseUpHandler(e : Touch):void 
		{
			if (GameData.dayState == 0) {
				juggler.add(m_tree);
				changeToDefaultColor(m_tree, 0);
				changeToDefaultColor(m_snow_left,0);
			}else {
				juggler.add(m_tree);
				changeToDefaultColor(m_tree, 1);
				changeToDefaultColor(m_snow_left,1);
			}
			m_tree.stop();
			m_tree.play();
			SoundManager.getInstance().play("tree",1);
			
			if (m_tree_snow.data.hasSnow) {
				if (GameData.dayState == 0) {
					juggler.add(m_tree_snow);
					changeToDefaultColor(m_tree_snow,0);
					
					m_tree_snow.alpha = curAlpha;
				}else {
					juggler.add(m_tree_snow);
					changeToDefaultColor(m_tree_snow,1);
					m_tree_snow.alpha = curAlpha;
				}
				m_tree_snow.stop();
				m_tree_snow.play();
				if (m_snow_left.visible) {
					
				}else {
					m_snow_left.visible = true;
				}
				m_snow_left.currentFrame = 0;
				juggler.add(m_snow_left);
				m_snow_left.play();
			}
			
		}
		
		private function onMouseMoveHandler(e : Touch):void {
			var dx : Number = e.globalX - m_tree.data.oldX;
			var dy : Number = e.globalY - m_tree.data.oldY;
			var k : int = dx > 0?1:-1;
			var len : int = Math.sqrt(dx * dx + dy * dy);
			var list : Array = [];
			if (len >= 30 * Screen.ratio) {
				isMoved = true;
				if (len >= 150 * Screen.ratio) {
					len = 150 * Screen.ratio;
				}
				var index : int = 0;
				if (k == -1) {
					list = ["7", "8", "9"];
					index = int(len / (50 * Screen.ratio));
				}else if (k == 1) {
					list = ["2", "3", "4"];
					index = int(len / (50 * Screen.ratio));
				}
				if (GameData.dayState == 0) {
					m_tree.currentFrame = int(list[index - 1]);
				}else {
					m_tree.currentFrame = int(list[index - 1]);
				}
				m_tree.data.curFrame = int(list[index - 1]);
				if (m_tree_snow.data.hasSnow) {
					if(GameData.dayState == 0){
						m_tree_snow.currentFrame = int(list[index - 1]);
					}else {
						m_tree_snow.currentFrame = int(list[index - 1]);
					}
				}
			}
		}
	
		private function setDefaultColor(obj : Image):void {
			obj.data.defaultColor = obj.color;
		}
		
		//设置颜色
		//@mode 0 : 恢复默认颜色 1 : 生成新的颜色
		private function changeToDefaultColor(obj : Image, mode : int = 0, isSnow : Boolean = true ):void {
			if (mode == 0) {
				obj.color = obj.data.defaultColor;
			}else if (mode == 1) {
				if(isSnow){
					obj.color = ColorUtils.getNewColor(obj.data.defaultColor, ColorUtils.snowColorTrans);
				}else {
					obj.color = ColorUtils.getNewColor(obj.data.defaultColor, ColorUtils.islandColorTrans);
				}
			}
		}
	}
}