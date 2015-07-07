package  com.xperiment.stimuli{
	
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.LoadStimulus;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;


	
	public class addJPG extends LoadStimulus  {
		public var content:Bitmap;
		private var overTrials:String;

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
			if(list.@exactSize.toString().length==0)OnScreenElements.exactSize="false";	
			////////////////////////////////////////////////////////////////////////////
			setVar("boolean","exactSize",true);
			setVar("boolean", "keepBoxSize",false,"","keeps the size of your width and height setting, irrespective of you using eg exactSize. Good for adding a specific sized background");
			setVar("boolean","smoothing",false);
			setVar("boolean","showOutlineBeforeLoaded",false);
			setVar("string","overTrials","","","keeps the image on screen. Until the next image with the same value is shown (then previous image is removed)");
			setVar("string","background","");
			super.setVariables(list);	
			
			overTrials = getVar("overTrials");
			if(overTrials=="remove")	OverTrials.REMOVE();

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
			
			if(overTrials!="") OverTrials.DO((content as Bitmap),overTrials);
			
			function centreContent():void{
				content.x=(pic.myWidth-content.width)*.5;
				content.y=(pic.myHeight-content.height)*.5;
			}
			
			function resize():void{
				if(getVar("keepBoxSize")==false){
					pic.myWidth=content.width;
					pic.myHeight=content.height;
				}
			}

			//trace(111,getVar("width").toLowerCase(),getVar("height").toLowerCase());
			if(getVar("exactSize")==false){

				//if(getVar("width").toLowerCase()=="aspectratio" || getVar("height").toLowerCase()=="aspectratio"){

					var maxRatio1:Number = content.width/pic.myWidth;
					var maxRatio2:Number = content.height/pic.myHeight;
					
					if(maxRatio1<maxRatio2)maxRatio1=maxRatio2;
					
					content.width=content.width/maxRatio1;
					content.height=content.height/maxRatio1;
					resize();
					centreContent();
					setPosPercent();
				//}

	
				/*else{
					resize();
					setPosPercent();
					
				}*/
			}
			else{
				resize();
				centreContent();
				setPosPercent();
			}
			
			var bg:String = getVar("background");
			if(bg.length!=0){
				var col:int = codeRecycleFunctions.getColour(bg);
				pic.graphics.beginFill(col,1);
				pic.graphics.drawRect(0,0,pic.myWidth,pic.myHeight);
			}

			pic.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		

		override public function doAfterLoaded(content:ByteArray):void{
			if(content){
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
			else{
				setupPreloader();
			}
		}		

	}
}


import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Rectangle;

class OverTrials{
	
	private static var prevGenBitmap:Bitmap;
	private static var bitmap:Bitmap;
	private static var stage:Stage;
	private static var rect:Rectangle;
	

	public static function DO(b:Bitmap, id:String):void{
		prevGenBitmap = bitmap;
		bitmap = b;
		
		bitmap.addEventListener(Event.ADDED_TO_STAGE,listeners);
		bitmap.addEventListener(Event.REMOVED_FROM_STAGE, listeners);
	}
	
	protected static function listeners(e:Event):void
	{
		e.currentTarget.removeEventListener(e.type,listeners);
		
		
		if(e.type == Event.REMOVED_FROM_STAGE){
			stage.addEventListener(Event.ADDED,listeners);
			STAGE("add",bitmap);
			bitmap.x=rect.x;
			bitmap.y=rect.y;
			bitmap.width = rect.width;
			bitmap.height = rect.height;
		}
		
		else if(e.type == Event.ADDED_TO_STAGE){
			
			STAGE("remove",prevGenBitmap);	
			
			rect = bitmap.getBounds(stage);
			stage = bitmap.stage;
		}
		
		else if(e.type == Event.ADDED){
			if(bitmap) stage.addChild(bitmap);	
		}
	}
	
	private static function STAGE(action:String, what:Bitmap):void{
		if(action=="add"){
		
			if(what.parent.parent){
				var parent:Sprite = what.parent.parent.parent as Sprite;
				var index = stage.getChildIndex(parent);
				stage.addChild(what);
				stage.addChild(parent);
			}
			else{ 
				stage.addChild(what);
			}
			
		}
		else if(action=="remove"){
			if(what)	stage.removeChild(what);		
		}
	}
	

	public static function REMOVE():void
	{
		STAGE("remove", prevGenBitmap);		
		prevGenBitmap=null;
		
	}
}
	

