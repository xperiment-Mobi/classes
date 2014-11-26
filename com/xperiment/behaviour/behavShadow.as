package com.xperiment.behaviour{
	import com.greensock.TweenMax;
	import com.xperiment.uberSprite;

	
	import flash.geom.Point;
	
	
	public class behavShadow extends behav_baseClass {
		
		public static const RAD_TO_DEG:Number = 57.295779513082325225835265587527; // 180.0 / PI;
		private var angle:Number;
		private var point:Point;
		private var distance:Number;
		override public function setVariables(list:XMLList):void {

			setVar("int","startOppacity",1);	
			setVar("boolean","inner",false);
			setVar("int","blur",10,"0-100");
			setVar("int","distance",1);
			setVar("int","angle",90,"in degrees");
			setVar("number","alpha",.6);
			super.setVariables(list);
		}		
				
	
		override public function nextStep(id:String=""):void
		{
			shadow(new Point(theStage.width*.25,theStage.height*.25));	
			super.nextStep();
		}
		
		private function shadow(point:Point):void{
			for each(var us:uberSprite in behavObjects){
				//distance = Math.sqrt((us.x - point.x) * (us.x - point.x) + (us.y - point.y) * (us.y - point.y));
				angle = getVar("angle")/RAD_TO_DEG;
				TweenMax.to(us,0,{dropShadowFilter:{inner:getVar("inner"), blurX:getVar("blur"), angle:0, blurY:getVar("blur"), distance:getVar("distance"), alpha:getVar("alpha")}});
			}
		}

	}
}

/*		distance : Number [0] 
angle : Number [45] 
color : uint [0x000000] 
alpha :Number [0] 
blurX : Number [0] 
blurY : Number [0] 
strength : Number [1] 
quality : uint [2] 
inner : Boolean [false] 
knockout : Boolean [false] 
hideObject : Boolean [false] 
index : uint 
addFilter : Boolean [false] 
remove : Boolean [false] 
Set remove to true if you want the filter to be removed when the tween completes. 


override public function kill():void {

super.kill();
}
*/