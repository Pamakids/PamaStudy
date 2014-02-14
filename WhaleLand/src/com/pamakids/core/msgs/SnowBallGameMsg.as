package com.pamakids.core.msgs
{
	import com.pamakids.core.PluginsID;
	public class SnowBallGameMsg extends MsgBase
	{
		public var faceType : String;
		public var handType : String;
		public var collarType : String;
		
		//0 : 小雪人向大雪人游戏发送
		//1 : 大雪人向小雪人发送消息
		public var msgType : int = 0;
		public function SnowBallGameMsg()
		{
			super();
			plugins = [
				PluginsID.LAND_PLUGIN
			];
		}
	}
}