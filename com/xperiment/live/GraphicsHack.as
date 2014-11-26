package com.xperiment.live
{
	import com.dgrigg.minimalcomps.graphics.Shape;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.xperiment.trial.Trial;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	

	
	public class GraphicsHack extends Sprite
	{
		
		private var trials:Array = [];
		
		
		public function GraphicsHack(theStage:Stage)
		{
			super();
			this.graphics.beginFill(0x33,1);
			this.graphics.drawRect(0,0,Trial.RETURN_STAGE_WIDTH,Trial.RETURN_STAGE_HEIGHT*.5);
			this.y=Trial.RETURN_STAGE_HEIGHT*.5;
			theStage.addChild(this);
			
			for(var i:int=0;i<5;i++){
				trials[i] = new Shape;
				trials[i].graphics.beginFill(0xFFFFFF*Math.random(),1);
				trials[i].graphics.drawRect(i*this.width*.2,0,Trial.RETURN_STAGE_WIDTH*.2,Trial.RETURN_STAGE_HEIGHT*.5);
				this.addChild(trials[i]);
			}
			//addAns("yes",1);
		}
		
		private function addAns(ans:String, trial:int):void
		{
			var txt:TextField = new TextField();
			txt.autoSize= TextFieldAutoSize.LEFT;
			txt.defaultTextFormat = new TextFormat(null,60,0xFFFFFF*Math.random());
			txt.text=ans;
			
			txt.scaleX = txt.scaleY = 0;
			txt.x=trial*this.width*.2;
			txt.y=Trial.RETURN_STAGE_HEIGHT*.5/5*(trials[trial].numChildren);
			trials[trial].addChild(txt);
			
			TweenMax.to(txt, 1, {scaleX:1.5,scaleY:1.5, x:"-txt.width*.25",ease:Back.easeInOut, repeat:0, yoyo:true});
		}
		
		public function ping(sj:String, result:XML):void{
			
			var ans:String = "no";
			if(result.b1.toString()=="1")ans="yes";
			
			addAns(ans,int(result.trialOrder))
		
	
		}
		
		
	}
}