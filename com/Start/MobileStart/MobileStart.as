package com.Start.MobileStart
{

	import com.Start.MobilePlayerStart.AbstractMobileStart;
	
	import flash.display.Stage;
	import flash.events.Event;

	public class MobileStart extends AbstractMobileStart
	{
		
		private var welcomeScreen:MenuFeaturesGlue;

		
				
		public function MobileStart(theStage:Stage,scriptName:String='')
		{		
			super(theStage,'');
		}
		
		
	
		
		override public function __start():void{
			theStage.autoOrients = true;
			welcomeScreen = new MenuFeaturesGlue(theStage); 
			welcomeScreen.addEventListener(Event.COMPLETE,function(e:Event):void{
				e.target.removeEventListener(e.type, arguments.callee);
				///////////////////
				///anonymous function		
				__myScript=welcomeScreen.getExpt();
				welcomeScreen.kill();
				if(__myScript==null) errorLoadingScript();

				startExpt(__myScript);	//can deal with 'null' if error above

				
				
				///anonymous function
				///////////////////			
			});
		}
		

		
	}
}