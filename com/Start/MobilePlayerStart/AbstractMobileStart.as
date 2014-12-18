package com.Start.MobilePlayerStart
{
	import com.Start.AbstractStart;
	import com.Start.CanRestart;
	import com.Start.MobilePlayerStart.utils.ParseMobileScript;
	import com.xperiment.messages.XperimentMessage;
	import com.xperiment.runner.runner;
	import com.xperiment.runner.runnerANDROID;
	
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.events.InvokeEvent;
	
	public class AbstractMobileStart extends AbstractStart implements CanRestart
	{ 
		private var Expt:runnerANDROID;
		public var __myScript:XML;
		protected var url:String;

		public function AbstractMobileStart(theStage:Stage,scriptName:String='')
		{
			
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE,invokedL);
			
			//XperimentMessage.message(theStage,"start");
			super(theStage,'');
			init();
		}
		
		
		protected function invokedL(e:InvokeEvent):void
		{
			
			
			if(e.arguments[0]!=1 && !url){
				
				//android specific
				url=e.arguments[0];

				if(url!=null){
					
					url=url.split("xperiment://view?id=").join("");
						//trace(1111111)				
					scriptLoad(url);
				}
			}
			
		}
		
		private function init():void{
		
			
			/*var s:SplashScreen = new SplashScreen(theStage);
			s.addEventListener(Event.COMPLETE,function(e:Event):void{
				e.target.removeEventListener(e.type, arguments.callee);
				///////////////////
				///anonymous function
				if(!url)__start();
				///anonymous function
				///////////////////			
			});
			s.start();*/
			//url='http://www.opensourcesci.com/experiments/plating2/plating2.xml';
			
			if(!url){
				//XperimentMessage.message(theStage,"started");
				__start();
			}
			else{
				
				
				//invokedL(new InvokeEvent(InvokeEvent.INVOKE,false,false,null,[1]));
			}
		}
		
		
		override public function restart():Function{
			return function():void{
				//init();
			}
		}
		
		
		public function __start():void{
			throw new Error("must override this abstract method");
		}
		

		override protected function modifyScript(script:XML):void{
			if(url)script = ParseMobileScript.addRemoteStimFolder(script,url); 
		}
		
		override public function exptPlatform():runner{
			return new runnerANDROID(theStage);
		}
		
		protected function errorLoadingScript():void
		{
			XperimentMessage.message(theStage, "Afraid your Xperiment Script cannot be loaded.");
		}
		
		
		override public function kill():void{ //does not really need as is minimal
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE,invokedL);
			theStage.removeEventListener("endOfStudy", __start);	
			super.kill();
		}
		
		
		
	}
}