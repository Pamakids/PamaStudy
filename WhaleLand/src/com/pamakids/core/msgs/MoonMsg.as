package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class MoonMsg extends MsgBase
	{
		public var data : *;
		public function MoonMsg()
		{
			super();
			plugins = [
				PluginsID.SKY_PLUGIN
			];
		}
	}
}