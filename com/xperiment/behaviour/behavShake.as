package com.xperiment.behaviour
{
	import com.greensock.TweenMax;
	import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.xperiment.uberSprite;
	import com.greensock.plugins.TintPlugin; 
	
	
	import flash.display.Sprite;

	public class behavShake extends behav_baseClass
	{
		private var notRunning:Boolean=true;
		
		override public function setVariables(list:XMLList):void {
			setVar("number","size",.5);
			super.setVariables(list);
			TweenPlugin.activate([TransformAroundCenterPlugin]);
			TweenPlugin.activate([TintPlugin])
		}
		
		override public function givenObjects(obj:uberSprite):void {
			super.givenObjects(obj);
		}
		
		override public function nextStep(id:String=""):void{
			var spr:Sprite=manageBehaviours.bossSprite;
			if(notRunning){
				notRunning=false;
				TweenMax.fromTo(theStage, .4, 
					{tint:0xFF0000},
					{removeTint:true});
				TweenMax.fromTo(spr, .2, 
					{transformAroundCenter:{scaleX: getVar("size"), scaleY: getVar("size")}, alpha:.2,tint:0xFF0000},
					{transformAroundCenter:{scaleX: 1, scaleY:1}, alpha:1,onComplete:hasFinished, removeTint:true});
			}
		}
		
		public function hasFinished():void{
			notRunning=true;
			behaviourFinished();
		}
		
		
		
		override public function kill():void
		{
			TweenMax.killAll();
			super.kill();
		}
	}
}