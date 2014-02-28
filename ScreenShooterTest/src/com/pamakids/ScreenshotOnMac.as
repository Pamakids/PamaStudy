package com.pamakids
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;

	public class ScreenshotOnMac
	{
		public function ScreenshotOnMac()
		{
			setupAndLaunch();
		}

		public var process:NativeProcess;
		private var shell:File;

		public function setupAndLaunch():void
		{     
			shell = File.applicationDirectory.resolvePath("/usr/sbin/screencapture");
		}

		public function start(savePath:String):void
		{
			if(Capabilities.os.toLowerCase().indexOf("mac") > -1)
			{
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				nativeProcessStartupInfo.executable = shell;
				var processArgs:Vector.<String> = new Vector.<String>();
				processArgs[0] = '-mx';
				processArgs[1] = savePath;
				nativeProcessStartupInfo.arguments = processArgs;
				process = new NativeProcess();
				process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
				process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
				process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
				process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
				process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
				process.start(nativeProcessStartupInfo);
			}
		}

		public function onOutputData(event:ProgressEvent):void
		{
			trace("Got: ", process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)); 
		}

		public function onErrorData(event:ProgressEvent):void
		{
			trace("ERROR -", process.standardError.readUTFBytes(process.standardError.bytesAvailable)); 
		}

		public function onExit(event:NativeProcessExitEvent):void
		{
			trace("Process exited with ", event.exitCode);
		}

		public function onIOError(event:IOErrorEvent):void
		{
			trace(event.toString());
		}
	}
}

