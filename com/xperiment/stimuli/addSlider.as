package  com.xperiment.stimuli{
	
	import com.bit101.components.Style;
	import com.dgrigg.minimalcomps.graphics.Shape;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.IResult;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	public class addSlider extends object_baseClass implements Imockable, IResult {
		
		public var track:uberSprite=new uberSprite  ;
		public var slider:uberSprite=new uberSprite  ;
		public var highVal:Number;
		public var sliderAxis:String;
		public var startVal:Number;
		public var changeProp:String;
		public var triangleTLD:uint;
		public var triangleHeight:uint;
		public var flipPointerFix:int;
		private var maxLabelHeight:uint=0;
		private var _labelList:Array;
		private var _labelLocation:Array;
		private var scale:uberSprite=new uberSprite  ;
		private var sliderMoved:Boolean=false;
		private var myTextFormat:TextFormat=new TextFormat  ;
		private var trackTouched:Boolean=false;
		public var overlay:Sprite;
		private var txtFields:Vector.<TextField> = new Vector.<TextField>;
		public var overrideResults:Function;
		private var backgroundClick:Shape;
		
		/*	<addSlider x="50%" y="45%" width="50%" height="10%"  
		sliderTitle="How intense is this odour?" percentageScreenSizeFrom="horizontal"  hidePointerAtStart="false" 
		labelList="not detectable&&very strong---completely unknown&&very familar---disgusting&&extremely pleasant" startVal="50" 
		labelLocation="0&&100"distBetweenLabelsAndScale="2" length="85%" pointerSize="5%" resultFileName="intensity---familiarity---pleasantness" />  */
		private var mouseDown:Boolean;
		private var disabled:Boolean = false;
		//private var scroll:Scroll;

		
		public function addSlider():void{
			uniqueEvents = new Dictionary;
			uniqueEvents["moved"]=true;
			uniqueEvents["updated"]=true;
			super();
		}
		
		
		
		override public function kill():void{
			
			removeListeners();
			//if(scroll)scroll.kill();
			for (var i:int=0;i<txtFields.length;i++){
				scale.removeChild(txtFields[i]);
				txtFields[i]=null;
			}
			txtFields=null
			overlay.removeChild(scale);
			scale=null;
			overlay.removeChild(track);
			track=null;
			overlay.removeChild(slider);
			slider=null;
			pic.removeChild(overlay);
			overlay=null;
			
			while(pic.numChildren>0)pic.removeChildAt(0);
			
			super.kill();
		}
		
		public function disable():void{
			this.disabled=true;
			removeListeners();
			if (getVar("hidePointerAtStart")){
				if(pic.hasEventListener(MouseEvent.MOUSE_DOWN))pic.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseWhenInvisible);
			}
			pic.buttonMode=false;
			pic.useHandCursor=false;
			
		}
		
		private function removeListeners():void{
			if(slider.hasEventListener(MouseEvent.MOUSE_MOVE))	slider.removeEventListener(MouseEvent.MOUSE_MOVE,movedL);
			if(pic.hasEventListener(MouseEvent.MOUSE_DOWN))pic.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
			if(slider.hasEventListener(MouseEvent.MOUSE_DOWN))slider.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseWhenInvisible);
			if(theStage && theStage.hasEventListener(MouseEvent.MOUSE_UP))theStage.removeEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
		}
		
		public function mock():void{
			sliderMoved=true;
			
			if(sliderAxis=='x'){
				slider.x=track.x+track.width*Math.random();
			}
			
			else if(sliderAxis=='y'){
				slider.y=track.y+track.height*Math.random();			
			}
		}
		
		//BEHAVIOURS:
		//mouseButtonUp
		override public function setVariables(list:XMLList):void {
			setVar("number","startVal",-1,"-1-100","-l means that the pointer is placed at a random location");
			setVar("string","sliderAxis","x","x||y");
			setVar("uint","pointerSize","60");
			setVar("uint","lineThickness",2);
			setVar("uint","triangleToLineDistance",5);
			setVar('number', 'triangleLineColour',Style.borderColour); 
			setVar("boolean","flipPointerOver",true);
			setVar("string","timer","false","false||allEvents","allEvents means the time that everytime the scale is interacted with");
			setVar("string","labelList","not detectable,very strong");
			setVar("string","labelLocation","","int,int,...int","seperate each % with ,");
			setVar("int","distBetweenLabelsAndScale",10);
			setVar("number","colour",0x111999);
			setVar("uint","fontSize",20);
			setVar("uint","titleSize",20);
			setVar("uint","textColour",Style.LABEL_TEXT);
			setVar("int","sf",2);
			//setVar("string","alignment","LEFT");
			setVar("uint","tagLength",5,"","the length of the dashes on the line scale");
			setVar("number","verticalJiggerTextPos",-12,"","allows you to shift the text position up and down");
			setVar("number","horizontalJiggerTextPos",-30,"","allows you to shift the text position left and right");
			setVar("number","sliderColour",Style.BUTTON_FACE);
			setVar("boolean","dontRecordWhenNoResponseMade",true);
			setVar("boolean","hidePointerAtStart",true);
			//setVar("int","scroll",0,"if this value is not zero, the scroll button will move the slider too. Each movement is multiplied by the value set here.");
			setVar("uint","backgroundClickBoxSize",30,"","the blank region around the scale where you can interact with the scale");
			setVar("string","lineColour",Style.BUTTON_FACE);
			setVar("string","sliderTitle","");
			setVar("uint","distBetweenScaleAndTitle",20);
			setVar("boolean","lockToLabels",false,"","forces your participants to select a value - no intermediary values");
			setVar("Number","unselectedValue",-100000);

			super.setVariables(list);	
			
			if(OnScreenElements.hasOwnProperty("labels")) 	OnScreenElements.labelList=OnScreenElements.labels;
			if(OnScreenElements.labelList=="")				OnScreenElements.labelList=" , ";
		}
		
		override public function returnsDataQuery():Boolean {
			return true;
		}
		
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('result')==false){
				uniqueProps.result= function():String{
						if(disabled) throw new Error("not allowed to request 'result' on a linescale when you had a dragTolineScale behaviour on it. peg="+peg+".");
						//AW Note that text is NOT set if what and to and null. 
						var score:String = myScore();
						if(score==getVar("unselectedValue").toString())return "''";
						return myScore();
					}; 	
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);;
		}


		private function myScore():String {
			var dat:Number;

			if (sliderMoved) {	

				dat=_getVal();
				if (getVar("lockToLabels")) {
					var currentVal:Number=nearestLabel(_getVal());
					dat=_labelList[_labelLocation.indexOf(currentVal)];
				}
			}
			else {
				
				dat = getVar("unselectedValue");
			}
			return String(dat);
		}
		
		protected function _getScore():Number{
			
			return Math.round(10000*_getVal()/getVar("length"))/100;
		}
		
		protected function _getVal():Number{
			var sf:int = getVar("sf");
			var score:Number = Math.abs(slider[sliderAxis]-(track[sliderAxis]/track[changeProp])) / highVal * 100;
			return codeRecycleFunctions.roundToPrecision(score, sf);
		}
		
		
		
		override public function storedData():Array {
			if(overrideResults){
				objectData=overrideResults()
				return objectData;
			}
			var tempData:Array=new Array  ;
			tempData.event=peg;
			
			tempData.data=myScore();
			
			objectData.push(tempData);
			
			return super.objectData;
		}
		
		public function isVertical():Boolean {
			if (sliderAxis=="x") {
				return false;
			}
			else {
				return true;
			}
		}
		
		override public function RunMe():uberSprite {
			pic.graphics.drawRect(0,0,1,1);
			super.setUniversalVariables();
			overlay=new Sprite;
			assignVariables();
			createSlider();
			composeLabels();
			if (getVar("lockToLabels")) lockToL();
			//if(int(getVar("scroll"))!=0) scroll = new Scroll(theStage, modSliderPos,getVar("scroll"));
			pic.scaleX=1;
			pic.scaleY=1;
			pic.addChild(overlay);
			if(sliderAxis=="x"){
				overlay.y=pic.myHeight*.5-overlay.height*.5;
			}
			else{
				overlay.x=pic.myWidth*.5;
				overlay.y-=triangleHeight;
			}
			return pic;
		}
		
		private function modSliderPos(pos:int):void{
			slider[sliderAxis]+=pos;
			if(slider[sliderAxis]>highVal)slider[sliderAxis]=highVal;
			else if(slider[sliderAxis]<0)slider[sliderAxis]=0;
			//slider.startDrag(false,new Rectangle(0,0,0,highVal));
		}
		
		
		protected function sortList():Array{
			return (getVar("labelList") as String).split(",");
		}
		
		protected function sortLocations():Array{
			var str:String=getVar("labelLocation");
			var arr:Array;
			
			if(str==''){
				arr=[];

				for(var i:int=0;i<_labelList.length;i++){
					arr.push(i/(arr.length-1)*100)
					if(arr[arr.length-1]==Infinity)arr[arr.length-1]=100;
				}
				
			}
			else{
				str=str.split("%").join('');
				arr=str.split(",");
			}

			return arr;
		}
		
		public function assignVariables():void {
			
			
			_labelList=sortList();
			_labelLocation = sortLocations();
			

			
			sliderAxis=(getVar("sliderAxis") as String).toLowerCase();
			
			if(sliderAxis == 'x') OnScreenElements.length=pic.width;
			else OnScreenElements.length=pic.height;
			highVal=getVar("length");
			startVal=getVar("startVal");
			triangleTLD=getVar("triangleToLineDistance");
			triangleHeight=getVar("pointerSize");
			//trace(1111111,getVar("pointerSize"));
			flipPointerFix=0;
			if (getVar("flipPointerOver")==true) {
				flipPointerFix=-1;
			}
		}
		
		
		public function createTriangle(col:Number,size:uint):uberSprite {
			var tempTriangle:uberSprite=new uberSprite  ;
			tempTriangle.graphics.lineStyle(getVar('lineThickness'),getVar('triangleLineColour'));
			tempTriangle.graphics.beginFill(col);
			if (sliderAxis=="x") {
				tempTriangle.graphics.moveTo(0,size);
				tempTriangle.graphics.lineTo(size/2,size*flipPointerFix+size);
				tempTriangle.graphics.lineTo(-size/2,size*flipPointerFix+size);
				tempTriangle.graphics.lineTo(0,size);
			}
			else {
				
				tempTriangle.graphics.moveTo(0,size);
				tempTriangle.graphics.lineTo(size*flipPointerFix,- size/2+size);
				tempTriangle.graphics.lineTo(size*flipPointerFix,size/2+size);
				tempTriangle.graphics.lineTo(0,size);
			}
			return tempTriangle;
		}
		
		public function createSlider():void {
			track.graphics.lineStyle(getVar("lineThickness"),getVar("lineColour"));

			
			if (sliderAxis=="x") {
				track.graphics.lineTo(highVal,0);
				track.graphics.moveTo(triangleHeight/2,0);

			}
			else {
				track.graphics.lineTo(0,highVal);
				track.graphics.moveTo(0,-triangleHeight/2);
			}
			

			slider=createTriangle(getVar("sliderColour"),getVar("pointerSize"));
			
			
			if (getVar("hidePointerAtStart")){
				backgroundClick = new Shape;
				backgroundClick.graphics.beginFill(0x000000,0);
				backgroundClick.graphics.drawRect(0,0,pic.myWidth,pic.myHeight);
				pic.addChildAt(backgroundClick,0)
				slider.visible=false;
				if(!disabled)pic.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseWhenInvisible);
				pic.buttonMode=true;
				pic.useHandCursor=true;
			}
			else{
				slider.visible=true;
				if(!disabled)slider.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
			}
			
			changeProp=sliderAxis=="x"?"width":"height";
			slider.buttonMode=true;
			
			if (getVar("startVal")==-1) {
				startVal=Math.random()*100;
			}
			
			startVal=highVal*startVal/100;
			
			if (sliderAxis=="x") {
				slider.x=track.x*track[changeProp]+startVal;
			}
			else {
				slider.y=track.y*track[changeProp]+startVal;
				slider.y=slider.y-startVal;
			}
			
			track.y=track.y+getVar("pointerSize");
			overlay.addChild(track);
			overlay.addChild(slider);
			overlay.addChild(scale);
			
			
			if(theStage)theStage.addEventListener(MouseEvent.MOUSE_UP,handleMouseUp);
		}
		
		private function handleMouseWhenInvisible(e:MouseEvent):void {
			pic.removeChild(backgroundClick);
			backgroundClick=null;
			pic.removeEventListener(MouseEvent.MOUSE_DOWN,handleMouseWhenInvisible);
			pic.buttonMode=false;
			pic.useHandCursor=false;
			slider.visible=true;

			
			if (sliderAxis=="x") {
				slider.x=e.localX;
			}
			else {
				slider.y=e.localY;
			}
			
			handleMouseDown(e);
			slider.addEventListener(MouseEvent.MOUSE_DOWN,handleMouseDown);
		}
		
		
		private function handleMouseDown(e:MouseEvent):void {
			sliderMoved=true;
			mouseDown=true;
			slider.addEventListener(MouseEvent.MOUSE_MOVE,movedL);
			if (sliderAxis=="x") {
				slider.startDrag(false,new Rectangle(0,0,highVal,0));
			}
			else {
				slider.startDrag(false,new Rectangle(0,0,0,highVal));
			}
		}
		
		protected function movedL(e:MouseEvent):void
		{
			this.dispatchEvent(new Event("moved"));
		}
		
		/**
		 * Stops the slider dragging and timer.
		 */
		private function handleMouseUp(e:MouseEvent):void {
			if(mouseDown){
				
				
				
				this.dispatchEvent(new Event("updated"));
				if (getVar("lockToLabels")) lockToL();
				slider.stopDrag();
			}
			mouseDown=false;
		}
		
		private function lockToL():void{
			if (getVar("sliderAxis")=="x") {
				slider.x=nearestLabel(slider.x);
			}
			else {
				slider.y=nearestLabel(slider.y);
			}
		}
		
		private function nearestLabel(pos:int):int {
			var returnMe:int=pos;
			var min:int=1000000;
			for (var i:uint=0; i<_labelLocation.length; i++) {
				if (min>Math.sqrt(Math.pow(_labelLocation[i]-pos,2))) {
					min=Math.sqrt(Math.pow(_labelLocation[i]-pos,2));
					returnMe=_labelLocation[i];
				}
			}
			return returnMe;
		}
		
		public function composeLabels():void {
			
			scale.graphics.lineStyle(getVar("lineThickness"),getVar("lineColour"));
			var tagL:int=getVar("tagLength");
			
			myTextFormat.size=getVar("fontSize");
			myTextFormat.color=getVar("textColour");
			
			for (var i:uint; i<_labelLocation.length; i++) {
				_labelLocation[i]=codeRecycleFunctions.roundToPrecision(highVal-(100-_labelLocation[i])/100*highVal,2);
				//has to round up as we've had to bodge _labelLocation[i] by subtracting 100 to get the right positioning.
				
				if (getVar("sliderAxis")=="x") {
					scale.graphics.moveTo(_labelLocation[i],- tagL/2+getVar("pointerSize"));
					scale.graphics.lineTo(_labelLocation[i],+ tagL/2+getVar("pointerSize"));
				}
				else {
					scale.graphics.moveTo(- tagL/2,_labelLocation[i]+getVar("pointerSize"));
					scale.graphics.lineTo(+ tagL/2,_labelLocation[i]+getVar("pointerSize"));
				}
			}
			for (i=0; i<_labelList.length; i++) {
				var tempTextField:TextField=scaleLabel(_labelList[i]);

				tempTextField.mouseEnabled=false;
				
				
				if (getVar("sliderAxis")=="x") {
					tempTextField.x=_labelLocation[i]-(tempTextField.width/2);
					tempTextField.y=getVar("distBetweenLabelsAndScale")+getVar("pointerSize");
				}
				else {
					tempTextField.autoSize = TextFieldAutoSize.LEFT
					tempTextField.y=_labelLocation[i]+getVar("verticalJiggerTextPos")+getVar("pointerSize");
					tempTextField.x=getVar("distBetweenLabelsAndScale");
				}
				
				tempTextField.setTextFormat(myTextFormat);
				
				if (tempTextField.height>maxLabelHeight) {
					maxLabelHeight=tempTextField.height;
				}
				txtFields[txtFields.length]=tempTextField;
				scale.addChild(tempTextField);
				
			}
			
			if (getVar("sliderTitle")!="") {
				tempTextField= new TextField;
				tempTextField.textColor=getVar("textColour");
				tempTextField=scaleLabel(getVar("sliderTitle"));
				tempTextField.mouseEnabled=false;
				myTextFormat.size=getVar("titleSize");
				tempTextField.setTextFormat(myTextFormat);
				if (getVar("sliderAxis")=="x") {
					tempTextField.x=highVal-50/100*highVal-(tempTextField.width/2);
					tempTextField.y=getVar("distBetweenScaleAndTitle")+getVar("pointerSize");
				}
				else {
					tempTextField.y=highVal-50/100*highVal+getVar("verticalJiggerTextPos")+getVar("pointerSize");
					tempTextField.x=getVar("distBetweenScaleAndTitle");
				}
				scale.addChild(tempTextField);
				txtFields[txtFields.length]=tempTextField;
			}
			
		}
		
		
		public function scaleLabel(t:String):TextField {
			var tt:TextField=new TextField  ;
	
			tt.textColor=Style.LABEL_TEXT;
			tt.text=t;
			tt.autoSize=TextFieldAutoSize.CENTER;
			tt.selectable=false;
			return tt;
		}
	}
	
	

}

