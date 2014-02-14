package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class CreatNewCloudMsg extends MsgBase
	{
		public var data : Object = {};
		public function CreatNewCloudMsg()
		{
			super();
			plugins = [
				PluginsID.SKY_PLUGIN,
				PluginsID.MARINE_PLUGIN
			];
		}
	}
}