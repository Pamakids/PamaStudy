package 
{
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.ByteArray;

	import be.aboutme.airserver.AIRServer;
	import be.aboutme.airserver.endpoints.socket.SocketEndPoint;
	import be.aboutme.airserver.endpoints.socket.handlers.amf.AMFSocketClientHandlerFactory;
	import be.aboutme.airserver.events.MessageReceivedEvent;

	[SWF(backgroundColor="0x66ccff",frameRate="24")]
	public class ImagesDemoServerMobile extends Sprite
	{

		private var server:AIRServer;

		private var block:Shape;

		public function ImagesDemoServerMobile()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;

			block=new Shape();
			block.graphics.beginFill(0);
			block.graphics.drawRect(0,0,10,10);
			block.graphics.endFill();
			addChild(block);
			block.x=300;
			block.y=300;

			server = new AIRServer();
			server.addEndPoint(new SocketEndPoint(1234, new AMFSocketClientHandlerFactory()));
			server.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, messageReceivedHandler, false, 0, true);
			server.start();
		}

		protected function messageReceivedHandler(event:MessageReceivedEvent):void
		{
			switch(event.message.command)
			{
				case "CLICK":
					switch(String(event.message.data).toUpperCase())
					{
						case "UP":
						{
							block.y-=10;
							break;
						}

						case "DOWN":
						{
							block.y+=10;
							break;
						}

						case "RIGHT":
						{
							block.x+=10;
							break;
						}

						case "LEFT":
						{
							block.x-=10;
							break;
						}

						default:
						{
							break;
						}
					}
					break;
			}
		}
	}
}

