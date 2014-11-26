package com.xperiment.behaviour {
	import com.adobe.images.PNGEncoder;
	import com.xperiment.uberSprite;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	
	
	
	public class behavSaveImage extends behav_baseClass{
		private var bg:Sprite;
		private var counter:uint=1;
		
		override public function setVariables(list:XMLList):void {
			
			setVar("boolean","hideFrame",false);
			setVar("string","useAsFrame",'','use a single object peg here or screen');
			super.setVariables(list);
			
		}
		
		override public function RunMe():uberSprite{
			if(getVar("useAsFrame")=="")throw new Error("SaveImageError: you must specify what to use as the frame (e.g. screen, or an object's peg)");
			return super.RunMe();
		}
		
		
		override public function nextStep(id:String=""):void{
			//save();
		}
		
		
		
		override public function myUniqueActions(action:String):Function{
			if(!uniqueActions){
				uniqueActions = new Dictionary;
				uniqueActions.save=function():void{save();};
			}
			if(uniqueActions.hasOwnProperty(action)) {
				return uniqueActions[action]
			}
			
			return null;
		}
		
		
		public function save():void{
	
			var frame:DisplayObject;
				for(var i:int=0;i<behavObjects.length;i++){
					if((behavObjects[i] as uberSprite).peg==getVar("useAsFrame")){
						frame = behavObjects[i];
						break;
					}
				}
				
			if(getVar("useAsFrame").toLowerCase()=="screen"){
				
				frame = new Sprite;
				(frame as Sprite).graphics.beginFill(0,0);
				(frame as Sprite).graphics.drawRect(0,0,theStage.width,theStage.height);
			}
				
			if(!frame) throw new Error("SaveImageError: you have specified an unknown object to use as the frame: "+getVar("useAsFrame"));
		
			
			if(getVar("hideFrame") as Boolean)frame.visible=false;
			var bitmapdata:BitmapData = new BitmapData(theStage.stageWidth, theStage.stageHeight);
			bitmapdata.draw(theStage);
			var bitmapDataA: BitmapData = new BitmapData(frame.width, frame.height);
			bitmapDataA.copyPixels(bitmapdata, new Rectangle(frame.x, frame.y, frame.width, frame.height), new Point(0, 0));
			var byteArray:ByteArray = PNGEncoder.encode(bitmapDataA);
			frame.visible=true;

			
			var fileReference:FileReference=new FileReference();
			fileReference.save(byteArray, "image"+(counter)+".png");
			
			frame=null;
			
		}
	}
}