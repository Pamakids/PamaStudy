package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class SnowSateMsg extends MsgBase
	{
		public var data : *;
		public function SnowSateMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN,
				PluginsID.SKY_PLUGIN
			];
		}
	}
}