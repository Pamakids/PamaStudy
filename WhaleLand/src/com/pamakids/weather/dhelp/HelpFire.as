package com.pamakids.weather.dhelp
{
	import com.greensock.TweenLite;
	import com.pamakids.core.PluginControl;
	import com.pamakids.core.msgs.TouchMsg;
	import com.pamakids.utils.ColorUtils;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.behavior.FrictionBehavior;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.minterface.IDhelp;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ParticleDesignerPS;
	import starling.textures.Texture;
	
	public class HelpFire extends Sprite implements IDhelp
	{
		private var fireWoodTexture : Texture;
		private var firewood : Image;
		private var mParticleSystem : ParticleDesignerPS;
		
		private var defaultX : Number = 0;
		private var defaultY : Number = 0;
		
		private var rightHand : Image;
		private var isPlaying : Boolean = false;
		
		
		private var m_tree : MovieClip;
		public function HelpFire(posx : Number = 512, posy : Number = 384)
		{
			
			defaultX = posx;
			defaultY = posy;
			
			var treeTextureAtls : Vector.<Texture>= AssetManager.getInstance().getTextures("treemove");
			m_tree = new MovieClip(treeTextureAtls, 15);
			addChild(m_tree);
			setDefaultColor(m_tree);
			changeToDefaultColor(m_tree,1,false);
			m_tree.touchable = false;
			m_tree.x = UICoordinatesFactory.getNewPosX(defaultX - 300);;
			m_tree.y = UICoordinatesFactory.getNewPosY(defaultY - 100);
			
			m_tree.addEventListener(Event.COMPLETE, onMoiveComHandler);
			
			
			
			fireWoodTexture = AssetManager.getInstance().getTexture("gouhuo");
			firewood = new Image(fireWoodTexture);
			addChild(firewood);
			firewood.x = UICoordinatesFactory.getNewPosX(defaultX);
			firewood.y = UICoordinatesFactory.getNewPosY(defaultY);
			firewood.visible = false;
			
			
			rightHand = new Image(AssetManager.getInstance().getTexture("lefthand"));
			addChild(rightHand);
			rightHand.touchable = false;
			rightHand.pivotX = 0;
			rightHand.pivotY = 0;
			
			initData();
		}
		
		private function onMoiveComHandler(e:Event):void 
		{
			Starling.juggler.remove(m_tree);
			m_tree.stop();
			
			firewood.visible = true;
			firewood.alpha = 0;
			
			TweenLite.to(firewood,1,{alpha : 1,onComplete : showFireWood});
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
		
		private function initData():void {
			rightHand.x = UICoordinatesFactory.getNewPosX(defaultX - 300);
			rightHand.y = UICoordinatesFactory.getNewPosY(defaultY);
		}
		
		
		public function play():void
		{
			if (isPlaying == false) {
				if(mParticleSystem){
					mParticleSystem.visible = false;
					Starling.juggler.remove(mParticleSystem);
				}
				rightHand.visible = true;
				isPlaying = true;
				TweenLite.to(rightHand,0.4,{x :UICoordinatesFactory.getNewPosX(defaultX - 190) ,y : UICoordinatesFactory.getNewPosY(defaultY - 90),onComplete : tweenCom});
				//TweenLite.to(rightHand,0.5,{x :UICoordinatesFactory.getNewPosX(defaultX - 30) ,y : UICoordinatesFactory.getNewPosY(defaultY - 20),onComplete : tweenCom});
			}
		}
		
		private function tweenCom():void 
		{
			TweenLite.to(rightHand,0.4,{x :UICoordinatesFactory.getNewPosX(defaultX - 300) ,y : UICoordinatesFactory.getNewPosY(defaultY),onComplete : nextTween});
		}
		
		private var count : int = 0;
		private var tCount : int = 0;
		private function nextTween():void 
		{
			
			tCount ++;
			trace("tCount : " + tCount);
			if (tCount >= 2) {
				rightHand.visible = false;
				Starling.juggler.add(m_tree);
				m_tree.play();
			}else {
				TweenLite.to(rightHand,0.4,{x :UICoordinatesFactory.getNewPosX(defaultX - 190) ,y : UICoordinatesFactory.getNewPosY(defaultY - 90),onComplete : tweenCom});
			}

		}
		
		private function showFireWood():void{
			rightHand.visible = true;
			
			rightHand.x =  UICoordinatesFactory.getNewPosX(defaultX);;
			rightHand.y = UICoordinatesFactory.getNewPosY(defaultY + 60);
			
			
			TweenLite.to(rightHand,0.5,{x :UICoordinatesFactory.getNewPosX(defaultX + 100) ,y : UICoordinatesFactory.getNewPosY(defaultY),onComplete : tweenComHandler});
		}
		
		private function tweenComHandler():void{
			TweenLite.to(rightHand,0.5,{x :UICoordinatesFactory.getNewPosX(defaultX) ,y : UICoordinatesFactory.getNewPosY(defaultY + 60),onComplete : nextTweenHandler});
		}
		
		private function nextTweenHandler():void{
			count ++;
			if (count >= 2) {
				creatFire();
			}else {
				TweenLite.to(rightHand,0.5,{x :UICoordinatesFactory.getNewPosX(defaultX + 100) ,y : UICoordinatesFactory.getNewPosY(defaultY),onComplete : tweenComHandler});
			}
		}
		
		private function creatFire():void 
		{
			rightHand.visible = false;
			
			if (mParticleSystem == null) {
				mParticleSystem = new ParticleDesignerPS(BitmapDataLibrary.getFireParticleXml(), BitmapDataLibrary.getparticleTexture()); 
				mParticleSystem.emitterType = 0;
				mParticleSystem.emitterX = firewood.x + firewood.width * 0.5; 
				mParticleSystem.emitterY = UICoordinatesFactory.getNewPosY(44) + firewood.y;
				mParticleSystem.maxNumParticles = 70 * Screen.ratio;
				mParticleSystem.speed = 70;
				mParticleSystem.startSizeVariance *= Screen.ratio;
				mParticleSystem.startSize *= Screen.ratio;
				mParticleSystem.lifespan *= Screen.ratio;
				
				mParticleSystem.start();
				addChild(mParticleSystem);
				mParticleSystem.touchable = false;
				Starling.juggler.add(mParticleSystem);
			}else {
				mParticleSystem.visible = true;
				mParticleSystem.start();
				Starling.juggler.add(mParticleSystem);
			}
			
			TweenLite.delayedCall(3,rePlay);
			
		}
		
		private function rePlay():void 
		{
			stop();
			play();
		}
		
		public function stop():void
		{
			if(mParticleSystem){
				mParticleSystem.visible = false;
				Starling.juggler.remove(mParticleSystem);
			}
			
			firewood.visible = false;
			TweenLite.killDelayedCallsTo(rePlay);
			
			TweenLite.killTweensOf(rightHand);
			TweenLite.killTweensOf(firewood);
			count = 0;
			tCount = 0;
			isPlaying = false;
			
		}
		
		public function destroy():void
		{
			
		}
	}
}