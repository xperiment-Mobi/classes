package com.xperiment.stimuli.primitives.graphs.bar {
	import com.bit101.components.Style;
	
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Dominic Gelineau
	 */
	public class Bar extends Sprite {
		
		public function Bar(width:int, height:int, errorBar:int,colour:int) {
			if(colour==-1)colour = Style.BUTTON_FACE
			
			
			graphics.beginFill(colour);
			graphics.drawRect(-width/2, 0, width, -height);
			graphics.endFill();
			
			if(errorBar!=0){
				graphics.lineStyle(Style.borderWidth,0xff0000);
				graphics.moveTo(0,-errorBar-height);
				graphics.lineTo(0,errorBar-height);
				
				graphics.moveTo(-2,-errorBar-height);
				graphics.lineTo(2,-errorBar-height);
				
				graphics.moveTo(-2,errorBar-height);
				graphics.lineTo(2,errorBar-height);
			}
		}
	}
}