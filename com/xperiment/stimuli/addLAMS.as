package  com.xperiment.stimuli{

	import com.xperiment.uberSprite;
	import flash.text.TextFormat;
	import com.xperiment.stimuli.addSlider;

	public class addLAMS extends addSlider {

		private var _labelList:Array;
		private var _labelLocation:Array;
		private var _myTextFormat:TextFormat=new TextFormat  ;
		private var _LMSscale:uberSprite=new uberSprite  ;

		override public function setVariables(list:XMLList):void {
			super.setVariables(list);
			setVar("string","sliderAxis","y","x||y");
			setVar("string", "labelList", "greatest imaginable disliking,dislike Extremely,dislike very much,dislike moderately,dislike slightly,neither Like nor dislike,like slightly,like moderately,like very much,like extremely,greatest imaginable liking","string,string,...string");
			setVar("string", "labelLocation", "0,11.9,22.2,34.3,44.8,50.2,55.8,68.1,77.7,87.1,100","int,int,...int");
		}

		override public function isVertical():Boolean {
			return true;
		}

		override protected function _getScore():Number{
			return 100 - super._getScore();
		}

	}
}