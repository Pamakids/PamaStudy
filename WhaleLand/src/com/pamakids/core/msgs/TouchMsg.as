package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class TouchMsg extends MsgBase
	{
		public var targetName  :String;
		public var type : String;
		public function TouchMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN,
			];
		}
	}
}