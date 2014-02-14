package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class DelAllMsg extends MsgBase
	{
		public function DelAllMsg()
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