package com.pamakids.weather.factory
{
	import com.pamakids.weather.model.GameData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	
	import flash.sampler.*;
	public class ResLoader
	{
		public var loadCom : Function;
		public var resBmdList : Vector.<BitmapData>;
		
		private var preloadList : Array = [];
		private var fileStr : String;
		private var currentlyLoading : String;
		private var loader : Loader = new Loader();
		public function ResLoader()
		{
			
		}
		
		public function init(list : Array,fileStr : String,newList : Vector.<BitmapData>):void {
			preloadList = list;
			this.fileStr = fileStr;
			resBmdList = newList;
		}
		
		public function preload():void
		{
			if (preloadList.length == 0)
			{
				if (loadCom != null) {
					resBmdList = null;
					loader.unloadAndStop();
					loader = null;
					this.loadCom();
				}
			}
			else
			{
				startLoad();
			}
		}
		
		/**
		 * 获取加载进度
		 * @return
		 */

		
		/**
		 * 获取当前加载的对象
		 */
		public function get curLoad():String {
			return currentlyLoading;
		}
		
		private function startLoad():void {
			currentlyLoading = preloadList.shift();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			if (this.fileStr == null) {
				loader.load(new URLRequest(currentlyLoading));
			}else{
				loader.load(new URLRequest(fileStr + currentlyLoading));
			}
		}
		private function onError(event:*):void {
			trace("error : " + event.toString());
		}
		
		/**
		 * Handles onLoad, saves the BitmapData then calls preload
		 */
		private function onLoad(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoad);
			resBmdList.push(Bitmap(event.target.content).bitmapData);
			GameData.curMemory += getSize(Bitmap(event.target.content).bitmapData) / 1000 / 1000;
			currentlyLoading = null;
			preload();
		}
		

	}
}