package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class LoadSkyOtherItem extends MsgBase
	{
		public function LoadSkyOtherItem()
		{
			super();
			plugins = [
				PluginsID.SKY_PLUGIN
			];
		}
	}
}