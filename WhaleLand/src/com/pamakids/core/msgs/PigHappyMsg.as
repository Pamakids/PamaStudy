package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class PigHappyMsg extends MsgBase
	{
		public function PigHappyMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN
			];
		}
	}
}