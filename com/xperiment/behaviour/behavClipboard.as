package com.xperiment.behaviour {
	import com.adobe.images.PNGEncoder;
	import com.dgrigg.minimalcomps.graphics.Rect;
	import com.xperiment.uberSprite;
	import com.xperiment.trial.overExperiment;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	

	
	public class behavClipboard extends behav_baseClass{
		private var notRun:Boolean=true;
		private var bg:Sprite;
		private var tagArr:Array=new Array;
		private var counter:uint=1;
		override public function setVariables(list:XMLList):void {
		super.setVariables(list);
		
		
		
		}
				

		override public function nextStep(id:String=""):void {
			var x:int=0;
			var y:int=0;
			var width:uint=0;
			var height:uint=0;
			var myTag:Sprite;
			for each(var myObj:uberSprite in behavObjects){
				myTag=createTag();
				myTag.x=myObj.myWidth;
				myObj.addChild(myTag);	
				myTag.addEventListener(MouseEvent.CLICK,cli);
				tagArr.push(myTag);
			}
			myTag=null;

		}
		
		protected function cli(e:MouseEvent):void
		{
			var spr:Sprite=e.target.parent.parent;
			if(spr.contains(e.target.parent))spr.removeChild(e.target.parent);
			
			var bitmapData:BitmapData=new BitmapData(spr.width/spr.scaleX, spr.height/spr.scaleY);
			bitmapData.draw(spr);  
			//
			var byteArray:ByteArray = PNGEncoder.encode(bitmapData);			
			var fileReference:FileReference=new FileReference();
			fileReference.save(byteArray, "image"+(counter)+".png");      
			counter++;
			spr.addChild(e.target.parent);
		}
		
		private function createTag():Sprite{
			var spr:Sprite = new Sprite;
			var txt:TextField = new TextField;
			txt.autoSize=TextFieldAutoSize.CENTER; 
			txt.text="save";
			txt.alpha=.5;
			txt.selectable=false;
			spr.addChild(txt);
			spr.buttonMode=true;
			spr.useHandCursor=true;
			txt.x=spr.width-txt.width;
			return spr;
		}


		override public function kill():void {
			for (var i:uint=0;i<tagArr.length;i++){
				if(tagArr[i].hasEventListener(MouseEvent.CLICK))tagArr[i].removeEventListener(MouseEvent.CLICK,cli);

			}
		super.kill();
		}
	}
}