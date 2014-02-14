package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;
	
	import flash.geom.Point;

	public class PlayLighting extends MsgBase
	{
		public var pos : Point = new Point();
		public function PlayLighting()
		{
			super();
			plugins = [
				PluginsID.SKY_PLUGIN
			];
		}
	}
}