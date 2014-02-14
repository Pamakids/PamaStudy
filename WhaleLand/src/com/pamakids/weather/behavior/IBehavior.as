package com.pamakids.weather.behavior
{
	import starling.display.DisplayObject;
	
	/**
	 * 行为接口
	 * @author icekiller
	 */
	public interface IBehavior 
	{
		function register(target : DisplayObject):void;
		function destroy():void;
	}
	
}