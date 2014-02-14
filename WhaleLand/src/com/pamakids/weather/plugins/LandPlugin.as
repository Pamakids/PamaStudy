package com.pamakids.weather.plugins
{
	import as3logger.Logger;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.gslib.net.hires.debug.Stats;
	import com.pamakids.core.IPlugin;
	import com.pamakids.core.PluginControl;
	import com.pamakids.core.PluginsID;
	import com.pamakids.core.msgs.CreatNewCloudMsg;
	import com.pamakids.core.msgs.DayMsg;
	import com.pamakids.core.msgs.DelAllMsg;
	import com.pamakids.core.msgs.EarthquakeMsg;
	import com.pamakids.core.msgs.FireMsg;
	import com.pamakids.core.msgs.LightIconMsg;
	import com.pamakids.core.msgs.LoadIsLandMsg;
	import com.pamakids.core.msgs.LoadPigMsg;
	import com.pamakids.core.msgs.MsgBase;
	import com.pamakids.core.msgs.NiceLightsMsg;
	import com.pamakids.core.msgs.NightMsg;
	import com.pamakids.core.msgs.OpenMailMsg;
	import com.pamakids.core.msgs.PigHappyMsg;
	import com.pamakids.core.msgs.PigThinkMsg;
	import com.pamakids.core.msgs.RemindPigMsg;
	import com.pamakids.core.msgs.RemovehelpMsg;
	import com.pamakids.core.msgs.SnowBallGameMsg;
	import com.pamakids.core.msgs.SnowEndMsg;
	import com.pamakids.core.msgs.SnowMsg;
	import com.pamakids.core.msgs.SnowSateMsg;
	import com.pamakids.core.msgs.StartMoonMsg;
	import com.pamakids.core.msgs.StartSunMsg;
	import com.pamakids.core.msgs.SunEnergyMsg;
	import com.pamakids.core.msgs.SunMsg;
	import com.pamakids.core.msgs.TouchMsg;
	import com.pamakids.core.msgs.WorldEndMsg;
	import com.pamakids.core.msgs.WorldPeaceMsg;
	import com.pamakids.effects.weather.Earthquake;
	import com.pamakids.uimanager.UIGlobal;
	import com.pamakids.uimanager.UIManager;
	import com.pamakids.utils.ColorUtils;
	import com.pamakids.utils.DeviceInfo;
	import com.pamakids.utils.Screen;
	import com.pamakids.utils.dinput.Micropoe;
	import com.pamakids.weather.factory.AssetManager;
	import com.pamakids.weather.factory.BitmapDataLibrary;
	import com.pamakids.weather.factory.UICoordinatesFactory;
	import com.pamakids.weather.items.AnimalsItem;
	import com.pamakids.weather.items.FlyWhales;
	import com.pamakids.weather.items.IsLandItem;
	import com.pamakids.weather.items.SmallSnowManItem;
	import com.pamakids.weather.items.SnowManItem;
	import com.pamakids.weather.items.SnowManShow;
	import com.pamakids.weather.items.TipItem;
	import com.pamakids.weather.model.GameData;
	import com.pamakids.weather.model.SoundManager;
	import com.pamakids.weather.ui.Help;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.events.TouchPhase;
	import starling.extensions.ParticleDesignerPS;
	import starling.utils.Color;
	
	public class LandPlugin implements IPlugin
	{
		private var island : IsLandItem;
		
		private var pig : AnimalsItem;
		
		private var help : Help;
		
		private var isActive : Boolean = true;
		
		private var earthQuake : Earthquake = new Earthquake();
		
		private var flyWhales : FlyWhales;
		
		private var iceNight : Image;
		
		private var mParticleSystem : ParticleDesignerPS;
		
		private var worldChannel : SoundChannel;
		
		//烟花
		private var firWorks : MovieClip;
		
		private var _juggler : Juggler = new Juggler();
		
		private var isIsLandDown : Boolean = false;
		
		private var m_timer : Timer = new Timer(18000, 1);
		
		//雪人
		private var  smallesm : SmallSnowManItem;
		private var sshow : SnowManShow; 
		private var sm : SnowManItem;
		
		//
		private var tipItem : TipItem;
		
		private var ttTime : uint;
		
		public function LandPlugin()
		{

		}
		
		public function Init():void
		{
			trace("陆地插件初始化 : " + Stats.tFps);
			
			pig = new AnimalsItem();
			pig.loadOtherRes = loadOtherItem;
			island = new IsLandItem();
			island.y = -10;
			island.callHelpFun = loadHelp;
			
			
			sshow = new SnowManShow()
			GameData.snowmanshow = sshow;
			sshow.visible = false;
			
			
			smallesm = new SmallSnowManItem();
			UIManager.GetLayer(UIGlobal.BACKGROUND1_LAYER).addChild(smallesm);
			smallesm.visible = false;
			
			//add
/*			sshow.visible = true;
			sshow.init();
			smallesm.visible = true;
			smallesm.init();*/
			//add
			
			
			tipItem = new TipItem();
			tipItem.init();
			UIManager.AddUiToLayer(island, UIGlobal.BACKGROUND1_LAYER);
			UIManager.AddUiToLayer(sshow,UIGlobal.BACKGROUND1_LAYER);
			UIManager.AddUiToLayer(pig, UIGlobal.BACKGROUND1_LAYER);
			UIManager.AddUiToLayer(tipItem, UIGlobal.BACKGROUND3_LAYER);
			
		}
		
		private function loadOtherItem():void 
		{
			iceNight = new Image(AssetManager.getInstance().getTexture("ice_night"));
			iceNight.x = UICoordinatesFactory.getNewPosX(-42);
			iceNight.y = UICoordinatesFactory.getNewPosY(768);//465
			iceNight.touchable = false;
			iceNight.visible = false;
			UIManager.GetLayer(UIGlobal.BACKGROUND4_LAYER).addChild(iceNight);
			
			fireTimer = new Timer(2000, 1);
			fireTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onFireTimeHandler);
			fireTimer.start();
			
		}
		
		private var fireTimer : Timer;
		private function loadFireworks():void 
		{	
			GameData.allResIsOK = true;
			
			//trace("烟花加载完毕了  :" + Stats.tFps);
		}
		
		private function onFireTimeHandler(e:TimerEvent):void 
		{
			trace("所有资源加载完毕了 : " + Stats.tFps);
			fireTimer.stop();
			fireTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onFireTimeHandler);
			fireTimer = null;
			loadFireworks();			
		}
		
		private function openSnowBallGame():void 
		{

		}
		
		
		private function loadHelp():void 
		{
			
			tipItem.hideArrow();
			
			help = new Help();
			help.setCallBack(delHelp);
			help.init(GameData.getCurDesire());
			UIManager.AddUiToLayer(help, UIGlobal.BACKGROUND3_LAYER);
		}
		
		private function delHelp():void 
		{
			help.destroy();
			UIManager.GetLayer(UIGlobal.BACKGROUND3_LAYER).removeChild(help,true);
		}
		
		public function Release():void
		{
		}
		
		public function Update():void
		{
			
			if (isActive) {
				island.update(null);
				
			}
			pig.update(null);
			_juggler.advanceTime(0.03);
		}
		
		public function ReStart():void {
			pig.reStart();
			island.reStart();
			isActive = true;
		}
		
		public function GetVersion():Number
		{
			return 0;
		}
		
		public function GetID():int
		{
			return PluginsID.LAND_PLUGIN;
		}
		
		public function OnBroadcastMsg(msg:MsgBase):void
		{
			
			if (msg is TouchMsg) {
				var tmsg : TouchMsg = msg as TouchMsg;
				trace("msg.type : " + tmsg.type);
				trace("msg.target : " + tmsg.targetName);
				if (tmsg.type == TouchPhase.BEGAN) {
					help.denabled();
				}else if (tmsg.type == TouchPhase.ENDED) {
					help.enabled();
				}
			}
			
			if (msg is RemovehelpMsg) {
				delHelp();
			}
			
			if (msg is LightIconMsg) {
				tipItem.showMedal();
				tipItem.hideArrow();
			}
			
			if (msg is RemindPigMsg) {
				pig.pigComeon();
			}
			
			
			if (msg is DelAllMsg) {
				TweenLite.killTweensOf(iceNight, true);
				TweenLite.killTweensOf(UIManager.GetLayer(UIGlobal.BACKGROUND1_LAYER), true);
				TweenLite.killTweensOf(sm);
				pig.reset();
				if (help) {
					help.destroy();
				}
				if (firWorks) {
					firWorks.visible = false;
				}
				
				island.reset();
				earthQuake.stop();
				
				if (iceNight) {
					iceNight.visible = false;
				}
				
				if (mParticleSystem) {
					mParticleSystem.visible = false;
				}
				
				UIManager.GetLayer(UIGlobal.BACKGROUND1_LAYER).y = 0;
				smallesm.visible = false;
				sshow.visible = false;
				sshow.SnowManshowxiaohui();
				smallesm.SnowremoveEventListener();
			}
			
			//火
			if (msg is FireMsg) {
				
				//
				GameData.nightDesireList[0] = 1;
				GameData.setWishComTime(5,getTimer());
				GameData.setWishComTime(6,getTimer());
				
				
				pig.firePig();
			}
			
			
			//出现雪人换装游戏
			if (msg is SnowBallGameMsg) {
				var gData : SnowBallGameMsg = msg as SnowBallGameMsg;
				if(gData.msgType == 0){
					sm = new SnowManItem();
					sm.init(gData.faceType,gData.handType,gData.collarType);
					sm.alpha=0;
					TweenLite.to(sm, 1, {autoAlpha:1});
					UIManager.AddUiToLayer(sm, UIGlobal.BACKGROUND4_LAYER);
				}else if (gData.msgType == 1) {
					trace("移除大雪人换装游戏");
					UIManager.GetLayer(UIGlobal.BACKGROUND4_LAYER).removeChild(sm,true);
					sshow.returnsmall(gData.faceType, gData.handType, gData.collarType);
					
					if (gData.faceType || gData.handType || gData.collarType) {
						trace("雪人换装完毕了....................");
						GameData.dayDesireList[4] = 1;
						
						
						GameData.setWishComTime(4,getTimer());
						
					}
					
				}
			}
			
			
			if (msg is WorldEndMsg) {
				isActive = false;
				
				//Micropoe.stop();
				
				if (island.isLightOn) {
					
				}else {
					island.onHouseLightTouch();
				}
				
				//
				if (GameData.nightDesireList[3] == 0) {
					
					}
				GameData.nightDesireList[3] = 1;
				//
				
				GameData.setWishComTime(8,getTimer());
				
				//加载烟花
				if (firWorks == null) {
					firWorks = new MovieClip(AssetManager.getInstance().getTextures("yanhua"), 24);
					UIManager.GetLayer(UIGlobal.BACKGROUND4_LAYER).addChild(firWorks);
					firWorks.loop = true;
					setDefaultColor(firWorks);
					firWorks.pivotX = firWorks.width * 0.5;
					firWorks.pivotY = firWorks.height * 0.5;
					firWorks.addEventListener(starling.events.Event.COMPLETE, onFireworksCom);
				}
				firWorks.x = (Math.random() * 768 + 150) * Screen.wRatio;
				firWorks.y = (Math.random() * 100 + 50) * Screen.ratio;
				firWorks.currentFrame = 0;	
				firWorks.visible = false;
				//
				
				pig.firePig();
				
				island.showGuangDian();
				SoundManager.getInstance().stopBgMusic(GameData.curBgMusic);
				if(worldChannel){
					worldChannel.stop();
				}
				
				
				ttTime = getTimer();
				
				worldChannel = SoundManager.getInstance().soundDic["fly2"].play(0, 1);
				worldChannel.addEventListener(flash.events.Event.SOUND_COMPLETE,onSoundComPleteHandler);
				
				UIManager.GetLayer(UIGlobal.BACKGROUND0_LAYER).touchable = false;
				UIManager.GetLayer(UIGlobal.BACKGROUND1_LAYER).touchable = false;
				UIManager.GetLayer(UIGlobal.BACKGROUND2_LAYER).touchable = false;
				UIManager.GetLayer(UIGlobal.BACKGROUND3_LAYER).touchable = false;
				
				tipItem.hideArrow();
				UIManager.GetLayer(UIGlobal.BACKGROUND2_LAYER).visible = false;
			}
			
			if (msg is NiceLightsMsg) {
				if ((msg as NiceLightsMsg).data == 0) {
					island.hideTheDian();
				}else {
					island.showGuangDian();
				}
				
			}
			
			if (msg is WorldPeaceMsg) {
				//这名字得修改，不太合适了
				isIsLandDown = true;
				
				pig.resetTime();
				//
				mParticleSystem.stop();
				Starling.juggler.remove(mParticleSystem);
				mParticleSystem.visible = false;
				//
				island.hideTheWhales();
				island.onHouseLightTouch();
				TweenLite.to(iceNight, 1, { y : Screen.hght, alpha : 0 } );
				island.hideTheDian();
			}
			
			
			if (msg is SnowMsg) {
				if(island.curState == 0){
					pig.run();
				}
				
				if (GameData.dayState == 1) {
					pig.wakeup();
				}
				
				
			}
			
			if (msg is OpenMailMsg) {
				island.openTheMail();
				
				tipItem.showArrow();
			}
			
			if (msg is EarthquakeMsg) {
				
				trace("小猪开始颤抖，播放冻冰动画的前7帧");
				pig.trembling();
				
				if ((msg as EarthquakeMsg).data == 1) {
					
					//这块得注意下可能为负值
					var haveTime : Number = 23 - ((msg as EarthquakeMsg).curTime - (msg as EarthquakeMsg).oldTime) / 1000;
					Logger.log("havetgime : " + haveTime);
					if (haveTime <= 0) {
						haveTime = 1;
					}
					earthQuake.callBack = whalesFly;
					trace("havetgime : " + haveTime);
					Logger.log("havetgime : " + haveTime);
					earthQuake.go(UIManager.GetLayer(UIGlobal.BACKGROUND1_LAYER), 10, haveTime);
					
					trace("冰出现");
					if(DeviceInfo.getDeviceType().indexOf("iphone") == -1){
						iceNight.x = -42;
					}else {
						iceNight.x = 0;
					}
					iceNight.y = Screen.hght;
					iceNight.visible = true;
					iceNight.alpha = 1;
					TweenLite.to(iceNight, 1, { y : 465 * Screen.ratio } );
					
					//泡泡
					if (mParticleSystem == null) {
						mParticleSystem = new ParticleDesignerPS(BitmapDataLibrary.getparticleXML(), BitmapDataLibrary.getparticleTexture()); 
						mParticleSystem.emitterX = Screen.wdth * 0.5; 
						mParticleSystem.emitterY = Screen.hght;
						mParticleSystem.maxNumParticles = 400 * Screen.ratio;
						mParticleSystem.emitterXVariance = Screen.wdth * 0.5;
						mParticleSystem.start(); 
						
						UIManager.GetLayer(UIGlobal.BACKGROUND3_LAYER).addChild(mParticleSystem);
						Starling.juggler.add(mParticleSystem);
					}else {
						mParticleSystem.visible = true;
						mParticleSystem.start();
						Starling.juggler.add(mParticleSystem);
					}
					
				}
				//earthQuake.vx = (msg as EarthquakeMsg).data * 0.5 + 5;
				//earthQuake.vy = (msg as EarthquakeMsg).data * 0.5 + 5;
			}
			
			
			if (msg is SnowEndMsg) {
				trace("下雪结束了!,小猪别跑了");
				pig.stopRun();
			}
			
			if (msg is SunEnergyMsg) {
				trace("太阳能里能量接收!");
				if (GameData.snowState > 0 && GameData.snowIsEnd == true && GameData.dayState == 0) {
					GameData.snowState = island.snowState - 1;
					island.updateSnowState(island.snowState - 1);
					
						if (GameData.snowState == 2) {
							GameData.snowballNum = 0;
							GameData.hasDressUp = false;
							trace("开始化雪人");
							if (smallesm) {
								smallesm.SnowremoveEventListener();
								smallesm.visible = false;
							}
							if (sshow) {
								sshow.SnowManshowxiaohui();
								sshow.visible = false;
							}
						}
				}else {
					
				}
			}
			
			if (msg is LoadIsLandMsg) {
				island.init();
			}
			
			if (msg is StartMoonMsg) {
				trace("island.curState : " + island.curState);
				if (island.curState != 1) {
					island.updateHouse(1);
				}
				if (sshow) {
					sshow.updateDay(1);
				}
				
				//重置
				
				pig.icePig();
				
			}
			
			if (msg is StartSunMsg) {
				if (island.curState == 0) {
					
				}else {
					island.updateHouse(0);
					pig.firePig();
					
					if (sshow) {
						sshow.updateDay(0);
					}
				}
				
				pig.updateData();
				//重置晚上的数据
				GameData.resetAchievements(1);
			}
			
			if (msg is DayMsg) {
				if (island.curState != 0) {
					island.updateHouse(0);
					pig.firePig();
					if (sshow) {
						sshow.updateDay(0);
					}
				}
			}
			
			if (msg is NightMsg) {
				if (island.curState == 1) {
					
				}else {
					island.updateHouse(1);
					pig.icePig();
					
					if (sshow) {
						sshow.updateDay(1);
					}
				}
				
			}
			
			if (msg is LoadPigMsg) {
				
				trace("加载小猪了么 : " + Stats.tFps);
				pig.init();
			}
			
			if (msg is PigThinkMsg) {
				trace("msg is pingThink");
				pig.updateThink();
			}
			
			//小猪高兴了
			if (msg is PigHappyMsg) {
				pig.updateHappy();
			}
			
			
			if (msg is SnowSateMsg) {
				var index : int = (msg as SnowSateMsg).data;
				trace("snowState : " + index);
				island.updateSnowState(index);
				if (index == 3) {
					trace("开始能滚雪球了");
					sshow.init();
					smallesm.init();
					
					smallesm.visible = true;
					sshow.visible = true;
				}else {
					smallesm.visible = false;
					sshow.visible = false;
				}
				

			}
		}
		
		private function onSoundComPleteHandler(e : flash.events.Event):void 
		{
			worldChannel.stop();
			worldChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, onSoundComPleteHandler);
			
			
			//Micropoe.start();
			
			GameData.is2012 = false;
			isActive = true;
			UIManager.GetLayer(UIGlobal.BACKGROUND0_LAYER).touchable = true;
			UIManager.GetLayer(UIGlobal.BACKGROUND1_LAYER).touchable = true;
			UIManager.GetLayer(UIGlobal.BACKGROUND2_LAYER).touchable = true;
			UIManager.GetLayer(UIGlobal.BACKGROUND3_LAYER).touchable = true;
			
			tipItem.showArrow();
			UIManager.GetLayer(UIGlobal.BACKGROUND2_LAYER).visible = true;
			
			trace("持续时间  : " + (getTimer() - ttTime));
			
			if(GameData.dayState == 1){
				SoundManager.getInstance().playBgMusic(SoundManager.BGM_SUNNYNITE, 1000, SoundManager.getInstance().bgSoundTransform);
			}
			
		}
		
		//鲸鱼飞起来
		private function whalesFly():void 
		{	
			isIsLandDown = false;
			trace("鲸鱼可以飞起来了，哈哈, 小猪恢复常态");
			
			Logger.log("哈哈鲸鱼岛飞起来了");
			
			island.creatWhale();
			
			earthQuake.stop();
			earthQuake.callBack = null;
			earthQuake.callBack = dropDown;
			TweenLite.to(UIManager.GetLayer(UIGlobal.BACKGROUND1_LAYER), 10, { y: -214 * Screen.ratio, onComplete : tweenCom } );
			earthQuake.vy = 0;
			earthQuake.vx = 7;
			earthQuake.go(UIManager.GetLayer(UIGlobal.BACKGROUND1_LAYER), 10, 20);
			
			//TweenLite.delayedCall(20,dropDown);
			
			//鲸鱼掉下去前两秒，鲸鱼眨2下眼睛
			m_timer.reset();
			m_timer.start();
			m_timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerCompeteHandler);
		}
		
		private function onTimerCompeteHandler(e:TimerEvent):void 
		{
			island.whaleBlink();
		}
		
		//鲸鱼岛开始掉下来
		private function dropDown():void 
		{
			trace("气球烟花需要消失!,小猪恢复到常态");
			
			
			pig.resetPigAimation();
			
			island.hideTheBalloon();
			TweenLite.to(iceNight,0.2,{y : 465 * Screen.ratio});
			TweenLite.to(UIManager.GetLayer(UIGlobal.BACKGROUND1_LAYER), 2, { y:0,ease:Bounce.easeOut, onComplete : islandReset } );
		}
		
		private function islandReset():void 
		{
			island.closeHouse();
			
		}
		
		private function tweenCom():void 
		{
			TweenLite.to(iceNight, 0.5, { y : 560 * Screen.ratio, ease:Bounce.easeOut } );
			//pig.resetPigAimation();
			pig.playPose();
			//放烟花
			firWorks.play();
			firWorks.visible = true;
			_juggler.add(firWorks);

		}
		
		private function onFireworksCom(e : starling.events.Event ):void 
		{
			if(isIsLandDown == false){
				firWorks.x = (Math.random() * 768 + 150) * Screen.wRatio;
				firWorks.y = (Math.random() * 100 + 50) * Screen.ratio;
				firWorks.scaleX = firWorks.scaleY = 0.6 + Math.random() * 0.4;
				changeToDefaultColor(firWorks,Math.random() * ColorUtils.fireworkColorList.length);
				trace("放花结束了");
			}else {
				_juggler.remove(firWorks);
				firWorks.visible = false;
			}
		}
		
		private function setDefaultColor(obj : Image):void {
			obj.data.defaultColor = obj.color;
			
			trace("fireworks-red : " + Color.getRed(obj.color));
			trace("fireworks-green : " + Color.getGreen(obj.color));
			trace("fireworks-blue : " + Color.getBlue(obj.color));
		}
		
		//设置颜色
		//@mode 0 : 恢复默认颜色 1 : 生成新的颜色
		private function changeToDefaultColor(obj : Image, mode : int = -1):void {
			//trace("mode : " + mode);
			if (mode == -1) {
				obj.color = obj.data.defaultColor;
			}else{
				obj.color = ColorUtils.getNewColor(obj.data.defaultColor, ColorUtils.fireworkColorList[mode]);
			}
		}
	}
}