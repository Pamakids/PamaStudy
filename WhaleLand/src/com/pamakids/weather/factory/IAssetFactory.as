package com.pamakids.weather.factory
{
	import starling.textures.Texture;
	public interface IAssetFactory
	{
		function init():void;
		function addTextureAtlas(name : String, texture : Texture, atlasXml : XML):void;
		function getTexture(name : String):Texture;
		function getTextures(name : String):Vector.<Texture>;
	}
}