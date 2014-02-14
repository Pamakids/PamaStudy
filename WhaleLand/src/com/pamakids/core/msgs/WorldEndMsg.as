package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;
	public class WorldEndMsg extends MsgBase
	{
		public function WorldEndMsg()
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