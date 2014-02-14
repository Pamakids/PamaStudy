package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;
	public class LightIconMsg extends MsgBase
	{
		public function LightIconMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN
			];
		}
	}
}