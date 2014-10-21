package com.xperiment.stimuli.primitives.P2P_UI
{
	import com.bit101.components.List;
	import com.bit101.components.Style;
	import com.dgrigg.minimalcomps.graphics.Shape;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.xperiment.stimuli.primitives.BasicButton;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class P2P_UI_Peer extends Sprite
	{	
		public static var RUN_STUDY:String = 'run study';
		public var verticalHeight:int = 60;
		public var toService:Function;
		private var passwordSpr:Sprite = new Sprite;

		private var experimenterSpr:Sprite = new Sprite;
		private var message:TextField
		private var animation:TweenMax;
		private var password:TextField;
		private var messages:TextField;
		private var list:List;
		private var tf:TextFormat = new TextFormat(null,20);
		
		private var startStudy:BasicButton;
		private var listOfStudies:Array = [];
		private var waitingSha:Sprite;
		public var myWidth:int;
		public var myHeight:int;

		
		public function P2P_UI_Peer(width:int,height:int)
		{
			this.myWidth=width;
			this.myHeight=height;
			setup();
			
		}
		
		public function fromService(obj:Object):void{
		
			switch(obj.command){
				case 'expt added':
					peerL_hereListStudies([obj]);
					break;
				case 'closeUI':
					kill_initial_screen();
					start_linked_screen();
					break;
				case 'downloaded stimuli':
					generateMessage("(finished downloading data).");
					break;
				default: throw new Error();
			}
			
		}
		
		public function commsService(obj:Object):void{
			if(toService)toService(obj);
		}

		public function setup():void
		{
			addExperimenterPassword();
			this.addChild(passwordSpr);
			
			addExperimenter();
			this.addChild(experimenterSpr);
			experimenterSpr.y+=verticalHeight*1.5+passwordSpr.y;
			
			addStartStudy();
			this.addChild(startStudy);
			//startStudy.y=experimenterSpr.y;
			startStudy.x=myWidth-startStudy.width;
			addComboBox();
			this.addChild(list);
			list.y=verticalHeight*2+experimenterSpr.y;
			list.height=verticalHeight*2+experimenterSpr.y;
		}
		
		private function addStartStudy():void
		{
			startStudy = new BasicButton;
			startStudy.label.text="run selected study";
			startStudy.myWidth=password.width;
			startStudy.myHeight=password.height;
			startStudy.enabled=false;
			startStudy.init();
			startStudy.addEventListener(MouseEvent.CLICK,runStudyL);
		}
		
		protected function runStudyL(e:MouseEvent):void
		{
			checkPassword(null);
		}
		
		private function addExperimenter():void
		{
			
			message = new TextField;
			message.textColor = Style.LABEL_TEXT;
			message.defaultTextFormat = tf;
			message.text = "Waiting for Scientist (click ball to try again)";
			message.multiline=true;
			message.width=myWidth;
			message.wordWrap=true;
			experimenterSpr.addChild(message);
			message.autoSize = TextFieldAutoSize.LEFT;
			startAnimation(message.width,experimenterSpr);
			
		}
		
		private function startAnimation(w:int,parent:Sprite):void{
			waitingSha = new Sprite();
			var mat:Matrix = new Matrix;
			mat.createGradientBox(2*10,2*10,0,-10+2,-10-2);
			waitingSha.graphics.beginGradientFill(GradientType.LINEAR,[0x000000,0xffffff],[1,1],[0,255],mat);
			waitingSha.graphics.drawCircle(0,0,10);
			parent.addChild(waitingSha);
			waitingSha.scaleY=waitingSha.scaleX=3;
			waitingSha.y=5-waitingSha.height*.5;
			var across:int =myWidth-waitingSha.scaleX*waitingSha.width;
			animation = TweenMax.to(waitingSha, 2, {rotation:360,x:across,ease:Back.easeInOut, repeat:-1, yoyo:true});
			
			waitingSha.addEventListener(MouseEvent.CLICK,ballClickedL);
			
		}
		
		protected function ballClickedL(e:MouseEvent):void
		{
			commsService({command:"reset comms"});
			stopAnimation();
			startAnimation(message.width,experimenterSpr);
		}
		
		public function stopAnimation():void{
			if(animation){
				waitingSha.removeEventListener(MouseEvent.CLICK,ballClickedL);
				animation.kill();
			}
			
			if(waitingSha && waitingSha.parent)waitingSha.parent.removeChild(waitingSha);
		}
		
		public function peerL_hereListStudies(studies:Array):void{
			
			stopAnimation();
			
			var inList:Boolean;
			
			var pwordNeeded:Boolean = false;
			for(var i:int = 0;i<studies.length;i++){
				if(studies[i].password.length>0)pwordNeeded=true;
				if(list.items.indexOf(studies[i].studyName)==-1){
					list.addItem(studies[i].studyName);
				}
				passwordSpr.visible=pwordNeeded;
				inList=false;
				
				for each(var study:Object in listOfStudies){
					if(study.studyName==studies[i].studyName)inList==true;
				}
				if(inList==false){
									
					listOfStudies.push(studies[i]);
				}
			}
		}
		
		private function addComboBox():void
		{
			
			
			list = new List(null);
			list.width=myWidth;
			
			list.addEventListener(Event.SELECT,function(e:Event):void{
					startStudy.enabled=true;
				});
			
			
			for each(var item:String in []){
				list.addItem(item);
			}
		}	
		
		
		
		private function addExperimenterPassword():void
		{
			
			
			passwordSpr.graphics.lineStyle(Style.borderWidth,Style.borderColour,1);
			passwordSpr.graphics.beginFill(Style.BACKGROUND,.8);
			
			var passwordTxt:TextField = new TextField;
			passwordTxt.textColor = Style.LABEL_TEXT;
			passwordTxt.autoSize = TextFieldAutoSize.RIGHT;
			
			passwordTxt.text = "password:";
			passwordTxt.setTextFormat(tf);
			passwordSpr.addChild(passwordTxt);
			
			password = new TextField;
			password.defaultTextFormat=tf;

			password.type = TextFieldType.INPUT;
			password.displayAsPassword=true;
			password.background=true;
			password.backgroundColor=Style.BACKGROUND;
			password.width=myWidth*.3;
			password.height=verticalHeight;
			password.textColor=Style.INPUT_TEXT;
			passwordSpr.addChild(password);
			password.x=passwordSpr.x+passwordSpr.width+50;
			password.addEventListener(KeyboardEvent.KEY_UP,checkPassword);
			
			passwordTxt.y=passwordSpr.height*.5-passwordTxt.height*.5

			
			passwordSpr.graphics.drawRoundRect(0,0,myWidth*.5-20,verticalHeight,10,10);
			//passwordSpr.x=myWidth-passwordSpr.width;
			//passwordTxt.x=passwordSpr.x-passwordTxt.width;
			
			var border:Shape = new Shape;
			border.graphics.lineStyle(Style.borderWidth,Style.borderColour,1);
			border.graphics.drawRoundRect(0,0,this.width,verticalHeight,10,10);
			passwordSpr.addChild(border);
			passwordSpr.visible=false;
			
			
		}
		
		private function checkPassword(e:KeyboardEvent):void
		{
			
			var 	code:int = 13;		// automatically 'enter' if this driven by 'run selected study' button
			if(e)	code = e.charCode   // if the key is ENTER
			
			var exptID:String;
	
			if(code == 13 && startStudy.enabled==true){
				var selected:String = list.selectedItem.toString();
				var passwordStr:String;
				for(var i:int=0;i<listOfStudies.length;i++){

					if(listOfStudies[i].studyName==selected){
						passwordStr=listOfStudies[i].password;
						exptID=listOfStudies[i].exptID;
					}
				}
				
				if(password.text==passwordStr){
					commsService({"command":"study selected",exptID: exptID});
					
				}
				else{
					animation = TweenMax.to(passwordSpr,.3,{tint:0xFF0000, repeat:1, yoyo:true});
					password.text='';
				}
			}			
		}
		

		
		
		public function kill_initial_screen():void
		{
			password.removeEventListener(KeyboardEvent.KEY_UP,checkPassword);
			stopAnimation();
			this.removeChild(passwordSpr);
			this.removeChild(startStudy);
			this.removeChild(list);
			generateMessage("(downloading data).")
			list = null;
		}
		
		private function generateMessage(extra:String):void{
			message.text="Connected! Waiting for Experimenter to start study "+extra;
		}
		
		public function kill():void{
			stopAnimation();
			if(messages)this.removeChild(messages);
		}

		public function peerMessage(message:String):void
		{
			messages.text = message;
		}
		
		public function start_linked_screen():void
		{
			
			startAnimation(this.width,this);
			messages = new TextField;
			messages.width=150;
			messages.height=100;
			messages.wordWrap=true;
			this.addChild(messages);
			messages.textColor = Style.LABEL_TEXT;
			
			messages.y=waitingSha.height+10;
			
		}
	}
}