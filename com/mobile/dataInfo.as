package com.mobile{
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import com.xperiment.stimuli.addText;


	public class dataInfo extends Sprite {
		private var folder:File;
		private var file:File;
		private var files:Array;
		private var fileStream:FileStream;
		private var size:uint=0;
		private var storageLocation:String;
		private var spr:Sprite;
		private var myTxt:addText;

		public function dataInfo(f:String) {
			folder=File.applicationStorageDirectory.resolvePath(f);
			storageLocation=folder.nativePath;
			createText(composeText());
		}

		public function composeText():String {
			var f1:String="";
			var f2:String="";
			var txt:String;
			if (folder.exists) {
				files=folder.getDirectoryListing();
				size=GetFolderSize(files);
				txt="<FONT COLOR='#AFAFAF'><b>Participant data</b>\n";
				if (files.length>0) {
					txt+="how many \t\t"+files.length+"\n";
					txt+="average size     \t"+size/files.length/1000+"k\n";
					txt+="total data      \t\t"+size/1000+"k\n";
					txt+="1st SJ date \t"+files[0].creationDate.toLocaleString()+"\n";
					txt+="last SJ date \t"+files[files.length-1].creationDate.toLocaleString()+"\n</B></FONT>";
				}
				else txt+="no data stored</B></FONT>";
			}
			else {
				txt="directory does not exist";

			}
			return txt;
		}

		public function updateTxt():void {
			composeText();
			myTxt.myText.htmlText=composeText();
		}

		public function createText(str:String):void {
			var obj:Object=new Object  ;
			obj.autoSize="left";
			obj.text=str;
			obj.textSize=15;
			obj.colour=0x000000;
			obj.background=0xFFFFFF;
			myTxt=new addText  ;
			spr=myTxt.giveBasicStimulus(obj);
			this.addChild(spr);
		}

		public function GetFolderSize(Source:Array):Number {
			var TotalSizeInteger:Number = new Number();
			for (var i:int = 0; i<Source.length; i++) {

				TotalSizeInteger+=Source[i].size;

			}
			return TotalSizeInteger;
		}


		public function kill():void {
			spr=null;
		}

	}

}