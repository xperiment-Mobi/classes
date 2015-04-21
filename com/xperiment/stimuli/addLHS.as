package  com.xperiment.stimuli{

	import flash.text.TextFormat;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addSlider;

	public class addLHS extends addSlider {

		private var _labelList:Array;
		private var _labelLocation:Array;
		private var _myTextFormat:TextFormat=new TextFormat  ;
		private var _LMSscale:uberSprite=new uberSprite  ;
		
		override public function setVariables(list:XMLList):void {
			super.setVariables(list);
			setVar("string","sliderAxis","y","x||y");
			setVar("string", "labelList", "Most disliked sensation imaginable,Dislike extremely,Dislike very much,Dislike moderately,Dislike slightly,---------------------------Neutral,Like slightly,Like moderately,Like very much,Like extremely,Most liked sensation imaginable","string,string,...string");
			setVar("string", "labelLocation", "100,82.86,72.215,58.91,53.125,50,47.04,41.205,29.21,18.555,0","int,int,...int");
		}
		
		override protected function _getScore():Number{
			return 100 - super._getScore();
		}

		override public function isVertical():Boolean {
			return true;
		}
		
	}
}