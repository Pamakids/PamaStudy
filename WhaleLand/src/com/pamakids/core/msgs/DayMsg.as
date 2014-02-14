package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class DayMsg extends MsgBase
	{
		public function DayMsg()
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