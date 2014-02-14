package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;
	public class OpenMailMsg extends MsgBase
	{
		public function OpenMailMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN
			];
		}
	}
}