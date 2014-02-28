package com.pamakids
{
	import com.pamakids.manager.FileManager;

	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class UploadUtils extends EventDispatcher
	{
		public static const UPLOAD_SUCCESS:String="UPLOADSUCCSESS";
		public static const UPLOAD_FAILED:String="UPLOADFAILED";

		public static var username:String;
		public function UploadUtils()
		{
		}

		public var totalUpfile:int=0;

		public function uploadRecords(o:Object):void
		{
			var record:PamaRecord=PamaRecord.copy(o);
			var arr:Array=SO.data["arr"];
			for each (var shot:String in record.shots) 
			{
				if(arr.indexOf(shot)==-1){
					uploadFile(record.path+shot);
				}
			}

			for each (var cam:String in record.cameras) 
			{
				if(arr.indexOf(cam)==-1){
					uploadFile(record.path+cam);
				}
			}

			if(arr.indexOf(record.mic)==-1)
				uploadFile(record.path+record.mic);
		}

		public function uploadFile(name:String):void{
			totalUpfile++;
			var f:File=File.applicationStorageDirectory.resolvePath(name);
			if(!f.exists)
				return;
			var u:URLRequest=new URLRequest('http://up.qiniu.com'); 
			u.method=URLRequestMethod.POST;
			u.requestHeaders=[new URLRequestHeader('enctype', 'multipart/form-data')];
			var ur:URLVariables=new URLVariables();

			ur.key=username+"/"+name;
			ur.token="-S31BNj77Ilqwk5IN85PIBoGg8qlbkqwULiraG0x:NdeCF0RrZDVBxBYvOlTRWzdLH5I=:eyJzY29wZSI6InVzZXJ0ZXN0IiwiZGVhZGxpbmUiOjE3NTI2OTM1MDh9"; //Only this is required
			ur['x:param'] = 'Your custom param and value';

			u.data=ur;

			f.upload(u, 'file');  //File or FileReference is both OK, but UploadDataFieldName must be 'file'
			f.addEventListener(ProgressEvent.PROGRESS,onProgress);
			f.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadedHandler);
			f.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}

		protected function onIOError(event:IOErrorEvent):void
		{
			var f:File=event.currentTarget as File;
			f.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			f.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadedHandler);
			f.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);

			dispatchEvent(new Event(UPLOAD_FAILED));
		}

		protected function uploadedHandler(event:DataEvent):void
		{
			var f:File=event.currentTarget as File;
			f.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			f.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadedHandler);
			f.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);

			confirmFile(f.name);
			totalUpfile--;
			dispatchEvent(new Event(UPLOAD_SUCCESS));
		}

		public var index:int;

		protected function onProgress(event:ProgressEvent):void
		{

		}

		public static function uploadConfig(name:String):void{
			var f:File=File.applicationStorageDirectory.resolvePath(name);
			if(!f.exists)
				return;
			var u:URLRequest=new URLRequest('http://up.qiniu.com'); 
			u.method=URLRequestMethod.POST;
			u.requestHeaders=[new URLRequestHeader('enctype', 'multipart/form-data')];
			var ur:URLVariables=new URLVariables();

			var configName:String="config"+new Date().getTime()+".json";
			ur.key=username+"/"+configName;
			ur.token="-S31BNj77Ilqwk5IN85PIBoGg8qlbkqwULiraG0x:NdeCF0RrZDVBxBYvOlTRWzdLH5I=:eyJzY29wZSI6InVzZXJ0ZXN0IiwiZGVhZGxpbmUiOjE3NTI2OTM1MDh9"; //Only this is required
			ur['x:param'] = 'Your custom param and value';

			u.data=ur;
			f.upload(u, 'file');

			var u2:URLRequest=new URLRequest("http://sb.pamakids.com:9050/ut/update?u="+username+"&c="+configName);
			u2.method=URLRequestMethod.GET;
			new URLLoader(u2);
		}

		public static function checkUploaded(o:Object):String
		{
			var record:PamaRecord=PamaRecord.copy(o);

			var total:int=record.shots.length+record.cameras.length+1;
			var count:int=0;
			var arr:Array=SO.data["arr"];

			for each (var shot:String in record.shots) 
			{
				if(arr.indexOf(shot)>=0)
					count++;
			}

			for each (var cam:String in record.cameras) 
			{
				if(arr.indexOf(cam)>=0)
					count++;
			}

			if(arr.indexOf(record.mic)>=0)
				count++;

			if(count==total)
				return "上传已完成";
			else
				return count+"/"+total+"  已上传";
		}

		public static function checkFile(_name:String):Boolean{
			var arr:Array=SO.data["arr"];
			return arr.indexOf(_name)>=0;
		}

		public static function confirmFile(_name:String):void{
			if(!checkFile(_name)){
				SO.data["arr"].push(_name);
				SO.flush();
			}
		}

		public static function get SO():SharedObject{
			var so:SharedObject=SharedObject.getLocal("uploaded");
			if(!so.data["arr"])
			{
				so.data["arr"]=[];
				so.flush();
			}
			return so;
		}
	}
}

