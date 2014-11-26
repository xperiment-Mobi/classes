package  com.xperiment.behaviour{

	import com.xperiment.uberSprite;
	import com.xperiment.behaviour.components.Selector;
	import com.xperiment.trial.Trial;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Mouse;



	public class behavColourSelector extends behav_stim_hybrid {

		private var myShape:Shape;
		private var box:DisplayObject;
		private var colours:DisplayObject
		private var selector:Selector;
		private var point:Point = new Point;
		private var shaderBar:Sprite;
		private var selectedBar:Shape;
		private var matrix:Matrix;
		private var selected:Boolean;
		private var colour:uint;
		private var barHeight:Number;
		
		
		override public function kill():void{
			selector.removeEventListener(MouseEvent.CLICK,mouseClick);
			theStage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			if(theStage.hasEventListener(Event.EXIT_FRAME))theStage.removeEventListener(Event.EXIT_FRAME,newFrame);

			
			//giveCols(false);
			theStage.removeChild(selector);
			pic.removeChild(shaderBar);
			pic.removeChild(selectedBar);
			shaderBar=null;
			selector.kill();
			selector=null;
		}
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		override public function storedData():Array
		{			
			var myColour:String;
			if(!colour)myColour='';
			else myColour = colour.toString();
			
			super.objectData.push({event:peg,data:myColour});
			return objectData;
		}
		
		override public function RunMe():uberSprite {	
			super.RunMe();
			super.setUniversalVariables();					
			return pic;//note empty as nothing on stage :)
		}
		
		override public function nextStep(id:String=""):void{
			
			
			
			box = getStim("box");
			colours = getStim("sampleFrom");
			
			if(!colours)colours = theStage;
			if(!box)box 		= theStage;
			
			initBars();
			initSelector();
			
			selector.addEventListener(MouseEvent.CLICK,mouseClick);
			theStage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
			
		}
		
		/*override public function myUniqueProps(prop:String):Function{
			if(!uniqueProps){
				uniqueProps=new Dictionary;
				uniqueProps.colour= function(what:String=null,to:String=null):String{
								//AW Note that text is NOT set if what and to and null. 
								if(what && to!="'0'") {
									
									
								}
								return codeRecycleFunctions.addQuots(getVar("colour"));
							}; 	
			}
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			
			return null;
		}*/
		

		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList):void {
			
			setVar("string","box","","the stimulus you want to change the colour off after selecting a colour");
			setVar("string","sampleFrom","", "the stimulus you want to use to get colours from (if left blank, it is assumed colours can be selected from anything");
			setVar("int","selectorSize",3,"selector size as a percentage of screen width")
			
			super.setVariables(list);
		}

		private function initBars():void
		{
			
			barHeight = box.height*.2;
			
			shaderBar = new Sprite;
			colourise_shaderBar(0x000000);
			
			pic.addChild(shaderBar);
			shaderBar.x=box.x;
			shaderBar.y=box.y+box.height;
			
			selectedBar = new Shape;
			colourise_selectedBar(-1);

			pic.addChild(selectedBar);
			selectedBar.y=shaderBar.y;
			selectedBar.x=shaderBar.x+shaderBar.width;
		}		
		

		
		private function colourise_selectedBar(col:int):void{
			var alpha:int = 1;
			if(col==-1){
				alpha=0;
				selectedBar.graphics.lineStyle(2,0,.7);
			}
			else{
				selectedBar.graphics.lineStyle(0);
			}
			selectedBar.graphics.beginFill(col,alpha); 
			selectedBar.graphics.drawRect(0,0,barHeight,barHeight);
		}
		
		private function colourise_shaderBar(col:uint):void{
			shaderBar.graphics.clear();
			matrix = new Matrix();
			matrix.createGradientBox(box.width-barHeight, barHeight,0,25,0);
			
			shaderBar.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, col, 0x000000],[1,1,1],[0,50,200],matrix); 
			shaderBar.graphics.drawRect(0,0,box.width - barHeight, barHeight);
	
		}


		private function initSelector():void
		{
			selector = new Selector();
			selector.width = selector.height = Trial.RETURN_STAGE_WIDTH * getVar("selectorSize") * .01;
			selector.x=box.x;
			selector.y=box.y;
			theStage.addChild(selector);
		}

		protected function mouseClick(e:MouseEvent):void
		{
			if(box.hitTestPoint(point.x,point.y)){
				colourise_shaderBar(colour);
			}			colourise_selectedBar(colour);
			behaviourFinished();
		}		
		
	

	
		
		protected function mouseMove(e:MouseEvent):void
		{
			
			if(box.hitTestPoint(mouseX,mouseY) || shaderBar.hitTestPoint(mouseX,mouseY)  ){
				if(!theStage.hasEventListener(Event.EXIT_FRAME)){	
					theStage.addEventListener(Event.EXIT_FRAME,newFrame);
					Mouse.hide();
					selector.startDrag(true);	
					updateCol();
				}
			}
			else{
				theStage.removeEventListener(Event.EXIT_FRAME,newFrame);
				selector.stopDrag();
				Mouse.show();
			}
		}

		
		protected function newFrame(event:Event):void
		{
			updateCol();
		}
		
		private function updateCol():void{
			
			point.x=selector.x+selector.width*.5;
			point.y=selector.y+selector.height*.5;
			
			if(box.hitTestPoint(point.x,point.y) || shaderBar.hitTestPoint(point.x,point.y)){
				var bmd:BitmapData = new BitmapData(1, 1);
				var matrix:Matrix = new Matrix();
				matrix.translate(-point.x, -point.y);
				selector.visible=false;
				bmd.draw(stage, matrix);
				colour=bmd.getPixel(0, 0);
				selector.colour(colour);
				selector.visible=true;
			}
		}
		


		
	}
}