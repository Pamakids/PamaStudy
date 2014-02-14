package com.pamakids.weather.items
{
	import com.pamakids.uimanager.UIBase;
	import com.pamakids.utils.Screen;
	import com.pamakids.utils.dinput.Accel;
	import com.pamakids.utils.dinput.Micropoe;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.model.GameData;
	import com.urbansquall.ginger.Animation;
	import com.urbansquall.ginger.AnimationPlayer;
	import com.urbansquall.ginger.tools.AnimationBuilder;
	import com.urbansquall.ginger.tools.AnimationPlayerFactory;
	
	import flash.display.BitmapData;
	import flash.display.Scene;
	
	import starling.animation.Juggler;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class LeavesItem extends UIBase implements IItem
	{
		private var m_animationFactory : AnimationPlayerFactory;
		
		private var leavesList : Array = [];
		
		private var isActive : Boolean = true;
		
		private var moy : int = 0;
		
		private var texturesAtlas : Vector.<Texture>;
		
		private var juggler : Juggler = new Juggler();
		public function LeavesItem()
		{
			super();
		}
		
		public function init():void
		{
			texturesAtlas = AssetManager.getInstance().getTextures("Leaves");
			isActive = true;
		}
		
		public function reStart():void {
			
		}
		
		public function update(data:*):void
		{
			if (isActive) {
				juggler.advanceTime(0.03);
				if (Micropoe.mactivityLevel >= GameData.MICACTIVELEVEL) {
					//trace("leavesList.length : " + leavesList.length);
					if (leavesList.length < 3) {
						var leaves : MovieClip = new MovieClip(texturesAtlas,6);
						leaves.pivotX = leaves.width * 0.5;
						leaves.pivotY = leaves.height * 0.5;
						leaves.data.speed = Math.random() * 2 + 1;
						leaves.x = Math.random() * Screen.wdth;
						leaves.y = Math.random() * Screen.hght;
						leavesList.push(leaves);
						addChild(leaves);
						juggler.add(leaves);
						//trace("len : " + leavesList.length);
					}
				}
				
				for (var i : int = 0; i < leavesList.length; i ++ ) {
					
					//(leavesList[i] as MovieClip).update(30);
					var mx : Number = 0;
					if (Micropoe.mactivityLevel <= GameData.MICACTIVELEVEL1) {
						mx = 1;
					}else {
						mx = Micropoe.mactivityLevel * 0.1;
					}
					(leavesList[i] as MovieClip).x += mx;
					(leavesList[i] as MovieClip).y += (leavesList[i] as MovieClip).data.speed;
					//(leavesList[i] as MovieClip).rotation += 1;
					
					if ((leavesList[i] as MovieClip).x > Screen.wdth) {
						(leavesList[i] as MovieClip).x = 10;
					}else if ((leavesList[i] as MovieClip).x < 0) {
						(leavesList[i] as MovieClip).x = Screen.wdth - 20;
					}
					
					if ((leavesList[i] as MovieClip).y > Screen.hght + 10) {
						juggler.remove(leavesList[i]);
						removeChild(leavesList[i]);
						leavesList.splice(i,1);
					}
					

				}
			}
		}
		
		public function destroy():void
		{
			this.removeChildren();
			isActive = false;
		}
	}
}