package com.xperiment.stimuli
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.Controls.Clickable;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class addClickableJPG extends addJPG implements Imockable
	{

		public var colourDict:Dictionary;
		private var bitmapdata:BitmapData;
	
		private var XBIG:Number;
		private var YBIG:Number;
		
		private var Xp:Number;
		private var Yp:Number;
		private var cleanPixel:Array = [];
		
		
		override public function kill():void{
			
			for each(var pixel:Object in cleanPixel){
				bitmapdata.setPixel32(pixel.x,pixel.y,pixel.colour);
			}
			cleanPixel=null;
			
			bitmapdata=null;
			colourDict=null;

			pic.removeEventListener(MouseEvent.MOUSE_DOWN,clickedF);
		}
		
		override public function setVariables(list:XMLList):void {
			setVar("string","colours","","hex colours or named colours seperated by comma");
			setVar("int","radius",8);
			
			super.setVariables(list);
			Clickable.radius=getVar("radius");
			
			colourDict= new Dictionary;
			
			for each(var colour:String in getVar("colours").split(",")){
				colourDict[codeRecycleFunctions.getColour(colour)]='';
			}
		}
		
		
		override public function returnsDataQuery():Boolean{
			if(getVar("hideResults")!='true'){
				return true;
			}
			return false;
		}
		
		
		public function mock():void{
			var t:Timer = new Timer(50,0);
			t.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
				e.target.removeEventListener(e.type,arguments.callee);
				t.stop();
				
				//
			});
			t.start();
		}
		
		override public function storedData():Array {
			var tempData:Array = new Array();
			
			var clicked:Object = {}
			var clickable:Clickable;
			
			var i:int=0;
			for(var col:int in colourDict){
				i++;
			}
			
			var specifyCol:Boolean=false;
			if(i>1)specifyCol=true;
			
			for(col in colourDict){
				clicked[col]=false;
				for(i=0;i<colourDict[col].length;i++){
					clickable=colourDict[col][i];
					if(clickable.selected){
						if(specifyCol)	objectData.push({event:peg,data:i});
						else			objectData.push({event:peg+"_"+col,data:i});
						clicked[col]=true;
					}
				}
			}
			
			return objectData;
		}
		
		
		override public function __addPic(content:*):void{
			//trace(2222222,'addpic');
			super.__addPic(content);
			
			this.bitmapdata=content.bitmapData;
			
			this.XBIG = pic.width/bitmapdata.width;
			this.YBIG = pic.height/bitmapdata.height;
			
			this.Xp = content.x;
			this.Yp = content.y;
			getPixels();
			pic.addEventListener(MouseEvent.MOUSE_DOWN,clickedF);
		}
		
		
		protected function clickedF(e:MouseEvent):void
		{
			var clickable:Clickable;
			var i:int;
			for(var col:int in colourDict){
				for(i=0;i<colourDict[col].length;i++){
					clickable=colourDict[col][i];
					if(clickable.hitTestPoint(e.stageX,e.stageY)){
						sortClickedGroup(clickable, colourDict[col]);

						break;
					}
					
				}
			}
			
		}
		
		private function sortClickedGroup(clickable:Clickable, clickableV:Vector.<Clickable>):void
		{
			for each(var c:Clickable in clickableV){
				if(clickable!=c)c.selected=false;
			}

			clickable.selected=true;
			
		}		
		
		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			
		}
		
		private function getPixels():void
		{
		//	trace(2555,colourDict,colourDict==null)
			for(var col:int in colourDict){
				colourDict[col]=search(col);
			}
			
			
		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('filled')==false){
				uniqueProps.filled= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					//trace(1111,codeRecycleFunctions.addQuots(filled().toString()));
					return codeRecycleFunctions.addQuots(filled().toString());
				}; 	
			}
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		private function filled():Boolean
		{
			var i:int;
			var clickable:Clickable
			var clicked:Object = {};
			for(var col:int in colourDict){
				clicked[col]=false;
				for(i=0;i<colourDict[col].length;i++){
					clickable=colourDict[col][i];
					if(clickable.selected){
						clicked[col]=true;
					}
				}
			}
			
			for(var num:int in clicked){
				if(clicked[num]==false)return false;
			}
			return true;
		}
		
		private function search(colour:uint):Vector.<Clickable>{
			var v:Vector.<Clickable> = new Vector.<Clickable>;
			var count:int=0;
			var clickable:Clickable;
			
			for(var i:int = 0; i < bitmapdata.width; i++) {
				for(var j:int = 0; j < bitmapdata.height; j++) {
					var testPixel:uint = bitmapdata.getPixel(i,j);
					if(testPixel == colour) {
						clickable=new Clickable(count,0x000000);
						clickable.x=(i*XBIG+Xp);
						clickable.y=(j*YBIG+Yp);

						this.addChild(clickable);
						v.push(clickable);
						count++;
						
						cleanPixel.push({x:i,y:j,colour:colour})
						bitmapdata.setPixel32(i,j,bitmapdata.getPixel(i+1,j+1));
					}
				}
			} 
			
			return v;
		}
		
		
	}
}