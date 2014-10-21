package com.xperiment.P2P.components
{
	import com.projectcocoon.p2p.vo.ObjectMetadataVO;
	
	import flash.utils.Dictionary;

	public class P2P_files_DEL
	{
		private static var fileDict:Dictionary;
		public static var FILELIST:String = "fileList";
		
		public static function setFileList(list:Array):void
		{
			if (!fileDict) throw new Error("devel error"); //fileList should be instantiated once 
			else {
				for(var i:int=0;i<list.length;i++){
					fileDict[list[i]]=false;
				}
			}
		}
		
		private static function countUnloaded():int{
			var count:int=0;
			for(var key:String in fileDict){
				if(fileDict[key]==false)count++;
			}
			return count;
			
		}
		
		public static function init():void
		{
			fileDict ||=new Dictionary;
		}
		
		public static function giveFile(metadata:ObjectMetadataVO):Boolean
		{
			var fileUrl:String = String(metadata.info);
		//	trace(fileUrl,metadata.object,44)
			
			if(fileDict.hasOwnProperty(fileUrl))fileDict[fileUrl]=true;
			
			if(countUnloaded()==0){
				return true;
			}
			return false;
			
		}
		
		public static function hasFile(metadata:ObjectMetadataVO):Boolean{
			//trace(111,String(metadata.info));
			return fileDict.hasOwnProperty(String(metadata.info));
		}
	}
}