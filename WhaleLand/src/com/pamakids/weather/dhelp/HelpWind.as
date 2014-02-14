package com.pamakids.weather.dhelp
{
	import com.pamakids.utils.CenterPivot;
	import com.pamakids.utils.DeviceInfo;
	import com.pamakids.utils.Screen;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.minterface.IDhelp;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class HelpWind extends Sprite implements IDhelp
	{
		private var mouth : Image;
		private var ipadImg : Image;
		
		private var resTexture : AssetManager;
		
		
		private var hmic : Image;
		private var helpArrow1 : Image;
		private var helpArrow2 : Image;
		private var helpArrow3 : Image;
		
		private var help03 : Image;
		public function HelpWind()
		{
			resTexture = AssetManager.getInstance();
			
			if (DeviceInfo.getDeviceType().indexOf("iphone") == -1) {
				trace("pad");
				mouth = new Image(resTexture.getTexture("mouth_help"));
				addChild(mouth);
				mouth.x = UICoordinatesFactory.getNewPosX(156);
				mouth.y = UICoordinatesFactory.getNewPosY(220);
				mouth.touchable = false;
				
				ipadImg = new Image(resTexture.getTexture("ipad"));
				addChild(ipadImg);
				ipadImg.touchable = false;
				ipadImg.x = UICoordinatesFactory.getNewPosX(436);
				ipadImg.y = UICoordinatesFactory.getNewPosY(297);
				
				helpArrow1 = new Image(resTexture.getTexture("help_arrow1"));
				addChild(helpArrow1);
				helpArrow1.touchable = false;
				helpArrow1.x = UICoordinatesFactory.getNewPosX(400);
				helpArrow1.y = UICoordinatesFactory.getNewPosY(343);
				
				helpArrow2 = new Image(resTexture.getTexture("help_arrow2"));
				addChild(helpArrow2);
				helpArrow2.touchable = false;
				helpArrow2.x = UICoordinatesFactory.getNewPosX(393);
				helpArrow2.y = UICoordinatesFactory.getNewPosY(353);
				
				helpArrow3 = new Image(resTexture.getTexture("help_arrow3"));
				addChild(helpArrow3);
				helpArrow3.touchable = false;
				helpArrow3.x = UICoordinatesFactory.getNewPosX(392);
				helpArrow3.y = UICoordinatesFactory.getNewPosY(371);
				
				
				hmic = new Image(resTexture.getTexture("hmic"));
				addChild(hmic);
				hmic.touchable = false;
				hmic.x = UICoordinatesFactory.getNewPosX(315);
				hmic.y = UICoordinatesFactory.getNewPosY(376);
			}else {
				trace("iphone");
				help03 = new Image(resTexture.getTexture("help03"));
				help03.touchable = false;
				addChild(help03);
				CenterPivot.center(help03);
				help03.x = Screen.wdth * 0.5;
				help03.y = Screen.hght * 0.5;
			}
			

			
		}
		
		public function play():void
		{
			
		}
		
		public function stop():void
		{
			
		}
		
		public function destroy():void
		{
			
		}
	}
}