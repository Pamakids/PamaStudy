package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	/**
	 * 太阳坐标变化
	 */
	public class SunMsg extends MsgBase
	{
		public var data : *;
		public function SunMsg()
		{
			super();
			plugins = [
				PluginsID.SKY_PLUGIN
			];
		}
	}
}