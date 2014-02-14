package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class SnowEndMsg extends MsgBase
	{
		public function SnowEndMsg()
		{
			super();
			plugins = [
				PluginsID.SKY_PLUGIN,
				PluginsID.LAND_PLUGIN
			];
		}
	}
}