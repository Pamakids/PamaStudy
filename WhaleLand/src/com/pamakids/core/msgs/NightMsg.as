package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class NightMsg extends MsgBase
	{
		public function NightMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN,
				PluginsID.SKY_PLUGIN,
				PluginsID.MARINE_PLUGIN
			];
		}
	}
}