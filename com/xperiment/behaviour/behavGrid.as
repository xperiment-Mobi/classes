package com.xperiment.behaviour
{
	public class behavGrid extends behavRandPos
	{
		public function behavGrid()
		{
		}
		
		override public function nextStep(id:String=""):void
		{
			place();
			
			super.nextStep();
		}
		
		private function place():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}