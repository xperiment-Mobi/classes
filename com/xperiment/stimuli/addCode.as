package com.xperiment.stimuli
{
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import com.xperiment.events.StimulusEvent;

	public class addCode extends object_baseClass
	{
		override public function setVariables(list:XMLList):void {

			setVar("string","gradient",""); // e.g. "type:linear,colors:[0x000000,0xffffff],alphas:[1,1],ratios:[1,255],angle:90"
			super.setVariables(list);

		}
		
		override public function RunMe():uberSprite {
			
			//AW JAN FIX
			pic.dispatchEvent(new Event("doBefore"));
			//if(this.actions && this.actions.hasOwnProperty("doBefore")){
			//	manageBehaviours.doBehaviourFirst(this);
			//}
			
			var maxSize:uint=20;
			
			var num1:Number = Math.floor(Math.random()*maxSize);
			var num2:Number = Math.floor(Math.random()*maxSize);
			
			var operation:String;
			
			if(Math.random()<.5)operation="+";
			else operation ="-";
			
			var answers:Array = new Array;
			var answer:Number;
			
			if(operation=="+")	answer=num1+num2;
			else 				answer=num1-num2;
			
			answers[0]=answer;
			var dif:Number;
			var temp:Number=answers[0];
			for(var i:uint=1;i<4;i++){
				
				while(answers.indexOf(temp)!=-1){
					dif=1+Math.floor(Math.random()*maxSize*.25);
					if(Math.random()>.5) temp=answers[0]+dif;
					else temp=answers[0]-dif;
				}
				answers[i]=temp;
			}
			answers=codeRecycleFunctions.arrayShuffle(answers);
			var myPic:Sprite = new Sprite;
			
			
			var question:String="<u>"+String(num1)+" "+operation+" "+String(num2)+" = ?"+"</u>";
			var q:TextField = add(question);
			myPic.addChild(q);
			
			q.x=0;
			q.y=0;		
			
			var tf:TextField;
			function add(str:String):TextField{
				tf=new TextField;
				tf.autoSize=TextFieldAutoSize.CENTER;
				tf.htmlText=str;
				tf.selectable=false;
				tf.mouseEnabled=true;
				myPic.addChild(tf);
				return tf;
			}
			

			var textAnswers:Array = new Array;
			var letters:Array=["","","",""];
			var As:Array=[];
			var a:TextField;

			for(i=0;i<answers.length;i++){
				a=add(letters[i]+" = "+String(answers[i]));
				if(answers[i]==answer)a.name="correct";
				a.x=q.x+q.width*.5-a.width*.5;
				a.y=q.height*(i+1);	
				a.alpha=.7;
				myPic.addChild(a);
				answers[i]=a;

				a.addEventListener(MouseEvent.CLICK,listen);
			}
			
			function listen(e:MouseEvent):void{
				for(i=0;i<answers.length;i++){
					answers[i].removeEventListener(MouseEvent.CLICK,listen);
					if(answers[i].name=="correct")answers[i].appendText("  ✓");
				}
				if((e.currentTarget as TextField).name!="correct")(e.currentTarget as TextField).appendText("  x");
				var t:Timer=new Timer(1000,1);
				t.start();
				t.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void{
					t.removeEventListener(e.type,arguments.callee);
					for(var i:uint=0;i<myPic.numChildren;i++){
						myPic.removeChild(myPic.getChildAt(i));
					}
					pic.removeChild(myPic);
					myPic=null;
					finished();
					
				},false,0, false);//HAVE TO HAVE FALSE HERE!! Else the listener is removed by cleanup. 
			}
			

			myPic.graphics.drawRect(0,0,myPic.width,myPic.height);//perculiar solution to the centering problem
			pic.addChild(myPic);
			myPic.x=0;
			
			super.setUniversalVariables();
			return (super.pic);
		}
		
		private function finished():void{
			//AW JAN FIX

			pic.dispatchEvent(new Event(StimulusEvent.ON_FINISH));
			//manageBehaviours.stimulusFinished(this);
		}
	}
}