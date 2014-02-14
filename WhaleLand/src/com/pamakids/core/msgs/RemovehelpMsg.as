package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;
	public class RemovehelpMsg extends MsgBase
	{
		public function RemovehelpMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN,
			];
		}
	}
}