package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class StartUIMsg extends MsgBase
	{
		public function StartUIMsg()
		{
			super();
			plugins = [
				PluginsID.UI_PLUGIN
			];
		}
	}
}