package com.xperiment.stimuli.primitives
{
	import com.xperiment.stimuli.Imockable;
	

	public class MultipleChoiceGrid extends MultipleChoice implements Imockable
	{
		private var buttons:Array;
		
		
		public function MultipleChoiceGrid(params:Object,theStage)
		{
			super(params,theStage);
		}
		
		
		override public function generateChoices(params:Object):void
		{
			
			var distApart:Number=params.distanceApart as Number;
			
			var origWidth:Number=params.width;
			var origHeight:Number=params.height;
			
			var gridArr:Array = (params.grid as String).split(" ").join().split("x");
			if(gridArr.length!=2)throw new Error("you have specified a MultipleChoice stimulus with a weird grid (should be eg 2x4): "+params.grid+".");
			
			var numVer:int= gridArr[1];
			var numHor:int = gridArr[0];
			
			var buttonWidth:Number	= origWidth/numHor -(distApart*(numHor-1));
			var buttonHeight:Number = origHeight/numVer-(distApart*(numVer-1));
			
			
			var button:BasicButton;
			
			var count:int= 0;
			
			top: for(var i_ver:int=0;i_ver<numVer;i_ver++){
				
					for(var i_hor:int=0;i_hor<numHor;i_hor++){
						button=__getButton(PossibleAnswers[count],null);

						
						if(params.seperation=="horizontal"){
							button.myWidth=buttonWidth;
							button.myHeight=buttonHeight;
							
							button.x=(origWidth/numHor*i_hor)+i_hor*distApart;
							button.y=(origHeight/numVer*i_ver)+i_ver*distApart;
							

							button.init();
							
							if(count==PossibleAnswers.length-1)break top;
							count++;
						}
				}
			
			}
		}
	}
}