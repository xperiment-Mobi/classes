package  com.xperiment.stimuli{

	import flash.text.TextFormat;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.addSlider;

	public class addLMS extends addSlider {

		private var _labelList:Array;
		private var _labelLocation:Array;
		private var _myTextFormat:TextFormat=new TextFormat  ;
		private var _LMSscale:uberSprite=new uberSprite  ;
		
		override public function setVariables(list:XMLList):void {
			super.setVariables(list);
			setVar("string","sliderAxis","y","x||y");
			setVar("string", "labelList", "barely detectable,weak,moderate,strong,very strong,strongest imaginable","string,string,...string");
			setVar("string", "labelLocation", "0,4.97,15.76,34.97,52.92,100","int,int,...int");
		}

		override public function isVertical():Boolean {
			return true;
		}
		
		override protected function _getScore():Number{
			return 100 - super._getScore();
		}
		
		override protected function sortLocations():Array{
			var locs:Array = super.sortLocations();
			for(var i:int=0;i<locs.length;i++){
				locs[i] = 100 - locs[i];
			}
			return locs;
		}
	}
}