package com.Start.MobilePlayerStart.view
{
	/**
	 Class PlayerView 
	 Author :  Samit Basak.
	 Last Modified : 23Nov2013 at 9:30PM ( IST )
	 */
	import com.Start.MobilePlayerStart.ExptInfo;
	import com.danielfreeman.extendedMadness2.UITabPagesTop2;
	import com.danielfreeman.extendedMadness2.UIe2;
	import com.danielfreeman.madcomponents.UI;
	import com.danielfreeman.madcomponents.UIButton;
	import com.danielfreeman.madcomponents.UIForm;
	import com.danielfreeman.madcomponents.UIInput;
	import com.danielfreeman.madcomponents.UILabel;
	import com.danielfreeman.madcomponents.UIList;
	import com.danielfreeman.madcomponents.UIScrollVertical;
	import com.danielfreeman.madcomponents.UIWindow;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	public class PlayerView extends Sprite
	{
		
		public static var LIST_TEXT_LENGTH:uint = 200;
		
		
		[Embed(source = "/assets/splash.png")]
		protected static const SPLASH_IMG:Class;
		[Embed(source = "/assets/logo.png")]
		protected static const LOGO_IMG:Class;
		[Embed(source="/assets/red.png",
		scaleGridTop="10", scaleGridBottom="34",
      	scaleGridLeft="10", scaleGridRight="104")]
		protected static const RED_IMG:Class;
		
		private static var PAGE1:XML = <vertical gapV="80" alignH="fill"  alignV="fill">
		
<scrollVertical>		   
		<horizontal>
		<image>{getQualifiedClassName(LOGO_IMG)}</image>
		<label><font color="#ffffdd" type="bold" size="20"/>Xperiment lets you take part in research from all corners of the world.  Simply click on the research-link you received. Material for the study will download and the experiment will start automatically.
		</label></horizontal>
		<group  background="#dddddd"><label><font color="#333333"  size="30"><b>You are seeing this screen as you have run Xperiment directly. This app is normally run via a link given to you by a scientist, which then runs the desired Experiment automatically.  May we suggest you check whether there are any currently available studies under the 'Experiments' tab?
		</b></font></label></group>
		<label id="detal_label" ><font color="#dddddd" size="16">
The Xperiment app lets scientists run studies that are simply not possible on the web. The app lets the scientist use  your devices features such as vibration, touchscreen and tilt, opening up some novel ways of furthering science.
As with Xperiment’s web research, only studies that follow our strict guidelnes may be run your smartphone. Studies permited to run on your device:
		1. must have been granted local ethical approval or have been classfied as being exempt from local ethical approval,
		2. are compliant with ‘Ethical principles for medical research involving human subjects’ of Helsinki Declaration (World Medical Association, 2004)
		3. must be approved by Xperiment.mobi. 
The above, and relevant local laws, impose a strict set of rules the scientist must adhere to, regarding conduct and the collection and storage of personal information. The American Psychological Association, for example, require that Scientists ‘code data to hide identities’. Scientists MUST request permission to collect any personal information critical to their research. The scientist must also specify where and how this information is stored.
If you suspect an experiment does not adhere to any of  the above policies, please contact us immediately at ethics@xperiment.mobi. Thankyou.
		</font></label></scrollVertical>
		</vertical >;
		
		private static var SUBPAGE:XML=<vertical  autoLayout="true" id="background" >
											<horizontal>
												<button id="dostudy" skin={getQualifiedClassName(RED_IMG)} height="40">do study</button>
												<button alignH="right" id="popup_back" skin={getQualifiedClassName(RED_IMG)} height="40">back</button>
											</horizontal>
											<scrollVertical id="dynamic_vc" mask="true" scrollBarColour="#ffffff" autoLayout="true" alignV="scroll"   border="false" >
												<vertical gapV="0" alignH="fill"  alignV="fill"  border="true" autoLayout="true">
													<input id="inputText" prompt="url" visible="false" alignH="fill" alignV="fill"  autoLayout="true" background='#FFFFFF,#FFFFFF,#FFFFFF' />													
													<label id="popup_content" alignH="fill" alignV="fill"  autoLayout="true"  colour="#fffff"/>
												</vertical>
											</scrollVertical>
										</vertical>;

		
		private static var PAGE2:XML=<vertical id="page2" border="false">
			   <columns widths="0%,100%">
				<label/>
				<vertical border="true"  >
				 <rows autoLayout="true" alignV="fill" heights="100%">
				   <vertical  border="false" alingH="fill"  >
								<list  id="list0" highlightPressed="false" border="false" autoLayout="true" alingH="fill" lines="false" mask="true" colour="#cccccc"   background="#eeeeee,#eeeeee,#eeeeee">
										  <label  id="label" height="100" />	
								</list>
														
				   </vertical>
	
				 </rows>
			   </vertical>
			   </columns>
		</vertical>;
		private static var VIEW_FLIPPER:XML = <tabPagesTop2 id="tabPages">
		
			  {PAGE1}
		 {PAGE2}
		
		  
			</tabPagesTop2>;
		
		public var study_selected:int;
		public var exptSelected:ExptInfo;
		
		private var _dynamic_list:UIList;
		private var theStage:Stage;
		private var _tileBg:TileBackgroundFiller;
		private var _popup:UIWindow;
		private var _popup_back:UIButton;
		private var _popup_dostudy:UIButton;
		private var _inputPut:UIInput;
		private var _popup_label:UILabel;
		private var _resize:Boolean = false;
		private var _experiments_list:Array = [];
		private var _currentData:Array;
		private var _pane:Sprite;
		private var _tabPages:UITabPagesTop2;
		private var abbrevDescripts:Array = []; 
		private var expts:Vector.<ExptInfo> = new Vector.<ExptInfo>;
		private var t:Timer;

		
		/**
		 Constructor 
		 class name : PlayerView;
		 */
		
		public function kill():void{
			if(t)t.stop();
			
			_inputPutL(false);
			
			for each(var expt:ExptInfo in expts){
				expt.kill();
			}
			expts=null;
			
			UI.clear();
			UIe2.kill();
			UI.kill();
			
			
			this.stage.removeEventListener(Event.RESIZE,stageOrientationChanged);
			
			this.removeChild(_pane);
			this.removeChild(_tileBg);
			
			theStage.removeChild(this);
			
			if(_popup_back)_popup_back.removeEventListener(UIButton.CLICKED, backToList);
			if(_popup_dostudy)_popup_dostudy.removeEventListener(UIButton.CLICKED, doStudy);
			if(_dynamic_list)listListeners(false);
			_tileBg.removeEventListener("tileAdded", renderContent);	
			
			_dynamic_list = null;
			_tileBg = null;
			_popup = null;
			_popup_back = null;
			_popup_dostudy = null;
			_popup_label = null;
			_inputPut=null;
			_experiments_list = null;
			_currentData = null;
			_pane = null;
			_tabPages = null;
		}
		
		public function PlayerView(stage:Stage)
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.theStage = stage;
			theStage.addChild(this);
		
				
			_tileBg = new TileBackgroundFiller(0x333333,2);
			addChild(_tileBg);
			_tileBg.addEventListener("tileAdded", renderContent);
			_tileBg.drawImage();
			this.stage.addEventListener(Event.RESIZE,stageOrientationChanged);
			
		}
		
		/**
		 redrawn :: function to redraw the popup and dynamic list
		 */
		private function redrawn():void
		{		
			if(_popup) drawPopupNow();		
			_dynamic_list.doLayout();	
		}
		

		
		/**
		 stageOrientationChanged - event handler called when stage orientation is changed 
		 
		 */
		private function stageOrientationChanged(evt:Event):void
		{		
			//ugly hack. not happy with this
			//if(_dynamic_list)_dynamic_list.showScrollBar();
			
			//_dynamic_list.hack();
			
			_resize = true;
			_tileBg.drawImage();
		}
		
		/**
		 renderContent - render the content of the application 
		 */
		private function renderContent(e:Event):void
		{
			if(!_resize)
			{	
				_pane = new Sprite;
				addChild(_pane);
				UIe2.create(_pane,VIEW_FLIPPER);				
				_dynamic_list = UIList(UI.findViewById("list0"));				
				_dynamic_list.clickRow = true;				
				_dynamic_list.showPressed= false;				
				_dynamic_list.buttonMode = true;	
				populateList(_experiments_list);				
				_dynamic_list.longClickEnabled = true;				
				listListeners(true);
				_tabPages = UITabPagesTop2(UI.findViewById("tabPages"));
				_tabPages.setTab(0, "About",null);
				_tabPages.setTab(1, "Experiments",null);
				
			} 
			else redrawn();
		}
		
		private function listListeners(ON:Boolean):void{
			var f:Function;
			if(ON)	f=_dynamic_list.addEventListener
			else	f=_dynamic_list.removeEventListener
			
			if(_dynamic_list.hasEventListener(UIList.CLICKED)==!ON){
				f(UIList.CLICKED, listClicked);						
				f(UIList.CLICKED_END, clickEnd);
			}
			
		}
		
		/**
		 clickEnd - click ended for dynamic list
		 */
		private function clickEnd(evt:Event):void
		{
			_dynamic_list.showPressed= false;
		}
		
		
		/**
		 populateList - function to populate the list content to the dynamic list
		 */
		private function populateList(expt_list:Array):void
		{
			_dynamic_list.data = abbrevDescripts;
			_dynamic_list.doLayout();
		}
		
		/**
		 backToList - back to the list from the open popup
		 */
		public function backToList(evt:Event):void
		{
			if(_dynamic_list){
				listListeners(true);
				_dynamic_list.clearPressed(true);
			}
			if(_popup)UI.hidePopUp(_popup);
		}
		
		/**
		 listClicked - listClicked event handler for dynamicList
		 */
		private function listClicked(e:Event=null):void
		{
			if(_tabPages.pageNumber==1 ){

				listListeners(false);
				exptSelected = expts[_dynamic_list.index]
		
				if (! _popup){
					_popup = UIWindow(UI.createPopUp(SUBPAGE,-1,-1,10));
					
					//UIWindowExtended(_popup);
					_popup.drawBackground(Vector.<uint>([0x666666,0x333333,0x00,0x000,0xff0000]) );
					
					_popup_back = UIButton(_popup.findViewById("popup_back"));
					_popup_label = UILabel(_popup.findViewById("popup_content"));
					_popup_dostudy = UIButton(_popup.findViewById("dostudy"));
					
					
					_inputPutL(false);
					_inputPut = UIInput(_popup.findViewById("inputText"));
					_inputPutL(true);
					_popup_back.addEventListener(UIButton.CLICKED, backToList);
					_popup_dostudy.addEventListener(UIButton.CLICKED, doStudy);

					
					drawPopupNow();	
					_popup.visible=false;
				}
				
				if(_popup.visible==false){
					
					_popup.visible=true;
					UI.showPopUp(_popup);
					var dynamic_vc:UIScrollVertical = UIScrollVertical(_popup.findViewById("dynamic_vc"));
					var tf:TextFormat = _popup_label.defaultTextFormat;
					tf.color = 0xffffff;
					if(exptSelected.input){
						_inputPut.visible=true;
					}
					else _inputPut.visible=false;
					tf.size=18;
					_popup.doLayout();
					_popup_label.defaultTextFormat = tf;
					
					
					_popup_label.htmlText = exptSelected.html();
					//dynamic_vc.doLayout();
				}
				
				if(exptSelected.button)_popup_dostudy.text=exptSelected.button;
				else _popup_dostudy.text="do study";
			}
		}
		
		private function _inputPutL(ON:Boolean):void
		{
			if(_inputPut){
				

				if(ON ){
					t ||= new Timer(1000,1);
					t.addEventListener(TimerEvent.TIMER,buttonL);
					_inputPut.addEventListener(MouseEvent.MOUSE_DOWN,buttonL);
					_inputPut.addEventListener(MouseEvent.MOUSE_UP,buttonL);
				}
				else{
					t.removeEventListener(TimerEvent.TIMER,buttonL);
					_inputPut.removeEventListener(MouseEvent.MOUSE_DOWN,buttonL);
					_inputPut.removeEventListener(MouseEvent.MOUSE_UP,buttonL);
				}
			}
		}
		
		protected function buttonL(e:Event):void
		{

			if(e.type==MouseEvent.MOUSE_DOWN){
				t.reset();
				t.start();
				
			}
			else if(e.type==MouseEvent.MOUSE_UP){
				t.stop();
			}
			
			else if(e.type==TimerEvent.TIMER){
				_inputPut.text = Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT) as String; 
			}
		}
		
		/**
		 drawPopupNow - function to open the popup
		 */
		private function drawPopupNow():void
		{
			var page2:UIForm = UIForm(UI.findViewById("page2"));
			
			var padding:uint=20;
			_popup.x=padding;
			_popup.y =padding +_tabPages.buttonBarHeight;
			
			_popup.attributes.width   = page2.attributes.width-padding*2;
			_popup.attributes.height = page2.attributes.height-2*padding;
			_popup.drawBackground(Vector.<uint>([0x666666,0x333333,0x00,0x000,0xff0000]) );
			
			_popup.doLayout();
		}
		
		/**
		 doStudy - event handler for buttne event doStudy
		 */
		private function doStudy(e:Event):void
		{
			if(exptSelected.runnable)	this.dispatchEvent(new Event(Event.COMPLETE));
			
			else if(exptSelected.funct){
				
				if(exptSelected.funct.length==0)	exptSelected.funct();
				if(exptSelected.funct.length==2){ //hacky!
					
					exptSelected.funct(_inputPut.text,function(str:String):void{
						_inputPut.text=str;
						if(str.indexOf("http")!=-1)((_inputPut.inputField) as TextField).setSelection(str.length-2,str.length-1);
					});
					return;
				}
			}
			backToList(null);
		}
		

		public function addExpt(expt:ExptInfo):void
		{		
			expts.push(expt);
			
			abbrevDescripts = [];
			var info:String;
			
			for(var i:int=0;i<expts.length;i++){
				abbrevDescripts.push({label:expts[i].abbrevHTML(400)});
			}
			_dynamic_list.data = abbrevDescripts;
		}	
		
	
		
	}
}