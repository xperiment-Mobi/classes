package  com.xperiment.stimuli{
	
	import com.codeRecycleFunctionsdead;
	import com.bit101.components.Style;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;

	
	
	
	public class addVennDiagram extends object_baseClass implements Imockable{
		

		private var fontSizes:Array;
		private var fontColours:Array;
		private var textStrs:Array;
		private var texts:Array = [];
		private var circles:Array = [];
		private var draggedSpr:Sprite;
		public static const ATTEMPTS:int = 1000;
		private var circleColours:Array;
		private var circleNames:Array;
		private var textBackgroundColour:int
		
		override public function kill():void{
			
			pic.removeEventListener(MouseEvent.MOUSE_DOWN,doStartDrag);
			theStage.removeEventListener(MouseEvent.MOUSE_UP,doStopDrag);
			
			for(var i:int=0;i<circles.length;i++){
				pic.removeChild(circles[i]);
				circles[i]=null;
			}
			circles=null;
			
			for(i=0;i<texts.length;i++){
				pic.removeChild(texts[i]);
				texts[i]=null;
			}
			texts=null;
			
			fontSizes=null;
			fontColours=null;
			textStrs=null;
			draggedSpr=null;
			circleColours=null;
			circleNames=null;
			
			
			super.kill();
		}
		
		

		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('abcResults')==false){
				uniqueProps.abcResults= function():String{
					//AW Note that text is NOT set if what and to and null. 
					
					var objs:Object = computeColours(true);
					
					var result:Array=[];
					
					for (var circle:String in objs){
						if((objs[circle] as Array).length>0){
							result.push(circle+":"+(objs[circle] as Array).sort().join("_"));
						}
					}
					result=result.sort();
					return "'"+result.join(" ")+"'";
				};
			}
			if(uniqueProps.hasOwnProperty('result')==false){
				uniqueProps.result=function():String{
					//AW Note that text is NOT set if what and to and null. 
					var objs:Object = computeColours(true);
					
					var result:String=''
					
					for (var circle:String in objs){
						if(result.length>0)result+="&";
						if((objs[circle] as Array).length>0){
							result+=circle+":"+(objs[circle] as Array).join("_");
						}
					}
					return "'"+result+"'";
				}; 	
				
			}
			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		


		public function mock():void{
			for each(var text:Sprite in texts){
				text.x=(pic.myWidth-text.width) 	* Math.random();
				text.y=(pic.myHeight-text.height)	* Math.random();
			}
		}
		
		override public function setVariables(list:XMLList):void {

			setVar("string","texts",'a,b,c');
			setVar('string',"fontSizes",25);
			setVar("string", "fontColours",Style.LABEL_TEXT);
			setVar("string", "circleFontColours",Style.LABEL_TEXT);
			setVar("string", "position" , 'abc');
			setVar('int', "circles", 2);
			setVar("string","grid","4x4","if you have more than 3 circles you must specify the grid pattern to place them in")
			setVar('string', "circleColours", '0x0000FF,0xFF0000,0x00FF00');
			setVar('string', "circleFontColours", Style.LABEL_TEXT);
			setVar('string', 'circleWidth','40%');
			setVar('string', 'circleHeight','40%');
			setVar('string', 'circleX','35%,65%');
			setVar('string', 'circleY','50%');
			setVar('boolean','randomCirclePositions',true);
			setVar('number', 'circleRadiusPercent',40);
			setVar('number', 'circleAlpha',.3);
			setVar('string','circleNames','a','b');
			setVar('int','circleNameTextSize',30);
			setVar("string","textBackgroundColour",'0xffffff');
			
			super.setVariables(list);
			if(getVar("shape")=="")setVar("string","shape",getVar("myShape"));
			
		}
		
		
		
		
		private function computeFonts():void
		{
			var format:TextFormat = new TextFormat;
			var text:TextField;
			var spr:Sprite;
			
			for(var i:int = 0; i<textStrs.length; i++){
				
				text = new TextField;
				text.text = textStrs[i];
				text.textColor = fontColours[i%fontColours.length];
				format.size	= fontSizes[i%fontSizes.length];
				text.autoSize=TextFieldAutoSize.CENTER;
				text.setTextFormat(format);
				text.defaultTextFormat=format;
				text.name='text';
				text.background=true;
				//text.backgroundColor=0xBBBBBB;
				
				text.selectable=false;
			
				
				spr = new Sprite;
				spr.addChild(text);
				spr.mouseEnabled=true;
				spr.mouseChildren=false;
				spr.buttonMode=true;
				spr.useHandCursor=true;
				text.x=0;
				text.y=0;
				spr.width=text.width;
				spr.height=text.height;
				
				//spr.graphics.beginFill(0x004433,.5);
				//spr.graphics.drawRect(0,0,spr.width,spr.height);

				texts.push(spr);
				
				pic.addChild(spr);
				
				
				if(getVar("position").indexOf("random")!=-1)	placeFontRandomly(spr);
				}
			if(getVar("position")=="abc")						placeFontABC()
			
			else if(getVar("position")=='abc_random')			abcDo();
		}
		
		private function abcDo():void
		{
			var angleArr:Array = [];
			var centreX:Number=0;
			var centreY:Number=0;
			
			for each(var circle:Sprite in circles){
				centreX += circle.x+circle.width*.5;
				centreY += circle.y+circle.height*.5;
			}
			
			centreX /= circles.length;
			centreY /= circles.length;

			for each(var text:Sprite in texts){											
				angleArr.push(  {angle:point_direction(centreX, centreY, text.x+text.width*.5, text.y+text.height*.5),
								 x:    text.x+text.width*.5, 
								 y:    text.y+text.height*.5}	);		
			}
			
			angleArr.sortOn("angle",Array.DESCENDING | Array.NUMERIC);
			
			for(var i:int=0;i<angleArr.length;i++){
				text=(texts[i] as Sprite);
				text.x=angleArr[i].x;
				text.y=angleArr[i].y;
				
				if(text.x+text.width>pic.myWidth)text.x=pic.myWidth-text.width;
				
			}
		}
		
		private function point_direction(x1:Number, y1:Number, x2:Number, y2:Number):Number 
		{
			var angle:Number=Math.atan2(x1-x2 , y1-y2) * 180 / Math.PI + 180;;
			
						    angle+=	180;
			if(angle>360)	angle-=	360;
			if(angle<0)		angle =	360-angle;
			
			return angle
		}
		
		private function placeFontABC():void
		{
			var top:int = computeTextAreaBox();
			
			var rowCount:int = 0;
			var rows:Array = [];
			
			var currentX:int = 0;
			var currentY:int = 0;
			
			var seperation:int = 10;
			
			var maxRightArr:Array=[];
			var maxHeight:int=0;
			
			
			
			for each(var text:Sprite in texts){
				
				if(text.width+currentX>pic.width){
					currentX=0;
					currentY+=text.height+seperation;
					rowCount++;
				}
				
				if(rows.length<rowCount+1)rows[rowCount]=[];
				
				rows[rowCount].push(text);
				
				
				text.x=currentX;
				text.y=currentY;
				
				if(maxRightArr.length<rowCount+1)maxRightArr.push(0);
				if(text.x+text.width>maxRightArr[rowCount])maxRightArr[rowCount]=text.x+text.width;
				
				if(text.y+text.height>maxHeight)maxHeight=text.y+text.height;
				
				currentX+=text.width+seperation;
			}
			
			maxHeight=top-maxHeight;

			var curExtraWidth:Number;
			
			for(var i_row:int=0; i_row<rows.length; i_row++){

				curExtraWidth=(pic.myWidth-maxRightArr[i_row])/(rows[i_row].length-1);
				for(var len_i:int=0;len_i<rows[i_row].length;len_i++){
					
					(rows[i_row][len_i] as Sprite).x+=curExtraWidth*(len_i);
					(rows[i_row][len_i] as Sprite).y+=(i_row+1) * maxHeight/(rows.length-1)		
				}
			}	
		}
		
		private function computeTextAreaBox():int
		{
			var top:int = pic.myHeight;
			
			for each(var circle:Sprite in circles){
				if(circle.x<top)top=circle.x;
			}
			return top;
		}
		
		private function placeFontRandomly(textSpr:Sprite,count:int=0):void{
			textSpr.x = (pic.myWidth - textSpr.width) 	* Math.random() - textSpr.width*.5;
			textSpr.y = (pic.myHeight - textSpr.height) * Math.random() - textSpr.height*.5;
			count++;
			var fail:Boolean = false;
			
			if(count<ATTEMPTS){
				outerLoop: for(var i:int = 0 ;i<texts.length; i++){
								if(textSpr!=texts[i]){
									for(var circle_i:int = 0 ;circle_i<circles.length; circle_i++){
										if(textSpr.hitTestObject(circles[circle_i]) || textSpr.hitTestObject(texts[i])){
											fail=true;
											break outerLoop;
										}
									}		
								}
							}
				if(fail) placeFontRandomly(textSpr, count++);			
			}
		}
		
		override public function storedData():Array {	
			var objs:Object = computeColours(true);
			var tempData:Array;
			
			for(var text:String in objs){
				tempData = new Array();
				tempData.event=text;
				
				tempData.data =(objs[text] as Array).join(';')
				objectData.push(tempData)
			}
				
			return objectData;
		}
		
		override public function returnsDataQuery():Boolean {		
			return true;
		}
		
		override public function RunMe():uberSprite {
			
	
			textStrs = 		getVar("texts").split(",");
			fontSizes = 	getVar("fontSizes").split(",");
			fontColours = 	getVar("fontColours").split(",");
			textBackgroundColour=codeRecycleFunctions.getColour(getVar("textBackgroundColour"));
			
			pic.graphics.beginFill(0,.5);
			pic.graphics.drawRect(0,0,1,1);
			
			super.setUniversalVariables();
			
			pic.scaleX=1;
			pic.scaleY=1;
			
			computeVenn()
			computeFonts();
			computeColours(false);
			
			pic.addEventListener(MouseEvent.MOUSE_DOWN,doStartDrag);
			theStage.addEventListener(MouseEvent.MOUSE_UP,doStopDrag);
			
			return pic;
		}
		
		private function doStartDrag(e:MouseEvent):void{
			var success:Boolean=false;
			for(var i:int = 0;i<texts.length;i++){
				if(e.target == texts[i]){
					draggedSpr=(texts[i] as Sprite);
					pic.addChild(draggedSpr); //shortcut to change child index
					draggedSpr.startDrag(false);
				}
			}
			if(success==false){
				for(i = 0;i<circles.length;i++){
					if(e.target == circles[i]){
						draggedSpr=(circles[i] as Sprite)
						draggedSpr.startDrag(false);
					}
				}
				
				
			}
	
		}
		
		private function doStopDrag(e:MouseEvent):void{
			
			if(draggedSpr){
				draggedSpr.stopDrag();
				computeColours(false);
			}
			
		}
		
		private function computeColours(giveResults:Boolean):Object
		{
			var textInWhichCircle:Object;
			if(giveResults){
				textInWhichCircle = new Object;
				for (var i_circle:int = 0; i_circle<circles.length; i_circle++){
					textInWhichCircle[circleNames[i_circle]]=[];
				}
			}
		
			var countInCircles:int;
			var listInCircles:Array;
			var x:int;
			var y:int;
			var t:TextField;
			
			
			for(var text_i:int = 0;text_i<texts.length;text_i++){
				x=texts[text_i].x+texts[text_i].width*.5+this.x;
				y=texts[text_i].y+texts[text_i].height*.5+this.y;
				countInCircles = 0;
				listInCircles = new Array(circles.length);
				
				for (i_circle = 0; i_circle<circles.length; i_circle++){
					
					if((circles[i_circle] as Sprite).hitTestPoint(x, y, true)){
							countInCircles++;
							listInCircles[i_circle]=1;
							
							if(giveResults) textInWhichCircle[circleNames[i_circle]].push(((texts[text_i] as Sprite).getChildAt(0) as TextField).text);
							
					}
					else{
						listInCircles[i_circle]=0;
					}
					t = texts[text_i].getChildAt(0) as TextField;

					if(countInCircles==0){
						t.backgroundColor=textBackgroundColour;
						t.textColor=fontColours[text_i%fontColours.length];
					}
					else if(countInCircles==1){
						t.backgroundColor=textBackgroundColour;
						t.textColor=circleColours[listInCircles.indexOf(1)%circleColours.length];
					}
					else {
						t.backgroundColor=0x000000;
						t.textColor=0xFFFFFF;
					}	
				}	
			}
			return textInWhichCircle;
		}
		
		
		private function computeVenn():void
		{
			var circle:Sprite;
			
			
			circleColours 	= getVar("circleColours").split(",");
			circleNames = getVar("circleNames").split(",");
			
			var circleLineColours:Array = getVar("circleLineColours").split(",");
			
			var format:TextFormat = new TextFormat;
			format.size = getVar("circleNameTextSize");
			var num:int = getVar("circles") as int; 
//num=2
			var positions:Array = [];
			
			//if(num>3)throw new Error('only allowed upto 3 circles in a venn digram');
			
			var x:Number;
			var y:Number;

			var dimension:String = getVar('circleWidth');
			if(dimension.charAt(dimension.length-1)=="%"){
				dimension=dimension.substr(0,dimension.length-2);
				if(isNaN(Number(dimension)))throw new Error("you have specified a circle dimension in a venn diagram non-numerically (% suffix allowed):"+dimension+"%");
			}
			
			var circleWidth:Number	= getCircleDimension(getVar('circleWidth'),pic.myWidth);
			var circleHeight:Number	= getCircleDimension(getVar('circleHeight'),pic.myHeight);
			

			var colour:int = codeRecycleFunctions.getColour(getVar("circleFontColours")); 
			
			for(var i:int = 0 ; i< num ; i++){
				
				x=pic.myWidth
				
				circle = new Sprite;
				circle.graphics.lineStyle(3,circleLineColours[i%circleLineColours.length]);
				circle.graphics.beginFill(circleColours[i%circleColours.length],getVar("circleAlpha"));
				circle.graphics.drawEllipse(0,0,circleWidth,circleHeight);
				
				circle.mouseEnabled=true;
				circle.mouseChildren=false;
				circle.buttonMode=true;
				circle.useHandCursor=true;
				
				var label:TextField = new TextField;
				label.text=circleNames[i%circleNames.length];
			
				label.setTextFormat(format);
				label.defaultTextFormat=format;
				label.textColor = colour;
				
				label.selectable=false;
				label.autoSize = TextFieldAutoSize.CENTER;
				
				circle.addChild(label);
				label.x=circle.width*.5-label.width*.5;
				label.y=circle.height*.5-label.height*.5;
									
				pic.addChild(circle);
				
				
				circle.name='circle'
				circles.push(circle);
			}
			
			computeCirclePositions();
			
			//if(getVar("position")=="abc"){
				//circlesABC();
			//}
		}		
		
		private function getCircleDimension(dimension:String,mult:Number):Number
		{
			var num:Number;
			var err:Boolean = false;

			
			if(dimension.charAt(dimension.length-1)=="%"){
				dimension=dimension.substr(0,dimension.length-1);
				num=Number(dimension)*mult*.01;
				if(isNaN(Number(dimension)))err=true;
			}
			else{
				if(isNaN(Number(dimension)))err=true;
				num=Number(dimension);
			}
			
			if(err)throw new Error("you have specified a circle dimension in a venn diagram non-numerically (% suffix allowed):"+dimension+"%");
			
			return num;
		}
		
		private function computeCirclePositions():void
		{
			var positions:Array = [];
			
			
				
			var xArr:Array=computeCirclePositionsHelper(getVar("circleX"),pic.myWidth);
			var yArr:Array=computeCirclePositionsHelper(getVar("circleY"),pic.myHeight);
			
			
			for(var i:int = 0 ;i<xArr.length;i++){
				positions.push(new Point(xArr[i%(xArr.length)],pic.myHeight-yArr[i%(yArr.length)]));
			}
					
				
			

			
			if(getVar('randomCirclePositions')){
				positions=codeRecycleFunctionsdead.arrayShuffle(positions);
			}
			
			var point:Point;
			for(i = 0 ;i<circles.length;i++){
				point=positions[i];
				circles[i].x=point.x-circles[i].width*.5;
				circles[i].y=point.y-circles[i].height*.5;
			}
		}
		
		private function computeCirclePositionsHelper(strPositions:String,maxSize:Number):Array{
			var err:Boolean = false;
			var dimensions:Array = [];

			for each(var numStr:String in strPositions.split(",")){
				if(numStr.charAt(numStr.length-1)=="%"){
					numStr=numStr.substr(0,numStr.length-1);
					if(isNaN(Number(numStr)))err=true;
					else dimensions.push(Number(numStr)*maxSize*.01);
				}
				else{
					if(isNaN(Number(numStr)))err=true;
					else dimensions.push(Number(numStr)*maxSize*.01);
				}
				
				if(err)throw new Error ('x and y positions of venn diagram circles must be numbers optionally suffixed with a percentage sign.  You gave '+numStr+"%");
			}
			return dimensions;
		}
		
		
		/*private function circlesABC():void
		{
			var shiftDownBy:int=pic.myHeight;
			for each(var circle:Sprite in circles){
				trace(shiftDownBy,circle.y+circle.height);
				if(pic.myHeight-(circle.y+circle.height)<shiftDownBy)shiftDownBy=pic.myHeight-(circle.y+circle.height);
			}
			for each(circle in circles){
				circle.y+=shiftDownBy;
			}
			
			
		}*/
	}
}


