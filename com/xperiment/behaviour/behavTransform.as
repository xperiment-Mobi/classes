package com.xperiment.behaviour
{

	import com.greensock.transform.TransformManager;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trial.Trial;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class behavTransform extends behav_baseClass
	
	{
		public var manager:TransformManager;
		public var container:DisplayObject;
		private var infoBox:TextField;
		private var multiTouch:Vector.<String>
		private var listListeners:Array;


		override public function setVariables(list:XMLList):void {
			setVar("boolean","constrainScale",true,"");
			setVar("boolean","showInfo",false);
			setVar("boolean","lockRotation",false);
			setVar("boolean","lockPosition",false);
			setVar("boolean","lockScale",true);
			setVar("boolean","allowDelete",true);
			setVar("boolean","copy",false);
			setVar("boolean","ForceSelectionToFront",true);
			setVar("boolean","scaleFromCentre",false);
			setVar("boolean","allowMultiSelect",true);
			setVar("boolean","arrowKeysMove",true);
			setVar("boolean","saveDepth",true,'where a 1 in your results means the stimulus is on top of all other objects');
			setVar("uint","lineColour",0x3399FF);
			setVar("int","lineThickness",1);
			setVar("int","handleSize",12);
			setVar("string","select","");
			setVar("string","containerPeg","","if stimuli are moved so they overlap the container, data is stored.  You must specify this parameter.");
		
			multiTouch = Multitouch.supportedGestures;
			
			if(multiTouch){

				for (var i:int = multiTouch.length-1; i>=0 ;i--)
					if([TransformGestureEvent.GESTURE_ZOOM,	TransformGestureEvent.GESTURE_ROTATE].indexOf(multiTouch[i])==-1){
						multiTouch.splice(i,1);
				}
	
				touchListenersInitKill(true);
				Multitouch.inputMode=MultitouchInputMode.GESTURE;
				
				setVar("boolean","arrowKeysMove",false);
			}
			super.setVariables(list);
			
			//if(getVar("containerPeg")=="")throw new Error("Error in a behaviour called Transform.  You have not set 'containerPeg'");
			
			

			

			
		}	
		
		private function showInfo():void
		{
			infoBox = new TextField();
			infoBox.background=true;
			infoBox.backgroundColor=0x333333;
			infoBox.selectable=true;
			infoBox.textColor=0xffffff;
			infoBox.alpha=.8;
			infoBox.width=400;
			infoBox.height=60;
			infoBox.text="123"
			infoBox.wordWrap=true;
			theStage.addEventListener(KeyboardEvent.KEY_DOWN,buttonL);
			theStage.addEventListener(MouseEvent.MOUSE_UP,updateTextBoxL);			
		}
		
		private function updateTextBoxL(e:MouseEvent):void{
			composeInfoBoxText();
		}
		
		private function buttonL(e:KeyboardEvent):void{
			
			if(e.keyCode == Keyboard.CAPS_LOCK){
				if(Keyboard.capsLock){
					composeInfoBoxText();
					theStage.addChild(infoBox);
				}
				else{
					if(theStage.contains(infoBox))theStage.removeChild(infoBox);
				}
			}
		}
		
		public function composeInfoBoxText():void
		{
			storedData();
			var results:Array = [];
			for each(var dat:Object in objectData){
				results.push(dat.event+"="+dat.data);
			}

			objectData=[];
			
			infoBox.text= results.join(";");
		}		
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		override public function storedData():Array {

			for each(var stim:object_baseClass in behavObjects){
				if(container.hitTestPoint(stim.x+stim.width*.5,stim.y+stim.height*.5)){
					doResults(stim,stim.peg);
				}
			}
			
			
			return super.objectData;
		}
		
		public function doResults(stim:uberSprite,nam:String):void
		{
			var stimRect:Rectangle = stim.getBounds(theStage);
			var containerRect:Rectangle = container.getBounds(theStage);
			
			if(getVar("lockPosition")==false){
				objectData.push({event:nam+".y",data:round((stimRect.y+stimRect.height*.5-containerRect.y)/containerRect.width,100)});
				objectData.push({event:nam+".x",data:round((stimRect.x+stimRect.width*.5-containerRect.x)/containerRect.height,100)});
			}
			
			if(getVar("lockRotation")==false){
				objectData.push({event:nam+".rotation",data:round(stim.rotation)});
			}
			
			if(getVar("lockScale")==false){
				if(getVar("constrainScale")==true){
					objectData.push({event:nam+".scale",data:round(stim.scaleX)});
				}
				else{
					objectData.push({event:nam+".scaleX",data:round(stim.scaleX)});
					objectData.push({event:nam+".scaleY",data:round(stim.scaleY)});
				}
			}
			
			if(getVar("saveDepth")==true && stim.parent){
				objectData.push({event:nam+".depth",data:stim.parent.getChildIndex(stim)});
			}	
		}		
		
		public function moreResults(stim:uberSprite):void
		{
		}		
		
		//returns % to 2dp.
		public function round(num:Number,mult:int=1):String{
			return (int(num*100*mult)/100).toString();
		}
		
		override public function nextStep(id:String=""):void
		{
			setupManager();	
			if(getVar("showInfo")==true)showInfo();
			if(getVar("select")!=""){
				var select:String = getVar("select");
				for each(var stim:uberSprite in behavObjects){
					if(stim.peg==select){

						if(stim.stage)makeSelected(stim);
						else {
							listListeners ||= [];
							listListeners.push({what:stim, listen:Event.ADDED_TO_STAGE,funct:added});
							stim.addEventListener(Event.ADDED_TO_STAGE,added);
						}
					}
				}
			}
			
			
			super.nextStep();
		}
		
		private function added(e:Event):void{
		
			makeSelected(e.currentTarget as uberSprite);			
		}
		
		private function makeSelected(stim:uberSprite):void
		{
			manager.selectItem(stim);
		}
		
		private function setupManager():void
		{
			getContainer();
			
			var bounds:Rectangle = new Rectangle(0,0,Trial.RETURN_STAGE_WIDTH, Trial.RETURN_STAGE_HEIGHT);
			if(getVar("lockPosition")==true)bounds=null;
			
			
			manager = new TransformManager(
				{
					targetObjects:			behavObjects,
					constrainScale:			getVar("constrainScale"), 
					lockRotation:			getVar("lockRotation"), 
					allowDelete:			getVar("allowDelete"), 
					autoDeselect:			false, 
					lockPosition:			getVar("lockPosition"), 
					scaleFromCenter:		getVar("scaleFromCenter"),
					lockScale:				getVar("lockScale"),
					arrowKeysMove: 			getVar("arrowKeysMove"),
					allowMultiSelect: 		getVar("allowMultiSelect"),
					handleSize: 			getVar("handleSize"),
					lineThickness:			getVar("lineThickness"),
					lineColor:				getVar("lineColour"),
					bounds:					bounds
				});		
		}
		

		private function touchListenersInitKill(on:Boolean):void{
			var f:Function;
			if(on)	f=theStage.addEventListener;
			else	f=theStage.removeEventListener;
			
			for each(var listener:String in multiTouch){
				f(listener,touchL);
			}
			
			/*	
				setVar("boolean","lockRotation",false);
				setVar("boolean","lockPosition",false);
				setVar("boolean","lockScale",true);
				*/
		}
		

		
		protected function touchL(e:TransformGestureEvent):void
		{
			
			switch(e.type){
				case TransformGestureEvent.GESTURE_ROTATE:
					manager.rotateSelection(e.rotation * Math.PI / 180);
					break;
				case TransformGestureEvent.GESTURE_ZOOM:
					manager.scaleSelection(e.scaleX,e.scaleY);
					break;
			
			}
			
		}
		
		private function getContainer():void
		{
			var stimPeg:String = getVar("containerPeg");
			var stim:uberSprite;
			for(var i:int;i<behavObjects.length;i++){
				stim=behavObjects[i];
				if(stim.peg==stimPeg){
					container = stim;
					behavObjects.splice(i,1);
				}
			}
			if(!container)container=theStage;
		}
		
		override public function kill():void{
			
			if(listListeners){
				for each(var obj:Object in listListeners){
					obj.what.removeEventListener(obj.listen, obj.funct);
					obj.what=null;
					obj=null;
				}
				listListeners=null
			}
			
			
			touchListenersInitKill(false);
			manager.removeAllItems();
			if(infoBox){
				theStage.removeEventListener(KeyboardEvent.KEY_DOWN,buttonL);
				theStage.removeEventListener(MouseEvent.MOUSE_UP,updateTextBoxL);
				if(theStage.contains(infoBox))theStage.removeChild(infoBox);
				infoBox=null;
			}
			manager.destroy();
			super.kill();
		}
	
	}
}



