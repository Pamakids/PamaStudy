package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class SunEnergyMsg extends MsgBase
	{
		public function SunEnergyMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN,
				PluginsID.SKY_PLUGIN
			];
		}
	}
}