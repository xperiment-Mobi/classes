package  com.xperiment.stimuli{

	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.preloader.IPreloadStimuli;
	import com.xperiment.stimuli.primitives.BasicText;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;


	public class addLoadingIndicator extends object_baseClass implements IgivePreloader {

		private var txt:Sprite;
		private var myBackground:Shape;
		private var myBar:Shape;
		private var combined:Sprite;
		private var bckground:Shape;
		private var textMessage:BasicText

		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		private var preloader:IPreloadStimuli;
		private var itemsTotal:int;
		private var mbTotal:int;
		private var outOf:String;
		
		private var isCloud:Boolean;
		private var cloudHackRunningBytes:int=0;
		private var cloudHackTotalBytes:int=0;
		private var showText:Boolean;
		
		override public function setVariables(list:XMLList):void {
			setVar("number","backBarColour",0xFFFFFF);
			setVar("number","backBarLineColour",0xc5c5c7);
			setVar("number","backBarLineThickness",6);
			setVar("number","barColour",0x0738f2);
			setVar("boolean","showText",false);
			setVar("number","MBs",0);
			setVar("string","errorMessage","Unfortunately there has been an error loading the stimuli.  The server may be down, in which case, could you try again later?  If this repeatedly happens, could you let us know by visiting www.xperiment.mobi?  Many apologies for this inconvenience.");
			super.setVariables(list);
			
			
			 outOf = getVar("MBs").toString();
			 if(outOf=="0")outOf="";
			 else{
				 outOf="/"+outOf;
			 }
			 
			 this.isCloud = ExptWideSpecs.IS("cloudID")!='';
		}
		
		private function onAllDownloaded():void{
			if(pic.stage)finish();
			else{
				pic.addEventListener(Event.ADDED_TO_STAGE,finish);
			}
			
		}
		
		private function finish(e:Event=null):void{
			if(pic.hasEventListener(Event.ADDED_TO_STAGE))pic.removeEventListener(Event.ADDED_TO_STAGE,finish);
			updateInfo("loaded all stimuli");
			this.dispatchEvent(new Event("onFinish",true));
		}

		override public function RunMe():uberSprite {
			
			showText=getVar("showText");
			
			if(preloader && preloader.countOfLoadingItems()>0){

				combined= new Sprite;
				myBackground=new Shape  ;
				myBackground.graphics.beginFill(getVar("backBarColour"));
				myBackground.graphics.lineStyle(getVar("backBarLineThickness"),getVar("backBarLineColour"));
				myBackground.graphics.drawRect(0,0,200,20);
				myBackground.graphics.endFill();
				combined.addChild(myBackground);
	
				myBar=new Shape  ;
				myBar.graphics.beginFill(getVar("barColour"));
				myBar.graphics.drawRoundRect(2,2,198,16,15,15);
				myBar.scaleX=0;
				combined.addChild(myBar);
				  
				//combined.visible=false;
				if(showText)	createInfo('commencing load');
				else createInfo('downloading stimuli');
				
				super.pic.addChild(combined);
			}
			else{
				onAllDownloaded();
			}
			
			super.setUniversalVariables();
			return (super.pic);
		}

		public function passPreloader(preloader:IPreloadStimuli):void {	
			if(preloader && preloader.progress()<1){
				this.preloader=preloader;
			}
		}
		
		private function createInfo(message:String):void{

			textMessage=new BasicText;
			var obj:Object=new Object  ;
			obj.autoSize="left";
			obj.text=message;
			obj.fontSize=15;
			obj.width=200;
			obj.height=70;
			txt=textMessage.giveBasicStimulus(obj);
			txt.y-=1;
			txt.x+=10;
			
			bckground =new Shape  ;
			bckground.graphics.beginFill(getVar("backBarColour"));
			
			
			//bckground.graphics.drawRoundRect(myBackground.x,myBackground.y,txt.width,myBackground.height*.8,13,13);
			bckground.graphics.endFill();
			bckground.alpha=.5;

			combined.addChild(bckground);
			combined.addChild(txt);
			
		}	
	
		
		private function updateInfo(message:String):void{
			
			if(textMessage)textMessage.text(message);
		}
		

		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			if(preloader){
				if(preloader.progress()==1){
					myBar.scaleX=1;
					onAllDownloaded();
				}
				else{
					itemsTotal 	= preloader.countOfLoadingItems() as int;
					mbTotal		= preloader.mbTotal() as uint;
					preloader.linkUp(onAllLoaded,onAllProgress,onAllError);
				}
			}
			else{
				onAllDownloaded();
			}
		}
	
		private function onAllLoaded(bytes:Number):void {
			if(myBar){
				if(showText)updateInfo(getText(bytes) + "in total)");
				onAllDownloaded();
			}
		}
		
		public function onAllProgress(progress:Number,bytes:Number):void {
			if(isCloud)bytes = fixBytes(bytes);
			if(myBar){
				myBar.scaleX=progress;
				if(showText)updateInfo(getText(bytes) + " loaded so far)");
			}
		}
	
		
		private function fixBytes(bytes:Number):Number
		{
			cloudHackTotalBytes+=bytes-cloudHackRunningBytes;
			if(bytes==0){
				cloudHackRunningBytes = 0;
			}

			return cloudHackTotalBytes*.1;
		}
		
		private function getText(bytes:Number):String{
			return "loading stimuli (" + String(codeRecycleFunctions.roundToPrecision(Number(bytes)/1000000,1)) + outOf +" MB "
		}

		public function onAllError(error:String):void {
			if(myBar){
				trace('error:',error);	
			}
		
		}
		
		override public function kill():void{
			if(preloader){
				
				preloader.cleanupFunctsListeners(onAllLoaded,onAllProgress,onAllError);
				
				if(textMessage)	textMessage.kill();
				
				if(combined){
					for(var i:int=0;i<combined.numChildren;i++){
						combined.removeChildAt(i);
					}
					pic.removeChild(combined)
				}
				bckground=null;
				
				textMessage=null;
				;
				txt=null;
				myBackground=null;
				myBar=null;
				combined=null;
			}
			super.kill();
			
		}
	}
}