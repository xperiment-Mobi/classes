package com.xperiment.ExptWideSpecs
{		
	import flash.desktop.NativeApplication;

	public class ExptWideSpecs_LabParams
	{
		
		
		public static function SET():void{
			
			var params:Object = ExptWideSpecs._ExptWideSpecs;
			
			params.computer.app = NativeApplication.nativeApplication.applicationID;
			params.computer.dataFolderLocation = '';
			
			
		}
	}
}