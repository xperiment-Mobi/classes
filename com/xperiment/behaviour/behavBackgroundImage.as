package com.xperiment.behaviour
{
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addJPG;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;


	public class behavBackgroundImage extends behav_baseClass
	{
		private var bg:addJPG;
		private var bdata:BitmapData;
		private var shiftX:Number;
		private var shiftY:Number;
		private var jpgHasLoaded:Vector.<addJPG> = new Vector.<addJPG>;
		private var started:Boolean = false;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","background","");
			super.setVariables(list);
	
			
			shiftX =(100- Number(getVar("x").split("%")[0]))*.01;
			shiftY = (100-Number(getVar("y").split("%")[0]))*.01;
		}
		
		override public function givenObjects(obj:uberSprite):void{

			if(obj.peg==getVar("background")){
				if(obj is addJPG)	bg = obj as addJPG;
				else 				throw new Error("the background you specify to use when using BackgroundImage must be an image: "+peg);
			}	
			else {
				if(obj is addJPG)	super.givenObjects(obj);
				else 				throw new Error("an image you specify to use when using BackgroundImage must be an image: "+peg);	
			}

			obj.addEventListener(Event.COMPLETE,loadedL);
		}
		
		override public function nextStep(id:String=""):void{
			if(getVar("background")=="")throw new Error("you must specify the background to use when using BackgroundImage");
			started=true;
			if(bdata)	commence();
		}
		
		private function commence():void{
			while(jpgHasLoaded.length>0){
				addBG(jpgHasLoaded.shift());
			}
		}

		protected function loadedL(e:Event):void
		{
			var jpg:addJPG = e.currentTarget as addJPG;

			if(jpg.peg == getVar("background")){
				bdata = new BitmapData(jpg.pic.myWidth,jpg.pic.myHeight,true,0x0);
				bdata.draw(jpg);
				if(started)	commence();
			}
			else{
				if(started && bg){
					addBG(jpg);
				}
				else{

					jpgHasLoaded.push(jpg);
				}
			}
		}
		
		private function addBG(stim:uberSprite):void
		{
			var bmp:Bitmap = new Bitmap(bdata);
			

			var finalShiftX:Number= stim.myWidth*shiftX-bmp.width*.5;
			var finalShiftY:Number=stim.myHeight*shiftY-bmp.height*.5;
			
			var kind:DisplayObject;
			var tempKindArr:Array=[];
			for(var i:int=0;i<stim.numChildren;i++){
				kind = stim.getChildAt(i)
				tempKindArr.push(kind);
				stim.removeChild(kind);
			}
			stim.x+=finalShiftX;
			stim.y+=finalShiftY;
			stim.addChild(bmp);
			
			for(i=tempKindArr.length-1;i>=0;i--){
				kind = tempKindArr.pop();
				stim.addChild(kind);
				kind.x=-finalShiftX;
				kind.y=-finalShiftY;
			}
			tempKindArr=null;
			
			stim.myWidth=stim.width;
			stim.myHeight=stim.height;
		}	
		
		override public function kill():void{
			bg.removeEventListener(Event.COMPLETE,loadedL);
			super.kill();
		}
		
		
	}
}

