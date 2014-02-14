package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class SnowMsg extends MsgBase
	{
		public var data : * ;
		public function SnowMsg()
		{
			super();
			plugins = [
				PluginsID.SKY_PLUGIN,
				PluginsID.LAND_PLUGIN
			];
		}
	}
}