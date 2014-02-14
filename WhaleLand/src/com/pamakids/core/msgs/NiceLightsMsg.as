package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class NiceLightsMsg extends MsgBase
	{
		//0 : 关灯 1 : 开灯
		public var data : int = 0;
		public function NiceLightsMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN
			];
		}
	}
}