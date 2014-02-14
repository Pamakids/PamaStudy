package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	/**
	 * (点击小鸟,鱼)提醒小猪注意的消息
	 * */
	public class RemindPigMsg extends MsgBase
	{
		public function RemindPigMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN,
			];
		}
	}
}