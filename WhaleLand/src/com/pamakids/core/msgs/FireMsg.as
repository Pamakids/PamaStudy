package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class FireMsg extends MsgBase
	{
		public function FireMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN,
			];
		}
	}
}