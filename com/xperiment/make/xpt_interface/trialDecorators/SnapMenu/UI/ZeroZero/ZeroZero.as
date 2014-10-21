package com.xperiment.make.xpt_interface.trialDecorators.SnapMenu.UI.ZeroZero
{
	import com.dgrigg.minimalcomps.graphics.Shape;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class ZeroZero extends Sprite
	{
		private var theStage:Stage;
		private var squares:Vector.<MakeSquare> = new Vector.<MakeSquare>;
		public var selectedSquare:MakeSquare;
		
		public var dimension:int=20;
		public var gap:int=1;
		
		public function kill():void
		{
			theStage.removeChild(this);
			
			for each(var square:MakeSquare in squares){
				square.kill();
			}
			squares=null;
			
		}
		
		public function selected(horizontal:String,vertical:String):void{
			var possibles:Array;
			var pos:int;
			switch(vertical.toLowerCase()){
				case "top":
					possibles=[0,1,2];
					break;
				case  "middle":
					possibles=[3,4,5];
					break;
				case "bottom":
					possibles=[6,7,8];
					break;
				default: throw new Error();
			}
			
			switch(vertical.toLowerCase()){
				case "left":
					pos=possibles[0];
					break;
				case  "middle":
					pos=possibles[1];
					break;
				case "right":
					pos=possibles[2];
					break;
				default: throw new Error();
			}
			
			selectedSquare = squares[pos];
			
			
		}
		
		public function ZeroZero(theStage:Stage)
		{
			this.theStage=theStage;
			var square:MakeSquare;
			
			this.theStage.addChild(this);
			
			for(var y:int=0;y<3;y++){
				for(var x:int=0;x<3;x++){
					square = new MakeSquare(x,y,dimension);
					squares[squares.length]=square;
					this.addChild(square);
					square.x=x*dimension+x*gap;
					square.y=y*dimension+y*gap;
				}
			}
			var bg:Shape = new Shape;
			bg.graphics.beginFill(0x000000,0);
			bg.graphics.drawRect(0,0,this.width,this.height);
			this.addChildAt(bg,0)
			
			
		}
		
			

	}
}