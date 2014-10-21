package com.xperiment.make.xpt_interface.Bind
{
	public class CrunchUp
	{

		public static function DO(origArr:Array):Array
		{
			var left:Array;
			var right:Array ;
			var pattern:Array;
	
			for(var i:int=1;i<origArr.length;i++){
				left=[];
				right=[]
				for(var count:int=0;count<i;count++){
					left.push(  origArr[count] );
				}
				for(    count    =i;count<origArr.length;count++){
					right.push( origArr[count] );
				}
				
				pattern = seePattern(left,right);
				if(pattern.length>0)	return pattern;
			}

			
			
			return origArr;
		}
		
		private static function seePattern(left:Array, right:Array):Array
		{
			
			var chunks:Array = [];
			__chunkify(right,chunks,left.length);
			
			for(var i:int=0;i<chunks.length;i++){
				
				if (false == testChunk(left,chunks[i])  ) return [];
				
			}

			return left;
		}
		
		private static function testChunk(left:Array, chunk:Array):Boolean
		{
			for(var i:int=0;i<chunk.length;i++){
				if(chunk[i]!=left[i])	return false;
			}
			
			return true;
		}
		
		public static function __chunkify(right:Array, chunks:Array, len:int):void
		{
			var arr:Array = [];
			
			for(var i:int=0;i<len;i++){
				if(right.length>0)	arr.push(	right.shift() 	);
			}
			chunks.push(arr);
			if(right.length>0)	__chunkify(right,chunks,len);

		}
	}
}