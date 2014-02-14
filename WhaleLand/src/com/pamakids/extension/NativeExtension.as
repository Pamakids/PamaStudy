package com.pamakids.extension
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	
	public class NativeExtension extends EventDispatcher
	{
		private static var inst:NativeExtension;
		private var ctx:*;
		
		public function NativeExtension()
		{
			super();
			try {
				var className:Class = getDefinitionByName("flash.external.ExtensionContext") as Class;
				if(className){
					ctx = className["createExtensionContext"]("com.pamakids.extension","");
				}else{
					throw("flash.external.ExtensionContext init failure");
				}
			}catch(e:Error){
				trace("NativeExtension init failure!");
			}
		}
		
		
		public static function get manager():NativeExtension{
			if(!(inst is NativeExtension)){
				inst = new NativeExtension();
			}
			return inst;
		}
		
		public function startMicropho():Boolean{
			if(ctx){
				return ctx.call("initMic");
			}else{
				trace("Can't init native microphone because NativeExtension was not initialized!");
			}
			return false;
		}
		public function stopMicropho():Boolean{
			if(ctx){
				return ctx.call("removeMic");
			}else{
				trace("Can't remove native microphone because NativeExtension was not initialized!");
			}
			return false;
		}
		public function getMicActiveLevel():Number{
			if(ctx){
				return Number(ctx.call("getMicPower"));
			}else{
				trace("Can't get native microphone power because NativeExtension was not initialized!");
			}
			return -1;
		}
		public function alert(title:String, message:String):void{
			if(ctx){
				ctx.call("alert",title,message);
			}else{
				trace(title,message);
			}
		}
	}
}