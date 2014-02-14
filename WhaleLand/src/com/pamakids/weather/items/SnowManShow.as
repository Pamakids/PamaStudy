package com.pamakids.weather.items
{
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.pamakids.core.PluginControl;
	import com.pamakids.core.msgs.SnowBallGameMsg;
	import com.pamakids.uimanager.UIBase;
	import com.pamakids.uimanager.UIGlobal;
	import com.pamakids.uimanager.UIManager;
	import com.pamakids.utils.ColorUtils;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.model.GameData;
	
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;

	public class SnowManShow extends UIBase
	{
		public var snowman:Sprite;
		public var ball : Image;
		public var sm:SnowManItem;
		public var shenti : Image;
		public var tou : Image;
		public var snowlian:Image;
		public var snowshou:Image;
		public var snowmaoweibo:Image;	
		public var fanhuilian:String
		public var fanhuishou:String
		public var fanhuiweibo:String
		TweenPlugin.activate([AutoAlphaPlugin]);
		public function SnowManShow()
		{
			
		}
		
		//更新白天晚上状态0 : 白天 1 : 晚上
		public function updateDay(value : int):void {
			if (value == 0) {
				if (shenti){
				changeToDefaultColor(shenti, 0);}
				if(tou){
				changeToDefaultColor(tou, 0);}
				if(ball){
				changeToDefaultColor(ball, 0); }
				if (snowlian){
				changeToDefaultColor(snowlian, 0);}
				if(snowmaoweibo){
				changeToDefaultColor(snowmaoweibo, 0);}
				if(snowshou){
				changeToDefaultColor(snowshou, 0); }				
			}else {
				if(shenti){
				changeToDefaultColor(shenti, 1); }
				if(tou){
				changeToDefaultColor(tou, 1); }
				if(ball){
				changeToDefaultColor(ball, 1); }
				if (snowlian){
				changeToDefaultColor(snowlian, 1);}
				if(snowmaoweibo){
				changeToDefaultColor(snowmaoweibo, 1);}
				if(snowshou){
				changeToDefaultColor(snowshou,1); }
			}
		}
		
		//记录默认颜色
		private function setDefaultColor(obj : Image):void {
			obj.data.defaultColor = obj.color;
		}
		
		//设置颜色
		//@mode 0 : 恢复默认颜色 1 : 生成新的颜色
		private function changeToDefaultColor(obj : Image, mode : int = 0):void {
			if (mode == 0) {
				obj.color = obj.data.defaultColor;
			}else if (mode == 1) {
				obj.color = ColorUtils.getNewColor(obj.data.defaultColor,ColorUtils.snowColorTrans);
			}
		}
		
		
		public function SnowManshowxiaohui():void
		{
			if(snowman){
				snowman.dispose();
				snowman.removeChildren();
				fanhuilian = null
				fanhuishou = null
				fanhuiweibo = null;
				shenti.visible=false;
				tou.visible = false;
			}
		}
		
		public function init() : void
		{
			
			setTextures();
			
			snowman = new Sprite();
			this.addChild(snowman);
			
			trace("小雪人雪人加载中......");
			tou = new Image(resTextures.getTexture("snowman002"));
			setDefaultColor(tou);
			
			
			shenti = new Image(resTextures.getTexture("snowman001"));
			snowman.addChild(shenti)
			setDefaultColor(shenti);
			
			snowman.addChild(tou)
			
			
			ball = new Image(resTextures.getTexture("snowball"));
			
			addChild(ball)
			setDefaultColor(ball);
			ball.x = UICoordinatesFactory.getNewPosX(400);
			ball.y = UICoordinatesFactory.getNewPosY(600);
			ball.scaleX = 0.1
			ball.scaleY = 0.1
			ball.pivotX = 146 * Screen.ratio;
			ball.pivotY = 143 * Screen.ratio;
			ball.alpha = 0;
			
			snowman.x = UICoordinatesFactory.getNewPosX(715);
			snowman.y = UICoordinatesFactory.getNewPosY(416);
			
			shenti.visible = false;
			tou.visible = false;
			tou.scaleX = 0.3;
			tou.scaleY = 0.3;
			shenti.scaleX = 0.3;
			shenti.scaleY = 0.3;
			
			updateDay(GameData.dayState);
		
		}
		public function addsmall() : void
		{
			
			//小雪人向外广播出现雪人换装游戏
			var msg : SnowBallGameMsg = new SnowBallGameMsg();
			msg.faceType = fanhuilian;
			msg.handType = fanhuishou;
			msg.collarType = fanhuiweibo;
			msg.msgType = 0;
			PluginControl.BroadcastMsg(msg);
		}
		public function returnsmall(data1: String,data2:String,data3:String):void 
		{
			
			UIManager.GetLayer(UIGlobal.BACKGROUND4_LAYER).removeChild(sm,true)
			
			if(data1!=null)
			{
				if(snowman.contains(snowlian))
				{
					snowman.removeChild(snowlian);
					
				}
				snowlian = new Image(resTextures.getTexture(data1));
				
				snowlian.x = 226*0.3*Screen.ratio;
				snowlian.y = UICoordinatesFactory.getNewPosY(140 * 0.3);
				snowlian.scaleX = 0.3;
				snowlian.scaleY = 0.3;
				snowman.addChild(snowlian);
				setDefaultColor(snowlian);
				this.fanhuilian=data1
				
			}
			if(data2!=null)
			{
				if(snowman.contains(snowshou))
				{
					snowman.removeChild(snowshou);
				}
				
				snowshou = new Image(resTextures.getTexture(data2));
				snowshou.x = 0*0.3*Screen.ratio;
				snowshou.y = UICoordinatesFactory.getNewPosY(56 * 0.3);
				snowshou.scaleX = 0.3;
				snowshou.scaleY = 0.3;
				snowman.addChild(snowshou);
				setDefaultColor(snowshou);
				this.fanhuishou=data2
			}
			if(data3!=null)
			{
				if(snowman.contains(snowmaoweibo))
				{
					snowman.removeChild(snowmaoweibo);
					
				}
				
				snowmaoweibo = new Image(resTextures.getTexture(data3));
				snowmaoweibo.x = 87*0.3*Screen.ratio;
				snowmaoweibo.y = UICoordinatesFactory.getNewPosY(6 * 0.3);
				snowmaoweibo.scaleX = 0.3;
				snowmaoweibo.scaleY = 0.3
				snowman.addChild(snowmaoweibo);			
				setDefaultColor(snowmaoweibo);
				this.fanhuiweibo=data3
			}
			
			updateDay(GameData.dayState);
			
		}
		
		private var resTextures : AssetManager;
		private function setTextures():void {
			resTextures = AssetManager.getInstance();
		}
	}
}