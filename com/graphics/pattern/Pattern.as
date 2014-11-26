package com.graphics.pattern{
	import flash.display.Shape;

	public class Pattern {
		static public function myPattern(obj:Object):Shape {
			var Sha:Shape = new Shape;
			var even:uint;var odd:uint;var size:uint;var w:uint;var h:uint; var alpha:Number;
			if(obj && obj.colour1)even=obj.colour1; else even=0x23c3f7;
			if(obj && obj.colour2)odd=obj.colour2; else odd=0xffffff
			if(obj && obj.size)size=obj.size; else size=10;
			if(obj && obj.width)w=obj.width; else w=100;
			if(obj && obj.height)h=obj.height; else h=100;
			if(obj && obj.alpha)alpha=obj.alpha; else alpha=.5;
			
			var nH:int=w/size;
			var nV:int=h/size;
			var clr:uint;
			var i:uint;
			var j:uint;


			for (i=0; i<nV; ++i) {
				even^=odd;
				odd^=even;
				even^=odd;
				for (j=0; j<nH; ++j) {
					clr=j&1?even:odd;

					Sha.graphics.beginFill(clr,1);
					Sha.graphics.drawRect(Number(j*size),Number(i*size),size,size);
					Sha.graphics.endFill();
				}
			}
			
			//if(w % size !=0){trace("Problem with your Pattern.  Your shape width is not a multiple of your shape size - actual shape width is thus slightly bigger than you specified ("+(size-(w % size))+" pixels) to ensure 'whole squares'.  Horizontal scaling this to ensure correct Width.");Sha.width=w;}
			//if(h % size !=0){trace("Problem with your Pattern.  Your shape height is not a multiple of your shape size - actual shape height is thus slightly bigger than you specified ("+(size-(w % size))+" pixels) to ensure 'whole squares'.  Vertical scaling this to ensure correct Height.");Sha.height=h;}

			Sha.alpha=alpha;
			return Sha;
		}
	}
}