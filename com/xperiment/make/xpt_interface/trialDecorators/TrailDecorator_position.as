package com.xperiment.make.xpt_interface.trialDecorators
{
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformItem;
	import com.greensock.transform.TransformManager;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.Bind.UpdateRunnerScript;
	import com.xperiment.make.xpt_interface.trialDecorators.Helpers.GetSetPos;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trial.Trial;
	
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;


	public class TrailDecorator_position
	{
		private var manager:TransformManager;
		private var movingStim:object_baseClass;
		private var transformStim:TransformItem;
		private var vertical:int=-1;
		private var horizontal:int=-1;
		
		private var _xPerStepSizes:Number = 25; //5% steps along x-axis
		private var _yPerStepSizes:Number = 25; //15% steps along y-axis
		private var xSpacing:Number;
		private var ySpacing:Number;
		private var theStage:Stage;
		private var grid:Shape;
		
		private var horToCentre:Number=0;
		private var verToCentre:Number=0
		private var xMod:int;
		private var yMod:int;
		
		public function set_yPerStepSizes(y:Number,update:Boolean=true):void
		{
			ySpacing = y * 0.01 * Trial.RETURN_STAGE_HEIGHT;
			_yPerStepSizes = y;
			if(update)addGridToStage();
		}

		public function set_xPerStepSizes(x:Number,update:Boolean=true):void
		{
			_xPerStepSizes = x;
			xSpacing = x * 0.01 * Trial.RETURN_STAGE_WIDTH;
			if(update)addGridToStage();
		}

		public function kill():void
		{
			if(manager.hasEventListener(MouseEvent.MOUSE_DOWN))manager.removeEventListener(MouseEvent.MOUSE_DOWN,startMoveF)
			theStage.removeChild(grid);
		}
		

		

		
		protected function startMoveF(e:MouseEvent):void
		{
			if(manager.selectedItems.length==1){
				transformStim = manager.selectedItems[0]
				movingStim = (manager.selectedItems[0]).targetObject as object_baseClass;
				
				var pos:Object = GetSetPos.GET(movingStim);
				horizontal =  pos.horizontal;
				vertical	= pos.vertical;
				
				
				switch(horizontal){
					case 1:
						xMod=-movingStim.myWidth*.5
						break;
					case 0:
						xMod=0
						break;
					case -1:
						xMod=movingStim.myWidth*.5;
						break;
				}
				switch(vertical){
					case 1:
						yMod=movingStim.myHeight*0
						break;
					case 0:
						yMod=0;
						break;
					case -1:
						yMod=-movingStim.myHeight;
						break;
				}
				
				var p:Point = movingStim.localToGlobal(new Point(xMod, yMod));
				
				xMod = theStage.mouseX - p.x;
				yMod = theStage.mouseY - p.y;
				
				horToCentre=movingStim.width*.5-movingStim.mouseX;
				verToCentre=movingStim.height-movingStim.mouseY;
								
				listeners(true);
			
			}
		}		
		
		private function listeners(on:Boolean):void
		{
			var f:String;
			if(on)	f='addEventListener';
			else	f='removeEventListener';
			

			
			manager[f](TransformEvent.MOVE,mouseMoveF);
			theStage[f](MouseEvent.MOUSE_UP,mouseUpF);
			
		}
		
		protected function mouseUpF(e:MouseEvent):void
		{

			manager.deselectItem(transformStim);
			manager.selectItem(transformStim); //snaps the transform grid back onto object

			listeners(false);
			//update pos: movingStim;

		}
		

	
		public function TrailDecorator_position(manager:TransformManager,theStage:Stage)
		{
			this.manager=manager;
			this.theStage=theStage;
			
			theStage.addEventListener(MouseEvent.MOUSE_DOWN,startMoveF);
			set_xPerStepSizes(_xPerStepSizes,false);
			set_yPerStepSizes(_yPerStepSizes,false);
			
			addGridToStage();
		}
		
		private function addGridToStage():void
		{
			if(grid)theStage.removeChild(grid);
			
			grid = new Shape;
			var currentX:Number=0;
			var currentY:Number=0;
			
			var col:int = 0xFFFFFF - codeRecycleFunctions.getColour(ExptWideSpecs.IS("BGcolour"));
			
			
			
			grid.graphics.lineStyle(1,col,.6);

			while(currentX<Trial.RETURN_STAGE_WIDTH){
				grid.graphics.moveTo(currentX,0);
				grid.graphics.lineTo(currentX, Trial.RETURN_STAGE_HEIGHT);
				currentX+=xSpacing;
			}

			while(currentY<Trial.RETURN_STAGE_HEIGHT){
				grid.graphics.moveTo(0,currentY);
				grid.graphics.lineTo(Trial.RETURN_STAGE_WIDTH,currentY);
				currentY+=ySpacing;
			}
	
			theStage.addChildAt(grid,0);


		}
		
		private function mouseMoveF(e:TransformEvent):void{			

			var origStim:uberSprite = (transformStim.targetObject as uberSprite)
			
			
			transformStim.x=(((theStage.mouseX + xSpacing*.5) / xSpacing) >> 0) * xSpacing-transformStim.width*origStim.horizontalCorrection;// - xMod;
			transformStim.y=(((theStage.mouseY + ySpacing*.5) / ySpacing) >> 0) * ySpacing-transformStim.height*origStim.verticalCorrection;// - yMod;

			
		}
		
		
		
		
		
		
		public static function generatePos(stim:object_baseClass, x:int, y:int, updateF:Function):void{


			var bind_id:String = stim.getVar(BindScript.bindLabel);
			
			var newVal:String;
			
			newVal= sortX(stim, x,BindScript.getOrigVal(bind_id,'x'));
			if(newVal){
				updateF([stim],{x:newVal});
			}
			
			newVal = sortY(stim, y,BindScript.getOrigVal(bind_id,'y'));
			if(newVal){
				updateF([stim],{y:newVal});
			}
			
			UpdateRunnerScript.DO(stim.getVar(BindScript.bindLabel));
		}
		
		public static function sortX(stim:object_baseClass, x:Number, origVal:String):String
		{
			var isPercent:Boolean = origVal.indexOf("%")!=-1 || origVal=="";
			
			switch (stim.getVar("horizontal")) {
				case ("left") :
					break;
				case ("right") :
					x=x+stim.myWidth;
					break;
				default :
					x=x+stim.myWidth*.5;
			}
			if(isPercent || origVal=="")	x=x*100/stim.returnStageWidth;
			return checkIfChanged(isPercent,x,origVal);
		}
		
		private static function checkIfChanged(isPercent:Boolean, newVal:Number, origVal:String):String
		{
			newVal = codeRecycleFunctions.roundToPrecision(newVal,2);
			var str:String = newVal.toString();
			if(isPercent)str=str+"%";
			if(str!=origVal){
				return str;
			}
			return null;
		}		
		
		
		public static function sortY(stim:object_baseClass, y:Number, origVal:String):String
		{
			
			var isPercent:Boolean = origVal.indexOf("%")!=-1 || origVal=="";
			
			switch (stim.getVar("vertical")) {
				case ("top") :
					break;
				case ("bottom") :
					y=y+stim.myHeight;
					break;
				default :
					y=y+stim.myHeight*.5;
			}			
			
			if(isPercent)	y=y*100/stim.returnStageHeight;
			return checkIfChanged(isPercent,y,origVal);
			
		}
		
		

	}
}