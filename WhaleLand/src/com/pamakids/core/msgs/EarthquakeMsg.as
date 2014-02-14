package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;
	public class EarthquakeMsg extends MsgBase
	{
		public var data : int;
		public var oldTime : int;
		public var curTime : int;
		public function EarthquakeMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN
			];
		}
	}
}