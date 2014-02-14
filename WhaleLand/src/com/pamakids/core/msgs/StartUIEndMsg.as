package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class StartUIEndMsg extends MsgBase
	{
		public function StartUIEndMsg()
		{
			super();
			plugins = [
				PluginsID.UI_PLUGIN
			];
		}
	}
}