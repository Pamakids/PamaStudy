package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class LoadMarineMsg extends MsgBase
	{
		public function LoadMarineMsg()
		{
			super();
			plugins = [
				PluginsID.MARINE_PLUGIN
			];
		}
	}
}