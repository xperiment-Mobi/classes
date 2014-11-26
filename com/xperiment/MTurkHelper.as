package com.xperiment
{
	import com.greensock.TweenLite;
	import com.xperiment.trial.Trial;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	
	public class MTurkHelper extends Sprite
	{
		private var doQuit:Boolean = false;
		private const successMessage:String = "When ready please return to your Hit window in MTurk and enter the above password. We appreciate your help in this study. Thankyou.";
		//private const failMessage:String = 'There has been a problem submitting your HIT to mechanical Turk. Please return to MTurk and follow our instructions. Apologies.';
		private static var instance:MTurkHelper;
		
		//private var success:Boolean;
		private var theStage:Stage;
		private var quit:Sprite;
		private var down:Boolean=false;
		private var pword:TextField, band:TextField;
		
		public function MTurkHelper(s:Stage,id:String)
		{
			theStage = s;
			theStage.addChild(this);
			//success = succ;
			
			pword = new TextField;
			pword.defaultTextFormat= new TextFormat(null,40,0x333333,null,null,null,null,null,TextFormatAlign.CENTER);
			pword.wordWrap=true;
			pword.width=Trial.ACTUAL_STAGE_WIDTH;
			pword.autoSize=TextFieldAutoSize.LEFT;
			pword.htmlText = getPassword(id);
			this.addChild(pword);
			
			band = new TextField;
			band.defaultTextFormat= new TextFormat(null,15,0x333333,null,null,null,null,null,TextFormatAlign.CENTER);
			band.wordWrap=true;
			band.width=Trial.ACTUAL_STAGE_WIDTH;
			band.autoSize=TextFieldAutoSize.LEFT;
			var str:String ="mturk pword: "+pword.text 
			band.htmlText = str + "       " + str + "       " + str + "       " + str + "       " + str + "       " + str;
			this.addChild(band);
			
			var col:int;
			var txt:TextField = new TextField;
			txt.defaultTextFormat = new TextFormat(null, 20, 0x333333);
			txt.wordWrap = true;
			txt.width = Trial.ACTUAL_STAGE_WIDTH;
			txt.autoSize = TextFieldAutoSize.CENTER;
	
			col = 0x00ff00;

			var quitText:String = '';
			if(doQuit)quitText=" (press 'x' top-right corner to remove this message)";
			txt.htmlText=successMessage+"\n\n<b>Click this bar to hide this message"+quitText+".  Press Escape to return to your browser (if running the study fullscreen).</b>";
			
			
			this.graphics.beginFill(col,.9);
			this.graphics.drawRect(0,0,Trial.ACTUAL_STAGE_WIDTH,Trial.ACTUAL_STAGE_HEIGHT*.5);
			this.y=Trial.ACTUAL_STAGE_HEIGHT;
			this.mouseEnabled=true;
			this.addChild(txt);
			//txt.x=this.width*.5-txt.width*.5;
			pword.y=this.height*.25-pword.height*.5;
			band.y=Trial.ACTUAL_STAGE_HEIGHT*.5-band.height;
			txt.y=this.height*.5-txt.height*.5;
			txt.mouseEnabled=false;
			
			if(doQuit){
				quit = new Sprite;
				var x:TextField = new TextField();
				x.defaultTextFormat = new TextFormat(null,30);
				x.text = '☒';
				x.autoSize=TextFieldAutoSize.LEFT;
				quit.addChild(x);
				this.addChild(quit);
				quit.x=this.width-quit.width;
			}
			
			
			midway();
			listeners(true);

		}
		
		private function getPassword(id:String):String
		{
			var s1:int = 0;
			var s2:int = 0;
			var tempInt:int;
			for (var i:uint=0; i<id.length; i++)
			{
				tempInt = id.charCodeAt(i);
				s1+=Math.floor(tempInt/10);
				s2+=tempInt-(Math.floor(tempInt*.1)*10);
			}
			return String(s1+s2);
		}
		
		private function midway():void{
			TweenLite.to(this,.5,{y:Trial.ACTUAL_STAGE_HEIGHT*.5,x:0});
		}
		
		private function listeners(YES:Boolean):void
		{

			if(theStage.hasEventListener(Event.ADDED)){
				if(YES==false)
					theStage.removeEventListener(Event.ADDED, sortDepth);
			} 
			else if(YES==true){
				theStage.addEventListener(Event.ADDED, sortDepth);
			}
			
			if(YES){
				this.addEventListener(MouseEvent.CLICK,updownL);
				if(quit)	quit.addEventListener(MouseEvent.CLICK,kill);
			}
			else{
				this.removeEventListener(MouseEvent.CLICK,updownL);
				if(quit)	quit.removeEventListener(MouseEvent.CLICK,kill);
			}
		}
		
		protected function updownL(e:MouseEvent):void{
			if(down==false){
				//e.currentTarget.removeEventListener(e.type, arguments.callee);
				TweenLite.to(e.currentTarget,.5,{y:Trial.ACTUAL_STAGE_HEIGHT-100, x:Trial.ACTUAL_STAGE_WIDTH-100});
				down=true;
			}
			else{
				midway();
				down=false;
			}
			
		}
		
		
		private function sortDepth(e:Event):void{
			if (e.currentTarget != this)	this.parent.addChild(this);
		}
		

		
		private function kill(e:Event=null):void{
			listeners(false);
			theStage.removeChild(this);
		}
		
		
		
		
		public static function DO(theStage:Stage,id:String):void
		{
			if(instance) throw new Error();	
			instance = new MTurkHelper(theStage,id);
			
		}
	}
}