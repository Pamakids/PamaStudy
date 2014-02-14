package com.pamakids.weather.factory
{
	public class SoundAsset
	{
		public static const BGM_SUNNYDAY : String = "bgm_SunnyDay";
		public static const BGM_SUNNYNITE : String = "bgm_SunnyNite";
		public static const BGM_SNOWDAY : String = "bgm_SnowyDay";
		public static const BGM_SNOWNITE : String = "bgm_SnowyNite";
		
		public static var soundList : Array = ["s1","s2","s3","s4","s5","s6","s7",
							   "bgm_SunnyDay","bgm_SunnyNite","fishjump","fishin",
							   "bird","light_on","light_off","meteor","pig_land",
							   "pig_run","cloud","ice","wind","ice_creak",
							   "newcloud","smallcloud","middlecloud","sun_big","sun_small","bigcloud",
							   "snow_small", "snow_big", "tree", "owlSound", "fly2", "mailbox", "letter",
							   "vane", "signs", "xueqiu", "pig_skate", "pig_sleep", "pig_sad", "pig_happy"];
		
		[Embed(source="/assets/music/btn_click.mp3")]
        private static const BtnClickSound:Class;
		
		[Embed(source="/assets/music/start_ui.mp3")]
        private static const startUISound:Class;
		
		[Embed(source="/assets/music/glass1.mp3")]
        private static const glass1Sound:Class;
		[Embed(source="/assets/music/glass2.mp3")]
        private static const glass2Sound:Class;
		[Embed(source="/assets/music/glass3.mp3")]
        private static const glass3Sound:Class;
		[Embed(source="/assets/music/glass4.mp3")]
        private static const glass4Sound:Class;
		[Embed(source="/assets/music/glass5.mp3")]
        private static const glass5Sound:Class;
		[Embed(source="/assets/music/glass6.mp3")]
        private static const glass6Sound:Class;
		
		
		[Embed(source="/assets/music/plot0.mp3")]
        private static const plot0Sound:Class;
		[Embed(source="/assets/music/plot1.mp3")]
        private static const plot1Sound:Class;
		[Embed(source="/assets/music/plot2.mp3")]
        private static const plot2Sound:Class;
		
		[Embed(source="/assets/music/plot_en0.mp3")]
        private static const plotEn0Sound:Class;
		[Embed(source="/assets/music/plot_en1.mp3")]
        private static const plotEn1Sound:Class;
		[Embed(source="/assets/music/plot_en2.mp3")]
        private static const plotEn2Sound:Class;
		[Embed(source="/assets/music/plot_en3.mp3")]
        private static const plotEn3Sound:Class;
		
		//logo声音
		[Embed(source="/assets/music/logo.mp3")]
        private static const logoSound:Class;
		public function SoundAsset()
		{
			
		}
	}
}