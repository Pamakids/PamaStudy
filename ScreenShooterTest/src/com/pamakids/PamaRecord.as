package com.pamakids
{
	public class PamaRecord
	{
		/**
		 * 单个录像配置
		 *
		 * 包括
		 *
		 * 路径/时间
		 *
		 * 屏幕截屏的数组
		 * 摄像头截屏的数组
		 * 音频文件
		 *
		 * 均按时间 排序
		 * */
		public function PamaRecord()
		{
		}

		public var path:String="";

		public var shots:Array=[];
		public var cameras:Array=[];
		public var mic:String;

		public static function copy(o:Object):PamaRecord
		{
			var record:PamaRecord=new PamaRecord();
			record.path=o["path"];
			record.shots=o["shots"];
			record.cameras=o["cameras"];
			record.mic=o["mic"];
			return record;
		}
	}
}

