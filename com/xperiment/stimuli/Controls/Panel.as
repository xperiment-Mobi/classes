package com.xperiment.stimuli.Controls
{
	import com.bit101.components.Style;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Panel extends Sprite
	{

		public static var xSeperation:int = 5;
		public static var ySeperation:int = 5;
		
		
		private var elements:Vector.<Button> = new Vector.<Button>;
		
		public function kill():void{
			for (var i:int=0; i<elements.length;i++){
				elements[i].kill();
				elements[i]=null;
			}
			elements=null;
		}
		
		public function ON(yes:Boolean):void{
			for (var i:int=0; i<elements.length;i++){
				if(elements[i].name=="right"){
					elements[i].ON(yes);
					break;
				}
			}
		}
		

		public function compose():void{

			var posX:Number=0;

			for (var i:int=0; i<elements.length;i++){

				elements[i].x=posX+xSeperation;
				posX=elements[i].width+elements[i].x;
			
				this.addChild(elements[i]);	
			}
			
			i = elements.length-1
			var posY:Number=elements[i].height+elements[i].y+2*ySeperation;
			
			this.graphics.beginFill(Style.BACKGROUND);
			this.graphics.drawRect(0,0,posX+2*xSeperation,posY)
		}
		
		private function resizeElements(widthPerElement:Number):void
		{
			for each(var element:DisplayObject in elements){
				element.scaleX=widthPerElement/element.width;
				element.scaleY=widthPerElement/element.height;
			}
		}		
		
		public function giveElement(obj:DisplayObject):void{
			elements.push(obj);
		}
	}
}