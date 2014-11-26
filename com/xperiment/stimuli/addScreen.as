package  com.xperiment.stimuli{
	import com.xperiment.uberSprite;
	import com.xperiment.trial.Trial;
	
	public class addScreen extends object_baseClass {
		
		
		
		override public function RunMe():uberSprite {
			pic.graphics.beginFill(0x123445,0);
			pic.graphics.drawRect(0,0,Trial.RETURN_STAGE_WIDTH,Trial.RETURN_STAGE_HEIGHT);
			return pic;
		}
		
	}
}