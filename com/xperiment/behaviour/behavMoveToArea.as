package com.xperiment.behaviour{

	import com.greensock.TweenLite;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;


	public class behavMoveToArea extends behav_baseClass {
		
		private var dropZones:Vector.<object_baseClass>;
		private var stim:object_baseClass;
		private var mouseHidden:Boolean = false;
		private var startX:Number;
		private var startY:Number;
		
		private var startMouseY:int;
		private var startMouseX:int;
		private var startStimY:int;
		private var startStimX:int;
		
		private var hor:Boolean;
		private var ver:Boolean;

		private var stopped:Boolean = false;
		private var tween:TweenLite;
		private var keys:Object;
		
		
		override public function setVariables(list:XMLList):void {
			
			setVar("boolean","showDropZones",false);
			setVar("string","movePeg","","","only 1 stim can be specified here" );
			setVar("string","direction","xy","","either xy x or y");
			setVar("boolean","moveToMiddle","false","","moves the stimulus to the middle of the dropzone after touch detected");
			setVar("string","useKeys","","","eg {left:'z',right:'y'} or cursors");
			setVar("boolean","useMouse",true);
			setVar("int","time","200","","the time in ms taken for the animation");
			
			super.setVariables(list);

		}
		
		override public function kill():void{
			if(tween){
				tween.kill();
			}
			listeners(false);		
			super.kill();
		}
		

		
		override public function returnsDataQuery():Boolean {
			 return true;
		}

	
		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			allocateStim();
			setRelativePos();
			setMovements();
			listeners(true);
			keyListeners(true);

		}
		
		private function keyListeners(ON:Boolean):void
		{
			if(ON){
				var str:String = getVar("useKeys");

				if(str=="") return;
				
				if(str.toLowerCase()=="cursors") keys ="xy";
				
				keys = codeRecycleFunctions.strToObj(str);
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyL);
			}
			else if(keys && stage && stage.hasEventListener(KeyboardEvent.KEY_DOWN)){
				keys = null;
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyL);
				
			}
			
		}
		
		protected function keyL(e:KeyboardEvent):void
		{
			var keyVal:int;

			for(var key:String in keys){
				keyVal = keys[key].charCodeAt(0);	
	
				if(e.charCode == keyVal){
					
					moveStim( key.toLowerCase() );
					
					
					return;
					
				}
			}
		}
		
		private function moveStim(dir:String):void
		{

			var chosen:object_baseClass;
			var target:object_baseClass;
		
			if(dir=="up")	{			
				var high:int=int.MIN_VALUE;
				
				for each(target in dropZones){
					if(target.myY > high){
						high = target.myY;
						chosen = target;
					}
				}
				
			}
			
			else if(dir=="down"){
				var low:int=int.MAX_VALUE;
				
				for each(target in dropZones){
					if(target.myY < low){
						low = target.myY;
						chosen = target;
					}
				}
			
			}
			else if(dir=="left"){
				var left:int = int.MAX_VALUE;
				
				for each(target in dropZones){
					if(target.myX < left){
						left = target.myX;
						chosen = target;
					}
				}
			}
			else if(dir=="right"){
				var right:int = int.MIN_VALUE;
				for each(target in dropZones){
					if(target.myX > right){
						right = target.myX;
						chosen = target;
					}
				}
			}
			
			
			if(chosen){
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyL);
				overlapOccured(chosen);	
			}
		}
		
		private function setMovements():void
		{
			var arr:Array = (getVar("direction") as String).toLowerCase().split("");
			if(arr.indexOf("x")!=-1) hor = true;
			if(arr.indexOf("y")!=-1) ver = true;
		}
		
		private function setRelativePos():void
		{
			startMouseX = stage.mouseX;
			startMouseY = stage.mouseY;
			
			startStimX = stim.x;
			startStimY = stim.y;
	
		}		

		
		private function listeners(ON:Boolean):void
		{
			if(getVar("useMouse") == false) return;
			
			if(!stim) return;
			
			if(ON){
				stage.addEventListener(MouseEvent.MOUSE_MOVE, moveL);	
			}
			else if(stopped==false){
				stopped = true;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveL);
			}
		}
		
		protected function moveL(e:Event):void
		{
		
			if(hor){
				stim.x = - startMouseX + stage.mouseX + startStimX;
			}
			if(ver){
				stim.y = - startMouseY + stage.mouseY + startStimY;
			}
			
			for(var i:int=dropZones.length-1;i>=0;i--){
				if(stim.hitTestObject(dropZones[i])) overlapOccured(dropZones[i]);
			}
			
		}
		
		private function overlapOccured(dropZone:object_baseClass):void
		{
	

			if(getVar("moveToMiddle")) moveToMiddle(dropZone);
			var what:String = this.peg;
			var data:String = dropZone.peg;

			objectData.push({what:what, data:data});
			listeners(false);
			if(mouseHidden)		Mouse.show();
			behaviourFinished();
		}
		
		private function moveToMiddle(dropZone:object_baseClass):void
		{
			if(tween) tween.kill();
			
			var _x:int = dropZone.myX+dropZone.myWidth*.5 - stim.myWidth*.5;
				
			var _y:int = dropZone.myY+dropZone.myWidth*.5 - stim.myHeight*.5
			
			var params:Object;
			
			if(hor && ver)	params = {x: _x,y:_y};
			else if(hor)	params = {x: _x};
			else if(ver)	params = {y:_y};
				
			var time:Number = getVar("time");

			
			tween = TweenLite.to(stim, time/1000, params);
		}		

		
		private function allocateStim():void
		{
			dropZones = new Vector.<object_baseClass>;
			var drag:String = getVar("movePeg");
	
			for each(var s:object_baseClass in behavObjects){
				if(s.peg == drag) stim = s;
				else dropZones[dropZones.length] = s;
			}
			if(!stim) err("You have not specified the stimulus to drag via dragPeg");
			if(dropZones.length==0) err("You must provide at least 1 dropZone to drag the stimulus to");
		}		
		
		private function err(txt:String):void
		{
			throw new Error("Error with behavMoveArea (peg="+peg+"):"+txt);
			
		}	
		

	}
}
