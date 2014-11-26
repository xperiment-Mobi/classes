package com.Start.MobileStart.Screens.view
{

	import com.danielfreeman.extendedMadness.UIMenu;
	import com.danielfreeman.extendedMadness.UIPanel;
	import com.danielfreeman.extendedMadness.UITabPagesTop;
	import com.danielfreeman.extendedMadness.UIe;
	import com.danielfreeman.madcomponents.UI;
	import com.danielfreeman.madcomponents.UIButton;
	import com.danielfreeman.madcomponents.UILabel;
	import com.danielfreeman.madcomponents.UINavigation;
	import com.danielfreeman.madcomponents.UIPages;
	import com.danielfreeman.madcomponents.UIScrollVertical;
	import com.danielfreeman.madcomponents.UIWindow;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import asfiles.MyEvent;
	
	/**
	 class name: WelcomeScreen
	 purpose:  The purpose of the class is to render a UI for mobile 
	 component used:  madomponent
	 author: samit.basak@gmail.com
	 */

	public class Ui_View_madComp extends Sprite implements iUi
	{
		private var _runExpt:String='';
		private var _syncExpt:String='';
		private var _condition:String= '';
		private var _experimentToRun:String = '';
		private var _action:String;
		private var count:uint=0;
		private var _experimentForAction:String;
		
		private static const SELECTED:String = "selected";
		
		private var uiItems:Vector.<UiItem> = new Vector.<UiItem>;
		
		private var myXML:XML;
		
		protected var _navigation:UINavigation;
		protected var menu:UIMenu;
		protected var _consol:UILabel;
		protected var _debugScroller:UIScrollVertical;
		
		
		public function get experimentForAction():String{return _experimentForAction;}
		public function get action():String{return _action;}
		public function get condition():String{return _condition;}
		public function get syncExpt():String{return _syncExpt;}
		public function get runExpt():String{return _runExpt;}
		public function get experimentToRun():String{return _experimentToRun;}
		

		
		[Embed(source="experiment.png")]
		protected static const EXPERIMENT:Class;
		[Embed(source="dropbox.png")]
		protected static const DROP_BOX:Class;
		[Embed(source="action-icon.png")]
		protected static const ACTION:Class;
		
		protected var _experiments:Array;
		private var _expts:Object;
		private static var selectThisStudy:String;

		
		public function setForFutureExptToRun(expt:String):void{
			selectThisStudy = expt;
		}
		
		public function set expts(expts:Object):void{
			_expts = expts;
			
			if(UI.attributes == null){
				this.addEventListener('populateMenu',setupMenu);
			}
			else(setupMenu(null));

			function setupMenu(e:Event):void{

				if(e != null){
					removeEventListener(e.type,arguments.callee);
				}
				
				menu = UIMenu(UI.findViewById("Experiments"));
				var experimentList:Array = [];
				
				//only setting the experiments menu. Conditions menu generated once experiment is selected (if necessary)
				for(var expt:String in _expts){
					experimentList.push(expt);

				}

				if(experimentList.length>0){
	
					menu.data=experimentList;
					menu.text="Experiments";
					menu.alpha=1;
					
					
					//in the future we could prespecify the item to be selected (if expt has already been run, likely the expter wants to run the same study again).
					//menu.
					//selectThisStudy
					if(selectThisStudy){
						menu.text=selectThisStudy;
						_experimentToRun=selectThisStudy;
					}
					
				}
				else{
					menu.text="no expts on device";
					menu.alpha=.7;
				}
				setExptConditions(''); //sets transparency to .7
			}
		}
		
		
		public function kill():void{
			UI.clear();
			
			menu.clear();
			menu=null;
			
			uiItems=null;
			_expts=null;
			
			while(this.numChildren>0){
				this.removeChildAt(0);
			}

				
		};
		
		public function create():void{
			xmlReader();
		};
		
		public function disable(yes:Boolean):void{
			if(UI.attributes){
				if(yes)	UI.dimUI();
				else   	UI.unDimUI();
			}
			
		}
		
		public function popup(message:String):void{
			var xml:XML = 	<vertical>
								<label alignH='fill'>{message}</label>
                            	<button id="popup" alignH="centre" alignV="centre">close</button>
							</vertical>;
			var _popUp:UIWindow = UI.createPopUp(xml,180.0, 200.0);
			_popUp.addEventListener(MouseEvent.CLICK,function(e:Event):void{
				//anon function
				e.target.removeEventListener(e.type,arguments.callee);
				UI.removePopUp(_popUp);
				////
			});	

		}
		
		private function setExptConditions(expt:String):void
		{
			var conditionObj:UIMenu =UIMenu( UI.findViewById('Condition'));
			
			if(expt=='')conditionObj.alpha=0;
			
			else if(expt!='' && _expts[expt].length>0){
				//trace(222, _expts[expt].length);
				conditionObj.data=_expts[expt];
				conditionObj.alpha=1;
			}
			else{
				conditionObj.alpha=0;
			}
		}
		
		

		public function wipeFeedback():void{
			count=1;
			_consol.text='';
		};
		
		
		public function enableButtons(yes:Boolean):void{
			
			for each(var uiItem:UiItem in uiItems){uiItem.listen(yes);}
		}

		
		public function pipeLog(liveLog:String):void{
			_consol.text = (count++)+": "+liveLog+"\n"+_consol.text;
		};
		
		
		public function renderXML():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			UIe.create(this, myXML);
			
			
			//for each(var str:String in menu.data){
			//	trace(str,222);
			//}
	
			
			var tabPages:UITabPagesTop = UITabPagesTop(UI.findViewById("tabPages"));
			var pages:Array = tabPages.pages;
	
			tabPages.setTab(0, UIPanel(pages[0]).xml.children()[0].attribute('name'),EXPERIMENT);
			tabPages.setTab(1, UIPanel(pages[1]).xml.children()[0].attribute('name'),DROP_BOX);
			tabPages.setTab(2, UIPanel(pages[2]).xml.children()[0].attribute('name'), ACTION);
			
			
			
			
			//cycles through xml file and pulls out all buttons/menus with an id.
			//(makes it easy to add new buttons to the menu as no code needs updating in here)
			var listOfStimuli:XMLList = myXML..*.(name()=='button' || name()=='menu');
			var stimName:String;
			for each(var item:XML in listOfStimuli){
				stimName=item.@id;
				if(stimName=='')throw new Error('devel: there is a button/dropDown-menu in the menu script that has no id and therefore cannot do anything');
				
				if(item.name()=='button')	uiItems.push(new UiItem(stimName,UIButton.CLICKED,listener));
				else						uiItems.push(new UiItem(stimName,SELECTED,listener));
			}
			//			


			for each(var uiItem:UiItem in uiItems){
				uiItem.displayObject = UI.findViewById(uiItem.name);
				uiItem.listen(true);
			}

			_consol  = UILabel(UI.findViewById("consol"));
			_debugScroller = UIScrollVertical(UI.findViewById("debugScroller"));
			
			this.dispatchEvent(new Event('populateMenu'));
		}
			
		
		
		public  function xmlReader():void
		{
			
				myXML = <tabPagesTop   id="tabPages"  stageColour="#333333" color="#ffffff">
	<vertical   alignH="fill" gapV="20" name="Experiments">

			<menu id="Experiments" value="Experiments" alignH="fill" width="250"  />
			

		<menu id="Condition" value="Condition" alignH="fill" width="250"   />
		
		<vertical alignV="bottom" >
			<button id="runStudy" alignH="fill" alignV="bottom"  height="150"  background="#9999CC,#EEEEFF,#aaaaff,10"><font color="#444444" size="22"/>run</button>
			<horizontal>
				<button id="refresh" width="100%" background="#9999CC,#EEEEFF,#aaaaff,10"><font color="#444444" size="15"/>refresh Experiments</button>
				<button id="quit" alignH="right" background="#9999CC,#EEEEFF,#aaaaff,10"><font color="#444444" size="15"/>quit</button>
			</horizontal>
		</vertical>
	
	</vertical>
		<vertical name="Sync" gapV="20" >
			<button id="dropboxSync" alignH="fill" height="60" background="#9999CC,#EEEEFF,#aaaaff,10"><font color="#444444"  size="22"/>dropbox</button>
			<button id="cloudSync" alignH="fill" height="60" background="#9999CC,#EEEEFF,#aaaaff,10"><font color="#444444"  size="22"/>cloud</button>
		<vertical   name="consolArea"   >
			<scrollVertical id = "debugScroller" mask="true" colour = "#ff0000" background = "#ffffff, #ffffff" gapV = "100" gapH = "100" alignH = "right"  visible = "true" border = "true" autoLayout = "true"> 	
				<label id="consol"  alignH="fill" ><font size="15"></font></label>
			</scrollVertical>
        </vertical>
     
  
	</vertical>
		<vertical  name="Admin" gapV="20" gapH="20" colour="#99CC99">
		<button id="killDropboxCreds" alignH="fill" height="60"  background="#9999CC,#EEEEFF,#aaaaff,10"><font color="#444444"  size="22"/>zap dropbox credentials</button>
		<button id="killCLoudCreds" alignH="fill" height="60" background="#9999CC,#EEEEFF,#aaaaff,10"><font color="#444444"  size="22"/>zap cloud credentials</button>
		<button id="killExpts" alignH="fill" height="60" background="#9999CC,#EEEEFF,#aaaaff,10"><font color="#444444"  size="22"/>delete Experiments!</button>
	</vertical>
</tabPagesTop>
 
				renderXML();
				stage.dispatchEvent(new Event(Event.RESIZE));	
				var tabPages:UITabPagesTop = UITabPagesTop(UI.findViewById("tabPages"));
				

		}
		
		
		
		private function wipeValues():void{
			_condition= '';
			_experimentToRun = '';
			_action = '';
			_experimentForAction = '';
		}
		
	
		protected function goForward(event:Event):void
		{
			wipeValues();
			_navigation.goToPage(1,UIPages.SLIDE_LEFT);
		}
		protected function goBackward(event:Event):void
		{
			wipeValues();
			_navigation.goToPage(0,UIPages.SLIDE_RIGHT);
		}
		
			
		private function listener(e:Event):void{
			
			if(e.target is UIButton){
				this.dispatchEvent(new Event((e.target as UIButton).name));
			}
			
			else if(e.target is UIMenu){
				
				var value:String = (e as MyEvent).parameters[1];
				switch((e.target as UIMenu).name){
					case 'Experiments':
						
						_experimentToRun=	value;
						setExptConditions(value);
					
						break;
					
					case 'condition':
						_condition = 		value;
						break;
					
					default:
						throw new Error('devel error, unexpected menu name');					
				}	
			}
	
		}	
		

	}
}