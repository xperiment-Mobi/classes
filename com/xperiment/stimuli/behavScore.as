package  com.xperiment.stimuli{
	
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.behaviour.behavRT;
	import com.xperiment.behaviour.behav_baseClass;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class behavScore extends behav_baseClass {
		

		
		private static var score:int=0;
		private static var bonus:int=1;
		private var generalFormat:TextFormat = new TextFormat(null,40,codeRecycleFunctions.getColour("white"));
		private var lostBonusFormat:TextFormat = new TextFormat(null,50,codeRecycleFunctions.getColour("white"));
		
		private static var correctTrialCount:int=0;
		private var bonusLost:Boolean;
		
		override public function kill():void{
			while(pic.numChildren>0){
				pic.removeChildAt(0);
			}
			
			super.kill();
		}
		
		/*override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('colour')==false){
				uniqueProps.colour= function(what:String=null,to:String=null):String{
					//AW Note that text is NOT set if what and to and null. 
					if(what && to!="'0'") {
						
						reColour(codeRecycleFunctions.removeQuots(to));
					}
					return codeRecycleFunctions.addQuots(getVar("colour"));
				}; 	
			}
			
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		*/
		

		
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList):void {
			setVar("string","colour",0x0000FF);
			setVar("number","basicScore",600);
			
			super.setVariables(list);

			
		}
		
		override public function RunMe():uberSprite {
			
			super.setUniversalVariables();
			
			var _width:int=pic.width;
			var _height:int=pic.height;
			
			pic.scaleX=1;
			pic.scaleY=1;
			

			
			pic.graphics.beginFill(0x000fff,0);
			pic.graphics.drawRect(0,0,_width,_height);
		

	
			return pic;
		}
		
		
		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);

			calc();
			generate();
			
			setPosPercent();
		}
		
		private function generate():void
		{			
			var bonusTxt:TextField = new TextField();
			bonusTxt.text ="Bonus: x"+bonus.toString();
			bonusTxt.setTextFormat(generalFormat);
			
			var scoreTxt:TextField = new TextField();
			scoreTxt.text = "Score: "+score.toString();
			scoreTxt.setTextFormat(generalFormat);
						
			bonusTxt.autoSize = scoreTxt.autoSize = TextFieldAutoSize.CENTER;
			
			pic.addChild(bonusTxt);
			pic.addChild(scoreTxt);
			
			bonusTxt.x = pic.myWidth*.5 - bonusTxt.width*.5;
			scoreTxt.x = pic.myWidth*.5 - scoreTxt.width*.5;
			
			bonusTxt.y=0;
			scoreTxt.y=bonusTxt.height+10;
			
			
			var bonusLostTxt:TextField;
			if(bonusLost){
				bonusLostTxt = new TextField();
				bonusLostTxt.text = "Bonus lost";
				bonusLostTxt.setTextFormat(lostBonusFormat);
				bonusLostTxt.autoSize = bonusTxt.autoSize;
				pic.addChild(bonusLostTxt);
				bonusLostTxt.x = pic.myWidth*.5 - bonusLostTxt.width*.5;
				bonusLostTxt.y=scoreTxt.y+scoreTxt.height+10;
			}
			
			
		}
		
		
		
		
		private function calc():void
		{
			
			var results:addResults;
			var my_rt:behavRT;
			for each(var stim:object_baseClass in behavObjects){
				if(stim is addResults) results = stim as addResults;
				if(stim is behavRT) my_rt = stim as behavRT;
			}
			
			if(!stim) throw new Error();
			if(!my_rt) throw new Error();
			
			var rt:int = my_rt.time();
			
			var correct:int = int(results.getVar("correct"));
			var slow:int = int(results.getVar("slow"));
			var catchTrial:int = int(results.getVar("catchTrial"));

			if(correct==1){
				correctTrialCount++;
				if(correctTrialCount>=5){
					bonus *=2;
					correctTrialCount = 0;
				}
			}else{
				bonus=1;
				bonusLost=true;
				correctTrialCount = 0;
			}
			
			if(catchTrial==1 && correct==1) return;
			
			score += int(bonus * (getVar("basicScore") - rt)*.1)
			
		}		
	
	}
}