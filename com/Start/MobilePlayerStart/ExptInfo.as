package com.Start.MobilePlayerStart
{
	public class ExptInfo
	{
		public var url:String;
		public var title:String;
		public var info:Object;
		public var special:String;
		public var colour:String;
		public var runnable:Boolean =true;
		public var funct:Function;
		public var button:String;
		public var input:String;
		
		public function kill():void{
			funct=null;
			info=null;
		}
		
		public function ExptInfo(params:XML)
		{
			if(params){
				this.url = 		params.url.toString();
				this.title = 	params.title.toString();
				this.info = 	params.info.toString();
			}
		}
		
		public function html():String{	
			var text:String = info.toString();
			return "<br>"+bigBold(title)+"<br><br>"+text;
		}
		
		
	    public function abbrevHTML(abbrevLength:int):String{
			var abbrevInfo:String = info.substr(0,abbrevLength-title.length);
			if(abbrevInfo.length<info.length)abbrevInfo+="...";	
			if(colour)return "<font color='"+colour+"'>"+bigBold(title)+"  "+abbrevInfo+"</font>";
			return bigBold(title)+" "+abbrevInfo+"...";
		}
		
		private function bigBold(str:String):String{
			return "<b><font size='+5'>"+str+"</font></b>";
		}
		
	
	}
}