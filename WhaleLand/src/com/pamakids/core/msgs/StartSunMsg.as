package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class StartSunMsg extends MsgBase
	{
		public var data : *;
		public function StartSunMsg()
		{
			super();
			plugins = [
				PluginsID.SKY_PLUGIN,
				PluginsID.LAND_PLUGIN,
				PluginsID.MARINE_PLUGIN
			];
		}
	}
}