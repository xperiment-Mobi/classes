package com.xperiment.Animation
{
	import com.bit101.components.Style;
	import com.greensock.TweenMax;
	import com.xperiment.trial.Trial;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	
	public class MessageAnimation extends Sprite
	{
		private var myParent:DisplayObjectContainer;
		private var messageTF:TextField;

		private var countDown:int;
		private var message:String;
		private var format:TextFormat;
		private var doCountDown:Boolean = false;
		private var destroyAfterCountDown:Boolean;
		
		public function MessageAnimation(myParent:DisplayObjectContainer,message:String, countDown:int=-1,destroyAfterCountDown:Boolean=false)
		{
			this.myParent = myParent;			
			this.countDown = countDown;
			this.message = message;
			this.destroyAfterCountDown = destroyAfterCountDown;
			
			
			myParent.addChild(this);
			
			messageTF = new TextField();
			messageTF.autoSize = TextFieldAutoSize.CENTER;
			
			format = new TextFormat();
			format.size = 50;	
			messageTF.textColor = Style.LABEL_TEXT;
			
			if(countDown!=-1){
				doCountDown=true;
				this.message+=' ';
				addTimeToMessage();
			}
			else{
				messageTF.text = message;
			}
			
			messageTF.setTextFormat(format);

			//messageTF.x=Trial.RETURN_STAGE_WIDTH*.5-messageTF.width*.5;
			//messageTF.y=Trial.RETURN_STAGE_HEIGHT*.5-messageTF.height*.5;
			
			this.graphics.beginFill(Style.BACKGROUND,.9);
			this.graphics.drawCircle(messageTF.x+messageTF.width*.5,messageTF.y+messageTF.height*.5,messageTF.width*.5);
			
			this.addChild(messageTF);
			
			TweenMax.to(this, 1, {alpha:.2, repeat:[-1],yoyo:true, onRepeat:countDownF});
	
		}
		
		private function addTimeToMessage():void
		{
			if(doCountDown){
				if(countDown==-1)countDown=10;
				messageTF.text=message+String(countDown--);
				messageTF.setTextFormat(format);
				if(destroyAfterCountDown && countDown==0){
					
					kill();
				}
			}
		}
		
		protected function countDownF():void
		{
			addTimeToMessage();
		}		
		
		public function kill():void
		{
			TweenMax.killTweensOf(this);
			if(myParent.contains(this))myParent.removeChild(this);
			if(messageTF && this.contains(messageTF))this.removeChild(messageTF);
			messageTF=null;

						
		}
	}
}