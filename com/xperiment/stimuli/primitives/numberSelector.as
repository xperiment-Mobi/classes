package com.xperiment.stimuli.primitives{

	import com.bit101.components.Style;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	
	public class numberSelector extends Sprite {
		private var shapes:Array;
		private var scrollNumber:TextField;
		public  var selector:Sprite;
		private var selectedNumber:uint=0;
		private var myList:Array;
		private var info:Object = new Object;
		private var xOffset:uint;
		private var mouseShape:Shape;
		private var myText:Sprite;
		private var basicText:BasicText;
		public var changed:Boolean=false;
		
		private var triangleHeight:int;
		private var boxHeight:int;
		private var boxWidth:int;
		
		private var botTriag:Sprite
		private var topTriag:Sprite;
		
		private function triangle(spr:Sprite, col:int,top:Boolean):Sprite{
			if(!spr) spr = new Sprite;

			spr.graphics.beginFill(col,1);
			spr.graphics.lineStyle(1,info.lineColour,info.lineAlpha);

			if(top){
				spr.graphics.moveTo(boxWidth*.5,0);
				spr.graphics.lineTo(boxWidth,triangleHeight);
				spr.graphics.lineTo(0,triangleHeight);
			}
			else{
				spr.graphics.moveTo(boxWidth*.5,triangleHeight*2+boxHeight);
				spr.graphics.lineTo(boxWidth,triangleHeight+boxHeight);
				spr.graphics.lineTo(0,triangleHeight+boxHeight);

			}
			return spr;
		}

		public function run(info:Object):void {
			this.info=info;
		
			myList=(info.list as String).split(",");
			
			triangleHeight = info.triangleHeight;
			boxHeight = info.textBoxHeight-2*triangleHeight;
			boxWidth = info.textBoxWidth;
			
			topTriag = 	triangle(null, info.triangleColour,true);
			botTriag = 	triangle(null, info.triangleColour,false);
			topTriag.mouseEnabled=true;
			topTriag.buttonMode=true;
			botTriag.mouseEnabled=true;
			botTriag.buttonMode=true;
			topTriag.name = "top";
			botTriag.name    = "bottom";
			triangleListeners(true);

			this.addChild(botTriag);
			this.addChild(topTriag)
			
			this.graphics.lineStyle(1,info.lineColour,info.lineAlpha);
			this.graphics.beginFill(info.textBoxColour,.1);
			this.graphics.drawRect(0,triangleHeight,boxWidth,boxHeight);
	
			

			selector = new Sprite;
			shapes = new Array;
			
			
			//the below lets one use the mouse wheel anywhere between the triangles.  Bit hacky but does the job.
			
			selector.graphics.beginFill(info.textBoxColour,1);
			selector.graphics.lineStyle(info.lineThickness,info.lineColour,info.lineAlpha);
	

			selector.buttonMode=true;
			
			if(myList.indexOf(info.startVal)!=-1)selectedNumber=info.startVal;
			
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, selected,false,0,true);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, wheel,false,0,true);
			
			mouseShape=new Shape;
			mouseShape.graphics.beginFill(0x3355FF,0);
			mouseShape.graphics.drawCircle(0,0,1);
			selector.addChild(mouseShape);
			
			this.addChild(selector);
			
			addNumber(myList[selectedNumber]);
		}
		
		private function triangleListeners(ON:Boolean):void
		{
			for each(var spr:Sprite in [topTriag,botTriag]){
			
				for each(var listen:String in [MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_UP,MouseEvent.ROLL_OUT]){
					if(ON) spr.addEventListener(listen,mouseL);
					else   spr.removeEventListener(listen,mouseL);
				}
			}
		}
		
		protected function mouseL(e:MouseEvent):void
		{
			var tri:Sprite = e.currentTarget as Sprite;
			//trace(tri.name)
			var col:int;
			switch(e.type){
				case MouseEvent.MOUSE_DOWN:
					col=Style.BUTTON_DOWN;
					break;
				case MouseEvent.MOUSE_UP:
				case MouseEvent.ROLL_OUT:
					col=Style.BUTTON_FACE;
					break;
			}
			
			triangle(tri,col,tri.name=="top")
			
		}		

		
		protected function wheel(e:MouseEvent):void
		{
			if(e.delta>0)escalateNumber(1);
			else escalateNumber(-1);
			
			
		}
		
		private function addNumber(str:String):void{
					
			if(myText==null){
				basicText=new BasicText;
				
				basicText.myWidth=boxWidth;
				basicText.myHeight=boxHeight;
				
				var params:Object = {};
				params.colour=info.fontColour;
				params.autosize=true;
				params.text=str;	
				params.selectable=false;
				params.wordWrap=false;

				scrollNumber=basicText.createTextField(params);
				
				addChild(scrollNumber);
	
				scrollNumber.x=boxWidth*.5-scrollNumber.width*.5;
				scrollNumber.y=info.textBoxHeight*.5-scrollNumber.height*.5;
				
			}

				
		}



		private function selected(e:MouseEvent):void {

			changed=true;
			if (e.localY>triangleHeight+boxHeight) {
				escalateNumber(-1);
			}
			else{
				escalateNumber(1);
			}

		}
		
		private function escalateNumber(up:int):void{
			
			if(up==-1 && selectedNumber==0)selectedNumber=myList.length-1;
			else{
				selectedNumber+=up;
				selectedNumber=selectedNumber % myList.length;
			}
			basicText.myText.text = String(myList[selectedNumber]);
		}
		
		public function giveData():uint{
			return selectedNumber;
		}
		

		public function kill():void {
			basicText.kill();
			basicText=null;
			selector.removeChild(mouseShape);mouseShape=null;
			selector.removeEventListener(MouseEvent.MOUSE_DOWN,selected);
			selector.removeEventListener(MouseEvent.MOUSE_WHEEL,wheel);
			for (var i:uint=0;i<shapes.length;i++){
				shapes[i]=null;
			}
			shapes=null;
		}
	}
}