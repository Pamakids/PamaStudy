package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class SnowStopMsg extends MsgBase
	{
		public function SnowStopMsg()
		{
			super();
			plugins = [
				PluginsID.SKY_PLUGIN,
			];
		}
	}
}