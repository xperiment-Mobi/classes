package  com.xperiment.stimuli{
	
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	
	
	
	public class addShape extends object_baseClass {
		
		private var myShape:Shape;
		private static var curve:Number = .1;
		
		override public function kill():void{
			
			while(pic.numChildren>0){
				pic.removeChildAt(0);
			}
			super.kill();
		}
		
		override public function myUniqueProps(prop:String):Function{
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
		
		
		private function reColour(colour:String):void
		{
			if(myShape){
				//trace("set colour to",colour,Number(colour).toString(16));
				if(isNaN(Number(colour)))throw new Error("a shape ("+peg+") has told to change colours but an unknown colour specified: "+colour);
				OnScreenElements.colour=colour;
				if(myShape){
					var myTempShape:Shape=makeShapeHelper(myShape.width,myShape.height);
					myTempShape.scaleX=myShape.scaleX;
					myTempShape.scaleY=myShape.scaleY;
					myTempShape.x=myShape.x;
					myTempShape.y=myShape.y;
					pic.removeChild(myShape);
					myShape=myTempShape;
					pic.addChild(myShape);
				}
			}
		}
		
		//public function Trial_imageCollage(genAttrib:XMLList, specAttrib:XMLList) {
		override public function setVariables(list:XMLList):void {
			setVar("string","colour",0x0000FF);
			setVar("uint","ellipseWidth", 20);
			setVar("uint","ellipseHeight",20);
			setVar("uint","lineThickness",5);
			setVar("uint","border",1);
			setVar("uint","lineColour",0x000000);
			setVar("int","transparency",1,"0-1");
			setVar("string","shape","rectangle","roundedRectangle||rectangle||ellipse||circle||triangle||square||tick||smile||arrow");
			setVar("uint","radius",40);
			setVar("string","gradient",""); // e.g. "type:linear,colors:[0x000000,0xffffff],alphas:[1,1],ratios:[1,255],angle:90"
			setVar("boolean","fill",true);
			setVar("number","curve",5);
			setVar("number","offset",30); //in percent
			super.setVariables(list);
			if(getVar("shape")=="")setVar("string","shape",getVar("myShape"));
			
			if(getVar("curve")!="")curve=getVar("curve");
			if(getVar("offset")!="")curve=getVar("offset");
			
		}
		
		override public function RunMe():uberSprite {
			
			super.setUniversalVariables();
			
			var _width:int=pic.width;
			var _height:int=pic.height;
			
			pic.scaleX=1;
			pic.scaleY=1;
			
			
			myShape=makeShapeHelper(_width,_height);	
			pic.addChild(myShape);
	
			return pic;
		}
		
		private function makeShapeHelper(_width:int, _height:int):Shape{
			var myGradient:Object;
			if(getVar("gradient")!="") myGradient = processGradient(getVar("gradient"));
			
			var colour:Number = codeRecycleFunctions.getColour(getVar("colour"));
			
			var shape:Shape = makeShape(getVar("shape"),getVar("lineThickness"),getVar("lineColour"),getVar("transparency"),colour,_width,_height,getVar("border"),myGradient,getVar("fill"));
			
			return shape;
		}
		
		public function processGradient(dat:String,orientation:Number=10000):Object
		{
			var obj:Object=new Object;
			
			obj.type = rip("type:",dat,",","linear") as String; //linear or radial
			obj.colors = (rip("colors:",dat,"]","0x000000,0xffffff","[]") as String).split(",") as Array; 
			obj.alphas = (rip("alphas:",dat,"]","1,1","[]") as String).split(",") as Array; 
			obj.ratios = (rip("ratios:",dat,"]","0,255","[]") as String).split(",") as Array; 
			var angle:Number = Number(rip("angle:",dat,",","0")); //linear or radial
			if(orientation!=10000)angle=orientation;
			obj.mat = gradBox(100,100,angle);
			
			return obj;
		}
		
		public function gradBox(width:Number,height:Number,angle:Number):Matrix{
			var mat:Matrix = new Matrix;
			mat.createGradientBox(width, height,angle*Math.PI/180);
			return mat;
		}
		
		public function rip(nam:String,dat:String,endTag:String, myDefault:String, trim:String=""):String{
			
			var loc:int=dat.search(nam);
			if(loc==-1)return myDefault;
			var temp:String=dat.substr(loc+nam.length);
			loc=temp.search(endTag);
			if(loc!=-1)temp=temp.substr(0,loc);
			for(var i:uint=0;i<trim.length;i++){
				temp=temp.split(trim.charAt(i)).join("");
				
			}
			return temp;
		}
		
		static public  function makeShape(type:String, lineThickness:Number, lineColour:Number, transparency:Number, colour:Number, width:int,height:int,line:Boolean=true,gradient:Object=null,fill:Boolean=true):Shape {

			if(type.toLowerCase()=="arrow") fill=false;
			
			var sha:Shape=new Shape  ;
			if(line){
				sha.graphics.lineStyle(lineThickness,lineColour,transparency);
			}
			if(fill && type.toLowerCase()!="arroww")sha.graphics.beginFill(colour,transparency);
			if(gradient){
				sha.graphics.beginGradientFill(gradient.type, gradient.colors, gradient.alphas, gradient.ratios,gradient.mat);
			}
			
			sha.graphics.moveTo(0,0);
			
			switch(type.toLowerCase()){
				case "circle":
					sha.graphics.drawEllipse(0, 0,width,height);
					break;
				case "triangle":
					
					sha.graphics.lineTo(width,0);
					sha.graphics.lineTo(Math.round(width)*.5,height);
					sha.graphics.lineTo(0,0);
					break;
				case "rectangle":
					sha.graphics.drawRect(0,0,width,height);
					break;
				case "roundedrectangle":
					sha.graphics.drawRoundRect(0,0,width,height,width,0);
				case "square":
					sha.graphics.drawRect(0,0,width,height);
					break;
				case "tick":
					sha.graphics.moveTo(0, height*.25);
					sha.graphics.lineTo(width*.25, 0);
					sha.graphics.curveTo(width/2, height/2,width, height);
					sha.y=-height*.8;
					sha.x=width*.2
					break;
				
				case "oval":
				case "ellipse":
					sha.graphics.drawEllipse(0,0,height,height);
					break;	
				case "arrow":
					sha.graphics.moveTo(0,height*.5)
					sha.graphics.lineTo(width,height*.5);
					sha.graphics.lineTo(width*.9,0);
					sha.graphics.moveTo(width,height*.5);
					sha.graphics.lineTo(width*.9,height);
					
					
					break;
				case "stopsign":
					sha.graphics.drawEllipse(0, 0,width,height);
					sha.graphics.moveTo(0,height*.5);
					sha.graphics.lineTo(width,height*.5);
					
					break;
				case "smile":
					sha.graphics.moveTo(width*.2, height*.75);
					sha.graphics.drawCircle(width*.2, height*.5, height*.2);
					sha.graphics.drawCircle(width*.6, height*.5, height*.2);
					sha.graphics.moveTo(0, 0);
					sha.graphics.curveTo(width/2.3, -height/2,width*.75, 0);
					sha.graphics.drawCircle(width*.2, height*.5, .1);
					sha.graphics.drawCircle(width*.6, height*.5, .1);
					sha.height*=.9;
					sha.y-=height/1.5;
					sha.x+=width/20;
					break;
				default:
					throw new Error("unknown shape: "+ type);
			}
			
			if(fill)sha.graphics.endFill();
			
			
			return sha;
		}
		
	}
}