package com.pamakids.weather.model
{
	import com.umeng.extension.UmengNativeExtension;

	public class AnalyticsUtils
	{
		private static var wishNames:Array=["sun", "cloud", "snow", "snowball", "snowman", "warm", "fire", "sleep", "fly", "skate"];

		public function AnalyticsUtils()
		{

		}

		public static function init():void
		{
			try
			{
				UmengNativeExtension.manager.startWithAppKeyAndReportPolicyAndChannelId("4ff1067b527015259f000071", 0, "WhalesIsland(日文)");
				UmengNativeExtension.manager.setLogEnabled(false);
				UmengNativeExtension.manager.setCrashReportEnabled(false);
			}
			catch (error:Error)
			{

			}
		}

		public static function sendEvent(index:int):void
		{
			try
			{
				UmengNativeExtension.manager.eventWithLabel("wishTime", wishNames[index]);
			}
			catch (error:Error)
			{

			}
		}
	}
}
