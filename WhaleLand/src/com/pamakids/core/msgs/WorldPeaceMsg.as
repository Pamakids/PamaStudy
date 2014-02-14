package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;
	public class WorldPeaceMsg extends MsgBase
	{
		public function WorldPeaceMsg()
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