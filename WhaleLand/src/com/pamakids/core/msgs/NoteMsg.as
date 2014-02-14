package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;

	public class NoteMsg extends MsgBase
	{
		public function NoteMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN
			];
		}
	}
}