package com.xperiment.stimuli.primitives {


	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.uberSprite;
	import com.xperiment.script.ProcessScript;
	import flash.events.MouseEvent;
	import com.xperiment.stimuli.primitives.ContentScroller;
	import com.xperiment.stimuli.addText;

	public class textScroll extends Sprite {
		private var combined:Sprite;
		private var scroll:ContentScroller;
		private var content:Sprite;
		private var container:Sprite;
		private var myTxt:addText;
		private var info:Object;

		public function textScroll(obj:Object) {
			info=obj;
			if(!info.buttonColour)info.buttonColour=0x626262
			if(!info.buttonLineColour)info.buttonLineColour=0x422f54
			if(!info.buttonLineThickness)info.buttonLineThickness=1
			if(!info.textSize)info.textSize=16
			if(!info.textColour)info.textColour=0xFFFFFF
			if(info.wantBox==null)info.wantBox=true;
			if(info.sizer==null)info.sizer=true;
			if(info.moveBar==null)info.moveBar=true;
			if(info.width==null)info.width=200;
			if(info.height==null)info.height=200;
			sortConsole();
		}

		public function sortConsole():void {
			container=new Sprite  ;
			var obj:Object=new Object  ;
			obj.autoSize="left";
			combined=new Sprite  ;
			//logger.addEventListener("logPing", updateWindow);
			obj.text=processText(info.txt);
			obj.selectable=true as Boolean;
			obj.width=info.width;
			obj.height=info.width;
			obj.textSize=12;
			obj.colour=0;
			myTxt=new addText  ;
			container=myTxt.giveBasicStimulus(obj);
			addChild(container);
			obj=new Object;
			obj.content=container; 
			obj.maskWidth=200;
			obj.maskHeight=info.height;
			obj.wantBox=info.wantBox;
			obj.moveToBottom=true;
			obj.sizer=info.sizer;
			obj.mover=info.moveBar;
			obj.background=info.background;
			scroll=new ContentScroller(obj);
			scroll.x=this.width*.8;
			scroll.y=this.height*.7;
			addChild(scroll);
			
		}

		public function updateWindow(str:String):void {
			myTxt.myText.appendText(processText("\n"+str));
			scroll.toBottom();
		}

		private function processText(txt:String):String {
			var myPattern:RegExp=/Problem/g;
			txt=txt.replace(myPattern,"<FONT COLOR='#FF0000' SIZE='15'><B>PROBLEM</B></FONT>");
			return txt;
		}



		public function kill():void {

			if (this.contains(combined)) {
				this.removeChild(combined);
			}

			if (scroll) {
				scroll.kill(),scroll=null;
			}
		}


	}
}