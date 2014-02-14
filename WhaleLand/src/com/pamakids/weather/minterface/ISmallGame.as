package com.pamakids.weather.minterface
{
	public interface ISmallGame
	{
		function start():void;
		function update():void;
		function pause():void;
		function exit():void;
		function getScore():Number;
		function getGold():Number;
	}
}