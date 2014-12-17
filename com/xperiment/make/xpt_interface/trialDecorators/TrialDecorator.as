package com.xperiment.make.xpt_interface.trialDecorators
{
	import com.greensock.events.TransformEvent;
	import com.greensock.transform.TransformItem;
	import com.greensock.transform.TransformManager;
	import com.xperiment.uberSprite;
	import com.xperiment.behaviour.behav_baseClass;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.Bind.Bind_delStim;
	import com.xperiment.make.xpt_interface.Bind.Bind_processChanges;
	import com.xperiment.make.xpt_interface.Bind.UpdateRunnerScript;
	import com.xperiment.make.xpt_interface.trialDecorators.Helpers.GetSetPos;
	import com.xperiment.stimuli.addButton;
	import com.xperiment.stimuli.addJPG;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.trial.Trial;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.display.Sprite;

	public class TrialDecorator //extends Sprite
	{
		private var trial:Trial;
		private var stimuli:Vector.<object_baseClass>;
		private var manager:TransformManager;
		private var transparentLayers:Vector.<Sprite>;
		private var _step:Boolean = true;
		//private var selected:TransformItem;
		
		private var stepMove:TrialDecorator_position;
		private var theStage:Stage;
		//private var snapMenu:SnapMenu;
		private var editMode:Boolean = true;
		
		public static var TRANSPARENT_LAYER:String = "transparentLayer";
		private var canReset:Function;
		
		//private var selected:Array;
		
		public function kill():void{
			startupNativeInteractivity();
			if(stepMove)stepMove.kill();
			//snapMenu.kill();
			if(manager){
				listeners(false);
				manager.destroy();
				manager = null;
			}
		}
		
		public function selected():Array{

			var stimuli:Array = [];
			if(manager){
				var bind_label:String = BindScript.bindLabel;
				for each(var stim:object_baseClass in manager.selectedTargetObjects){
					stimuli.push(stim);
				}
			}
			return stimuli;
		}
		
		public function step(on:Boolean):void{
			manager.arrowKeysMove=!on;
			_step = on;
		}
		
		private function sortStep():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function TrialDecorator(runningTrial:Trial,theStage:Stage, canReset:Function)
		{
			this.trial=runningTrial;
			this.theStage=theStage;
			this.canReset = canReset;
			if(editMode)	init();	
		}
		
		public function newTrial(runningTrial:Trial):void
		{
			this.trial=runningTrial;
			if(editMode)	init();
		}
		
		
		
		private function gatherStim():void{
			transparentLayers = new Vector.<Sprite>;
			this.stimuli=trial.OnScreenElements;
			for(var i:int=0;i<stimuli.length;i++){
				add(stimuli[i]);
			}
			if(_step && !stepMove)step(true);
		}
		
		private function init(e:Event=null):void{

			if(manager) kill();
			
			manager = new TransformManager;
			manager.arrowKeysMove=true;
			manager.forceSelectionToFront=false;
			manager.lockRotation=true;
			manager.lockScale=false;
			manager.allowDelete=true;
			
			listeners(true);
			
			gatherStim();
			//selectItems();
		}
		private function deleteL(e:TransformEvent):void{
			var displayObj:DisplayObject;
			var binds:Array = [];
			for(var i:int=0;i<e.items.length;i++){
				displayObj = (e.items[i] as TransformItem).targetObject;
				if(displayObj is object_baseClass){
					binds.push(  displayObj as object_baseClass  );
				}	
			}
			Bind_delStim.stim(binds);
		}
		
		/*private function selectItems():void
		{
			if(selected){
				var selectedItems:Vector.<TransformItem> = new Vector.<TransformItem>;
				var index:int;
				var bindID:String;
				
				for each(var item:TransformItem in manager.items){
					
					bindID=(item.targetObject as object_baseClass).getVar(BindScript.bindLabel);
					index = selected.indexOf(bindID);
					
					if(index!=-1){
						selectedItems.push(item);
						selected.splice(index,1);
						break;
					}				
				}
				if(selected.length>0)throw new Error();
				selected=null;
		
				if(selectedItems.length>0)	SelectItems.please(selectedItems);

			}
		}
		*/
		public function anySelected():Array{
			return manager.selectedTargetObjects;
		}
		
		
		public function add(stim:uberSprite):void
		{
			removeNativeInteractivity(stim as object_baseClass);
			manager.addItem(stim);
			
		}
		
		private function listeners(on:Boolean):void
		{
			var f:Function;
			if(on)	f=manager.addEventListener;
			else	f=manager.removeEventListener;
			
			//TransformEvent.DOUBLE_CLICK
			for each(var eventName:String in [TransformEvent.FINISH_INTERACTIVE_MOVE,TransformEvent.SELECTION_CHANGE,
				TransformEvent.START_INTERACTIVE_SCALE,TransformEvent.FINISH_INTERACTIVE_SCALE]){
					f(eventName,listenerF);
				}
			
			f(TransformEvent.DELETE,deleteL);
		}
		
		
		private function listenerF(e:TransformEvent):void{
			var stimuli:Array = e.items;
			var what:Object;
			var stim:object_baseClass;
			for each(var transformStim:TransformItem in stimuli){
				stim = transformStim.targetObject as object_baseClass,manager;
				switch(e.type){
					/*case TransformEvent.SCALE:
					
					(transformStim as object_baseClass).scaled(
					
					break;*/
					case TransformEvent.SELECTION_CHANGE:
						
						/*if(manager.selectedItems.length==1 && selected != manager.selectedItems[0]){
						selected = manager.selectedItems[0];
						var stimulus:object_baseClass = selected.targetObject as object_baseClass
						var info:Object = stimulus.OnScreenElements;
						info.stimulusType = getQualifiedClassName(stimulus).split("::")[1];
						update(transformStim.targetObject as object_baseClass,info);
						}*/
						break;
					case TransformEvent.FINISH_INTERACTIVE_MOVE:
						updatePosition(stim, transformStim.x,transformStim.y);
						//update(stim,{x:transformStim.x,y:transformStim.y});
						break;
					case TransformEvent.START_INTERACTIVE_SCALE:
						TrialDecorator_size.started(stim,manager);
						break;				
					case TransformEvent.FINISH_INTERACTIVE_SCALE:
						var dimensions:Object = TrialDecorator_size.finished(stim);
	
						doUpdate([stim],dimensions);
						updatePosition(stim, transformStim.x,transformStim.y);
						//saveSelected();
						resetTrial();
						break;
					/*case TransformEvent.DOUBLE_CLICK:
						
						if(stimuli.length==1 && manager.selectedItems[0]){
							
							//saveSelected();
							
							EditText.doubleClick( stim, checkAndInit, finishedF );
							function checkAndInit():void{
								if(editMode)init();
							}
							function finishedF(updated:Object):void{
								doUpdate([stim],updated);
								resetTrial();
							}
							
						}
						break;*/
				}
			}
		}
		
		/*private function saveSelected():void
		{
			selected ||= [];
			for each(var stim:object_baseClass in manager.selectedTargetObjects){
				selected.push(stim.getVar(BindScript.bindLabel));
			}
		}*/
		
		private function resetTrial():void
		{
			if(canReset)canReset();
		}
		
		private function updatePosition(stim:object_baseClass, x:int, y:int):void
		{
			TrialDecorator_position.generatePos(stim, x, y, doUpdate);
			
		}
		
		
		
		/*private function update(stim, params:Object):void{
			this.dispatchEvent(new NeedsUpdating([stim],params));
		}*/
		
		private function doUpdate(stim:Array, params:Object):void{
			Bind_processChanges.stimChanged(stim,params);
	
		}
		
		
		public function startupNativeInteractivity():void{
			var transparentLayer:Sprite;
			if(transparentLayers){
				for each(transparentLayer in transparentLayers){
					
					
					if(transparentLayer.parent!=null){
						
						if(transparentLayer.parent is addButton){
							transparentLayer.parent.mouseChildren=true;
						}
						
						transparentLayer.parent.removeChild(transparentLayer);
					}
					
				}
				transparentLayers=null;		
			}
		}
		
		private function removeNativeInteractivity(stimulus:object_baseClass):void
		{
			var transparentLayer:Sprite = new Sprite;
			
		
			if(stimulus is addJPG){
				
			}
			else if(stimulus is behav_baseClass)	transparentLayer = TransparentLayer.GET_behav(stimulus,TRANSPARENT_LAYER);
			else									transparentLayer = TransparentLayer.GET(stimulus,TRANSPARENT_LAYER);
			
			if(stimulus is addButton){
				stimulus.mouseChildren=false;
			}
			
			stimulus.addChild(transparentLayer);
			transparentLayers[transparentLayers.length]=transparentLayer;

		}
		
		/*private function updateTransparentLayer(transformStim:TransformItem):void{	
			var stimulus:object_baseClass = transformStim.targetObject as object_baseClass;
			var transparentLayer:Shape=stimulus.getChildByName(TRANSPARENT_LAYER) as Shape;
			transparentLayer.graphics.clear();
			transparentLayer.graphics.beginFill(0xffffff,.5);
			transparentLayer.graphics.drawRect(0,0,stimulus.myWidth,stimulus.myHeight);
		}*/
		
		public function fromJS(data:*):void
		{
			
			//trace(1212121,data.info.val,data.info.command);
			switch(data.info.command){
				case "orient-left":
				case "orient-middle-horizontally":
				case "orient-right":
				case "orient-top":
				case "orient-middle-vertically":
				case "orient-bottom":
					var needsUpdating:Array = GetSetPos.SET(data.info.command,manager.selectedTargetObjects, manager);
					
					for(var i:int=0;i<needsUpdating.length;i++){
						//trace(11,needsUpdating.length,needsUpdating[i].what)
						doUpdate([needsUpdating[i].what],needsUpdating[i].changed);
						UpdateRunnerScript.DO((needsUpdating[i].what as object_baseClass).getVar(BindScript.bindLabel));
						//this.dispatchEvent(new NeedsUpdating(needsUpdating[i].what,needsUpdating[i].changed));
					}
					break;
				case "snap-to-grid":
					

					if(!stepMove)	stepMove = new TrialDecorator_position(manager, theStage);
					
					else if(stepMove){
						stepMove.kill();
						stepMove=null;
					}
					break;
				
				case "horizontal position":
				case "vertical position":
					data.info.val
					break;
				
				case "horizontal-snapping":
					if(stepMove){
						stepMove.set_xPerStepSizes(Number(data.info.val.split("%").join("")));
					}
					break;
				case "vertical-snapping":
					if(stepMove){
						stepMove.set_yPerStepSizes(Number(data.info.val.split("%").join("")));
					}
					break;
				
				case "stim-height":
				case "stim-width":
					//if(manager.selectedTargetObjects.length>0)	BasicDimensions.update(manager.selectedTargetObjects,data.info.command,data.info.val);
					break;
				default: throw new Error("unknown command");
			}
			
			
		}
		
		public function hack():void{
			fromJS({info:{command:"orient-middle-horizontally",val:true}})
		}
		
		public function hack1():void{
			fromJS({info:{command:"orient-right",val:false}})
		}
		
		public function setMode(editMode:Boolean):void
		{
			if(this.editMode==editMode)return;
			
			this.editMode = editMode;
			if(editMode==true)	init();
			else 				kill();
			
		}
	}
}


import com.xperiment.stimuli.object_baseClass;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import avmplus.getQualifiedClassName;

class TransparentLayer{
	
	
	[Embed(source="/assets/wand.png")]
	private static var Picture:Class;
	
	
	public static function GET(stimulus:object_baseClass,name:String):Sprite
	{
		
		var transparentLayer:Sprite = new Sprite;
		transparentLayer.name=name;
		transparentLayer.graphics.beginFill(0xffffff,0);
		
		transparentLayer.graphics.drawRect(0,0,stimulus.myWidth,stimulus.myHeight);
		
		return transparentLayer;
	}
	
	
	
	public static function GET_behav(stimulus:object_baseClass, name:String):Sprite
	{
		var transparentLayer:Sprite = new Sprite;
		transparentLayer.name=name;
		transparentLayer.graphics.beginFill(0xffff00,1);

		var pic:Bitmap = new Picture();
		
		transparentLayer.graphics.drawRoundRect(0,0,stimulus.myWidth,stimulus.myHeight,20,20);
		transparentLayer.addChild(pic)
			
		var text:TextField = new TextField();
		text.mouseEnabled=false;
		text.text = getQualifiedClassName(stimulus).split("::").pop();
		text.autoSize = TextFieldAutoSize.LEFT;
		
		transparentLayer.addChild(text);
		text.x = pic.width;
		text.y=transparentLayer.height*.5-text.height*.5;
		
		transparentLayer.filters = [new DropShadowFilter];
		
		return transparentLayer;
	}
}




/*
import com.greensock.transform.TransformItem;
import com.greensock.transform.TransformManager;
import com.xperiment.stimuli.object_baseClass;

import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;


class SelectItems{
	

	private static var selectedItems:Vector.<TransformItem>;
	private static var timer:Timer = new Timer(100,1);
	private static var manager:TransformManager;
	
	
	public static function please(s:Vector.<TransformItem>):void
	{
		selectedItems = s;
		manager = s[0].manager;

		for each(var t:TransformItem in selectedItems){
			if(t.targetObject.stage)	add(t.targetObject as object_baseClass);
			else{
				t.targetObject.addEventListener(Event.ADDED_TO_STAGE,addL);
			}
		}
		
		
		
		
	}
	
	private static function add(t:object_baseClass):void{
		if(t){
			timer.addEventListener(TimerEvent.TIMER, removeListeners);
			timer.start();
			
			manager.selectItem(t);
		}
	}
	
	protected static function removeListeners(e:TimerEvent):void
	{
		timer.removeEventListener(TimerEvent.TIMER, removeListeners);
		
		for each(var t:TransformItem in selectedItems){
			if(t.targetObject.hasEventListener(Event.ADDED_TO_STAGE)) t.targetObject.removeEventListener(Event.ADDED_TO_STAGE,addL);
		}
		timer.stop();
		selectedItems = null;
		manager=null;
		
	}
	
	protected static function addL(e:Event):void
	{

		add(e.target as object_baseClass);
		
	}
}*/