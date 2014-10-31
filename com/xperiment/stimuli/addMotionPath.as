package com.xperiment.stimuli
{
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.motionPatch.MotionPatch;

	public class addMotionPath extends object_baseClass
	{
		private var patch:MotionPatch;
		
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList):void {
			setVar("string","colour",'orange');
			setVar("int","randStartDelay",1000);
			setVar("int","dots",1);
			setVar("int","velocity",602);	
			setVar("int","radius",2);
			setVar("number","ratioCoherent",.6);
			setVar("int","lifeTime",500);
			setVar("number","angle",0,"","in degrees");
			setVar("string","type","circle","dot|circle","the shape containing the dots");
	
			
			super.setVariables(list);
			
		}
		
		
		override public function RunMe():uberSprite {
			
			super.setUniversalVariables();
			
			var _width:int=pic.width;
			var _height:int=pic.height;
			
			pic.scaleX=1;
			pic.scaleY=1;
			
			var params:Object = {
				randStartDelay:getVar("randStartDelay"), 
				width:_width, 
				height: _height, 
				dots: getVar("dots"), 
				colour: getVar("colour"), 
				vel:getVar("velocity"), 
				radius:getVar("radius"),
				angle:getVar("angle")/360*2*Math.PI,
				numCoherent:getVar("ratioCoherent"),
				lifeTime:getVar("lifeTime"),
				type:getVar("type"),
				globalX:myX,
				globalY:myY
			}
				
		
			patch = new MotionPatch(params);
			
			
			pic.addChild(patch);
			
			return pic;
		}
		
		override public function kill():void{
			if(patch){
				pic.removeChild(patch);
				patch.kill();
			}
			super.kill();
		}
	}
}

