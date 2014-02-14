package com.pamakids.weather.items
{
	public interface IItem
	{
		function init():void;
		function update(data : *):void;
		function destroy():void;
	}
}