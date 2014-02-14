package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class LoadPigMsg extends MsgBase
	{
		public function LoadPigMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN
			];
		}
	}
}