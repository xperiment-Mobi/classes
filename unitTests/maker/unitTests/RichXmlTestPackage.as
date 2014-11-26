package unitTests.maker.unitTests
	
{

	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import org.flexunit.runner.FlexUnitCore;
	

	
	public class RichXmlTestPackage extends Sprite
	{
		private var core:FlexUnitCore;
		
		public function RichXmlTestPackage(){
			
			core = new FlexUnitCore();
			
			var fin:FinishedListener = new FinishedListener;
			fin.passF(finished);
			core.addListener(fin);
			

			core.run(test_richLines);

			core = null;
			super();
			
		}
		
		public function finished():void{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}