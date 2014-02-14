package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class LoadIsLandMsg extends MsgBase
	{
		public function LoadIsLandMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN
			];
		}
	}
}