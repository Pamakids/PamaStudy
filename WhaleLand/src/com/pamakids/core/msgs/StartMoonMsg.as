package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;
	public class StartMoonMsg extends MsgBase
	{
		public var data : *;
		public function StartMoonMsg()
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