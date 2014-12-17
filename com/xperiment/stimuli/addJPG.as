package  com.xperiment.stimuli{
	
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.LoadStimulus;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;


	
	public class addJPG extends LoadStimulus  {
		public var content:Bitmap;

		override public function kill():void {
			content=null;
			while(pic.numChildren>0){
				pic.removeChildAt(0);
			}
			super.kill();
		}
		
		override public function setVariables(list:XMLList):void {
			
			//If width and height not specified, just use the graphics file's dimensions
			if(list.@width.toString().length==0)OnScreenElements.width="0";
			if(list.@height.toString().length==0)OnScreenElements.height="0";	
			if(list.@exactSize.toString().length==0)OnScreenElements.exactSize="true";	
			////////////////////////////////////////////////////////////////////////////
			setVar("boolean","exactSize",true);
			setVar("boolean","smoothing",false);
			setVar("boolean","showOutlineBeforeLoaded",false);
			super.setVariables(list);
			setVariables_loadingSpecific();
			
		}
		
		override public function RunMe():uberSprite {
	
			if(theStage){
				
				var ba:ByteArray=givePreloaded();
				
				if (ba != null) {
					setUniversalVariables();
					doAfterLoaded(ba);
				}
					
				else setupPreloader();	
			}
			return pic;
		}
		
		public function __addPic(_content:*):void{
			
			content = new Bitmap(_content.bitmapData);
			
			content.width=_content.width;
			content.height=_content.height;
			pic.scaleX=1;
			pic.scaleY=1;
			
			if(getVar("smoothing"))content.smoothing = true;
			pic.addChild(content);
			pic.name=peg;

			trace(111,getVar("width").toLowerCase(),getVar("height").toLowerCase());
			//if(getVar("exactSize")==false){

				if(getVar("width").toLowerCase()=="aspectratio" || getVar("height").toLowerCase()=="aspectratio"){

					var maxRatio1:Number = content.width/pic.myWidth;
					var maxRatio2:Number = content.height/pic.myHeight;
					
					if(maxRatio1<maxRatio2)maxRatio1=maxRatio2;
					
					content.width=content.width/maxRatio1;
					content.height=content.height/maxRatio1;
					
					content.x=(pic.myWidth-content.width)*.5;
					content.y=(pic.myHeight-content.height)*.5;
				}


			else{
				
				pic.myWidth=content.width;
				pic.myHeight=content.height;			

				setPosPercent();
			}	

			pic.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		

		override public function doAfterLoaded(content:ByteArray):void{
		setUniversalVariables();

		var loader:Loader = new Loader;
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void{
			e.currentTarget.removeEventListener(e.type,arguments.callee);
			var bmp:Bitmap = loader.content as Bitmap;
			__addPic(bmp);
			if (getVar("showBox"))showBox();
		});
		loader.loadBytes(ByteArray(content));
	}		

	}
}