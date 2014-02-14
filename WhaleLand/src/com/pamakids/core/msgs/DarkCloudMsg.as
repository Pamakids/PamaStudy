package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class DarkCloudMsg extends MsgBase
	{
		public var data : *;
		public function DarkCloudMsg()
		{
			super();
			plugins = [
				PluginsID.SKY_PLUGIN
			];
		}
	}
}