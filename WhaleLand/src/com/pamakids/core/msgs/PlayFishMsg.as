package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class PlayFishMsg extends MsgBase
	{
		public var posX : Number = 0;
		public var posY : Number = 0;
		public function PlayFishMsg()
		{
			super();
			plugins = [
				PluginsID.MARINE_PLUGIN
			];
		}
	}
}