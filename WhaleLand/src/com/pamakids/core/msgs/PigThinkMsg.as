package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class PigThinkMsg extends MsgBase
	{
		public function PigThinkMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN
			];
		}
	}
}