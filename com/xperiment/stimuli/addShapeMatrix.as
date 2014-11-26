package  com.xperiment.stimuli{

	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.primitives.Cell;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;



	public class addShapeMatrix extends addShape {

		private var myShape:Shape;
		private const rowSplit:String="\r\n";
		private var matrix:Vector.<Cell>;
		private var myGradient:Object;
	
		
		override public function kill():void
		{
			for(var i:uint=0;i<matrix.length;i++){
				pic.removeChild(matrix[i].ob);
				matrix[i].kill();
				matrix[i]=null;
			}
			
			
		}
		
		override public function setVariables(list:XMLList):void {
			setVar("string","width",100);
			setVar("string","height",100);
			setVar("number","colour",0x0000FF);
			setVar("uint","ellipseWidth", 20);
			setVar("uint","ellipseHeight",20);
			setVar("uint","lineThickness",5);
			setVar("boolean","boarder",true);
			setVar("uint","lineColour",0x000000);
			setVar("int","transparency",1,"0-1");
			setVar("string","myShape","circle","roundedRectangle||rectangle||ellipse||circle||triangle||square||tick||smile");
			setVar("uint","radius",40);
			setVar("string","gradient",""); // e.g. "type:linear,colors:[0x000000,0xffffff],alphas:[1,1],ratios:[1,255],angle:90"
			setVar("uint","objWidth",30);
			setVar("uint","objHeight",30);
			setVar("uint","cellWidth",50);
			setVar("uint","cellHeight",50);
			setVar("string","matrixRotation","");
			super.setVariables(list);
			if(getVar("shape")!=undefined)setVar("string","myShape",getVar("shape"));
		}

		override public function RunMe():uberSprite {
			
			myShape=new Shape  ;
			
			if(getVar("gradient")) myGradient = processGradient(getVar("gradient"));
			
			myShape=sortShape();
			
			var mySpr:Sprite = new Sprite;
			mySpr.addChild(myShape);
			
			floppyMatrix();
			
			super.setUniversalVariables();
			return (super.pic);
		}
		
		override public function gradBox(width:Number,height:Number,angle:Number):Matrix{
			var mat:Matrix = new Matrix;
			mat.createGradientBox(getVar("objWidth"), getVar("objHeight"),angle*Math.PI/180);
			return mat;
		}
		
		private function sortShape():Shape {
			return makeShape(getVar("myShape"),getVar("lineThickness"),getVar("lineColour"),getVar("transparency"),getVar("colour"),getVar("objWidth"),getVar("objHeight"),getVar("border"),myGradient);
		}
		
		
		public function floppyMatrix():void
		{
		
			matrix=new Vector.<Cell>;
			var rows:Array=(getVar("matrix") as String).split(rowSplit);
			var cell:Cell;
			var columns:Array;
			var columnCorrection:int;  //if blank cells are needed, this allows for x number of blank cells
			var blankArr:Array;
			for(var row:uint=0;row<rows.length;row++){
				columns=rows[row].split(",");
				columnCorrection=0;
				for(var column:uint=0;column<columns.length;column++){
					if(!isNaN(columns[column])){
						for(var i:uint=0;i<int(columns[column]);i++){
							cell = new Cell;
							cell.row=row;
							cell.column=column+columnCorrection;
							cell.ob=sortShape();		
							matrix[matrix.length]=cell;
							columnCorrection++;
						}
					}
					else if(columns[column].indexOf("B")==-1)
					{	
						cell = new Cell;
						cell.row=row;
						cell.column=column+columnCorrection;
						cell.ob=sortShape();
						matrix[matrix.length]=cell;
						columnCorrection++;
					}
					else{
						blankArr=(columns[column] as String).split("B");
						if(blankArr.length==2){
							if(!isNaN(blankArr[0] as Number))columnCorrection+=blankArr[0] as Number;
							else if(!isNaN(blankArr[1] as Number))columnCorrection+=blankArr[0] as Number;	
						}
						else columnCorrection++;

					}
				}
			}
			
			changeParams("rotation",getVar("matrixRotation"));
			
			var cellWidth:Number=getVar("cellWidth");
			var cellHeight:Number=getVar("cellHeight");
			var objWidth:Number=getVar("objWidth");
			var objHeight:Number=getVar("objHeight");
			var cellWidthMinObjWidth:Number=cellWidth-	objWidth;
			var cellHeightMinObjHeight:Number=cellHeight-	objHeight;
			
			for each(cell in matrix){
				cell.ob.x=cell.column	*cellWidth+		cellWidthMinObjWidth*Math.random();
				cell.ob.y=cell.row		*cellHeight+	cellHeightMinObjHeight*Math.random();
				
				super.pic.addChild(cell.ob);
			}
			pic.graphics.beginFill(0x000000,0);//this is needed if you have behaviours and want not to have to click an individual object for stuff to happen :-)
			pic.graphics.drawRect(0,0,pic.width,pic.height);
			pic.graphics.endFill();
		}
		/*
"B
B
B,B,[90]*6
B
B"
		*/
		
		private function changeParams(param:String,matrixStr:String):void
		{
			var rows:Array=matrixStr.split(rowSplit);
			var cell:Cell;
			var columns:Array;
			var columnCorrection:int;  //if blank cells are needed, this allows for x number of blank cells
			var blankArr:Array;
			var num:Number;
			var val:Number;
			for(var row:uint=0;row<rows.length;row++){
				columns=rows[row].split(",");
				columnCorrection=0;
				
				for(var column:uint=0;column<columns.length;column++){
					if(!isNaN(columns[column])){
						cell=searchMatrix(row,column+columnCorrection);
						//if(cell)cell.ob=sortShape();rotateAroundCenter(cell.ob,columns[column]);
						if(cell){
							myGradient = processGradient(getVar("gradient"),columns[column]);
							cell.ob=sortShape();
							//cell.ob.visible=false;
						}
					}
					else if(columns[column].indexOf("*")!=-1){
						blankArr=columns[column].split("*");
						if(blankArr.length==2)
						{
							if(blankArr[0].indexOf("[")!=-1){
								val=Number((blankArr[0] as String).replace("[","").replace("]",""));
								num= int(blankArr[1])
							}
							else if(blankArr[1].indexOf("[")!=-1){
								val=Number((blankArr[1] as String).replace("[","").replace("]",""));
								num= int(blankArr[0])
							}
							else {
								 columnCorrection++;
								break;
							}
						
							for(var i:uint=0;i<num;i++){
							
								cell=searchMatrix(row,column+columnCorrection);
								//if(cell)rotateAroundCenter(cell.ob,val);
								if(cell){
									myGradient = processGradient(getVar("gradient"),val);
									cell.ob=sortShape();
									//cell.ob.visible=false;
								}
								columnCorrection++;
							}
						}
					}
				}
			}
		}		
		
		private function searchMatrix(x:uint,y:uint):Cell{
			for(var i:int = 0; i < matrix.length; i++)
				{
					if(matrix[i].row==x && matrix[i].column==y){
						return matrix[i] as Cell;
						break;
					}
				}
			
			return null;
		}
	
		public static function spriteToBitmap(sprite:Sprite, smoothing:Boolean = false):Bitmap
		{
			var bitmapData:BitmapData = new BitmapData(sprite.width, sprite.height, true, 0x00FFFFFF);
			bitmapData.draw(sprite);
			
			return new Bitmap(bitmapData, "auto", smoothing);
			
		}
	
		
	}
}