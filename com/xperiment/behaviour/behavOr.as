package com.xperiment.behaviour{
	


	public class behavOr extends behavAnd {

		override protected function checkLogic():void
		{	
			for each(var obj:Object in listenPegs){
				if(obj.happened) doAction();	
			}
		}
	}
}