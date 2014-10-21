package com.Start.MobileStart.Screens.view
{
	import com.bit101.components.Accordion;
	import com.bit101.components.ComboBox;
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import com.bit101.utils.MinimalConfigurator;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	public class Ui_View_minComp extends Sprite implements iUi
	{
		private var oldLog:String= '';
		private var config:MinimalConfigurator;
		private var accordion:Accordion;
		private var exptsWindow:Window;
		private var _runExpt:String='';
		private var _syncExpt:String='';
		private var _currentCondition:String;
		private var _condition:String = '';
		private var _experimentToRun:String;
		
		public var feedback:TextArea;
		public var runStudy:PushButton;
		public var refreshB:PushButton;
		public var sync:PushButton;
		public var doAction:PushButton;
		public var actionComboBox:ComboBox;
		public var conditionList:ComboBox;
		public var exptListcBox:ComboBox;
		public var exptListActionscBox:ComboBox;
		public var copyWindow:Window;
		
		public function kill():void{
			exptListcBox.removeEventListener(Event.SELECT, onSelectExpt);
			exptListActionscBox.removeEventListener(Event.SELECT, onSelectExpt);
			copyWindowListener(false);
			
			var component:Component;
			for(var i:int=0;i<this.numChildren;i++){
				if(this.getChildAt(i) is Component){
					component = (this.getChildAt(i) as Component);
					this.removeChild(component);
					component.removeChildren();
					component = null;
				}
			}
			
			config = null;
			feedback = null;
			runStudy = null;
			sync = null;
			doAction = null;
			actionComboBox = null;
			conditionList = null;
			_currentCondition = '';
			_syncExpt = '';
			_runExpt = '';
			refreshB = null;
			exptListcBox=null;
		}
		
		public function set currentCondition(value:String):void{_currentCondition = value;}
		public function get condition():String{return _condition;}
		public function get currentCondition():String{return _currentCondition;}public function get syncExpt():String{return _syncExpt;}
		public function get runExpt():String{return _runExpt;}
		public function get experimentToRun():String{return _experimentToRun;}
		
		
		public function setConditionItems(arr:Array):void{
			conditionList.selectedIndex=-1;
			conditionList.removeAll();
			currentCondition('')
			
			for(var i:int=0;i<arr.length;i++){
				conditionList.addItem(arr[i]);	
			}	
			
			if(conditionList.items.length==0){
				conditionList.enabled=false;
			}
			
			else conditionList.enabled=true;
		}
		
		public function setExptItems(arr:Array):void{
			exptListcBox.removeAll();
			exptListActionscBox.removeAll();
			
			for(var i:int=0;i<arr.length;i++){
				exptListcBox.addItem(arr[i]);
				exptListActionscBox.addItem(arr[i]);
			}	
			
			enableButtons(true);
		}
		
		
		public function pipeLog(liveLog:String):void{
			if(feedback)feedback.text=liveLog+'\n'+feedback.text;
			//feedback.up
		}
		
		public function wipeFeedback():void{
			feedback.text='';
		}
		
		public function enableButtons(yes:Boolean):void{
			for each(var b:PushButton in [runStudy,sync,doAction,refreshB]){
				b.enabled = yes;	
			}
			for each(var c:ComboBox in [exptListcBox, exptListActionscBox]){
				c.enabled = yes;	
			}
			
		}

		private function onSelectExpt(e:Event):void
		{
			
			if(e.target is ComboBox){
				var c:ComboBox = e.target as ComboBox;
				switch((e.target as ComboBox).name){
					case 'exptListcBox':
						
						_runExpt=c.selectedItem as String;
						this.dispatchEvent(new Event("changeConditionOptions"));
						break;
					case 'exptListActionscBox':
						_syncExpt=c.selectedItem as String
						break;
				}
			}
		}
		
		
		public function create():void
		{
			//var window:Window;
			//window.hasMinimizeButton
			
			var window:XML =
				<comps>
				<Window id='copyWindow' title='console (double click me to copy contents)' hasMinimizeButton='true' height='100' width='250' minimized='false' x="20" y="340">
					<TextArea id="feedback" text={oldLog} width="250" height="80" />
				</Window>
				<Window hasMinimizeButton='true' event="click:onClick" height="270" width="120" x='5' y='10' title="Experiment">
					<VBox x="10" y="10">
						<ComboBox enabled="true" name='exptListcBox'id="exptListcBox" defaultLabel="experiment" />
						<ComboBox enabled="false" id="conditionList" defaultLabel="condition" />
						<PushButton id='runStudy' name='runStudy' label="run" height="40" width="100" />
						<PushButton id='refreshB' name='refreshB' label="refresh" height="40" width="100" />
					</VBox>
				</Window>
				<Window hasMinimizeButton='true' minimized='false' event="click:onClick" height="50" width="100" x='150' y='10' title="Dropbox">
					<PushButton id='sync' name='snyc' label="snyc" height="30" width="100" />	
				</Window>
				<Window hasMinimizeButton='true' height='210' x='150' event="click:onClick" y='70' width='120' title="Expt actions">			
					<VBox x="10" y="10">	
						<ComboBox enabled="true" name='exptListActionscBox' id="exptListActionscBox" defaultLabel="experiment" />
						<ComboBox id='actionComboBox' defaultLabel="action" height="40"/>
						<PushButton id='doAction' name='doAction' label="do" height="40" width="100" />
					</VBox>
				</Window>
			</comps>

			config = new MinimalConfigurator(this);	
			config.parseXML(window);
			
			for each(var label:String in ['delete results']){
				actionComboBox.addItem(label);
				
			}
			
			var spr:Sprite = new Sprite;
			spr.graphics.beginFill(0x884411,.5);
			
			this.dispatchEvent(new Event("populateMenu"));
			
			exptListcBox.addEventListener(Event.SELECT, onSelectExpt);
			exptListActionscBox.addEventListener(Event.SELECT, onSelectExpt);
			copyWindowListener(true);
		}
		
		private function onClick(e:Event):void
		{
			if(e.target is PushButton){
				switch((e.target as PushButton).name){
					case 'runStudy':
						if(runExpt!=''){
							_experimentToRun=runExpt
							if(conditionList.items.length > 0){
								if(conditionList.selectedItem!=null)_condition = conditionList.selectedItem.toString();
							}
							this.dispatchEvent(new Event(Event.COMPLETE));
						}
						break;
					case 'snyc':
						this.dispatchEvent(new Event("sync"));
						break;
					case 'doAction':
						if(syncExpt!='' && actionComboBox.selectedItem){
							_condition = actionComboBox.selectedItem.toString()
							this.dispatchEvent(new Event(Event.COMPLETE));
						};
						break;
					case 'refreshB':
						
						this.dispatchEvent(new Event("refresh"));
						//default: throw new Error();
						
				}
			}			
		}
		
		private function copyWindowListener(on:Boolean):void{
			
			function feedbackCopy(e:MouseEvent):void
			{
				System.setClipboard(feedback.text);
				var old:String = feedback.text;
				feedback.text='COPIED TO CLIPBOARD\n'+feedback.text;
			}
			
			if(!on)copyWindow.titleBar.removeEventListener(MouseEvent.CLICK,feedbackCopy);
			else copyWindow.titleBar.addEventListener(MouseEvent.CLICK,feedbackCopy);
		}
			
	}
}