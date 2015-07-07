package com.xperiment.behaviour {

	import com.xperiment.onScreenBoss.OnScreenBoss;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.events.Event;


public class behavShapePattern extends behav_baseClass{

		private var bg:object_baseClass;
		private var pattern:ShapePattern;

		override public function setVariables(list:XMLList):void {
			
			//list.@depth=100000;
			setVar("string","background",'','','');
			setVar("string","shape","triangle","currently only triangle and diamond supported");
			setVar("number", "fillParentRatio",1, "", "");
			setVar("string","hide","","");
			super.setVariables(list);
			setUniversalVariables();
			depth = OnScreenBoss.BOTTOM;
	
		}


		override public function appearedOnScreen(e:Event):void{
			super.appearedOnScreen(e);
			sortStimuli();
			if(bg) pattern.sortBackground(bg);	
			pattern.make();
			
			
		}
		

		

		private function sortStimuli():void {
			
			var bgPeg:String = getVar("background");
			pattern = new ShapePattern(this, OnScreenElements);
			var hide:Array = getVar("hide").split(",");
			var hide_i:int;

			for each(var stim:object_baseClass in behavObjects){
		
				if(stim.peg == bgPeg) bg = stim;
				else{
				
					hide_i= hide.indexOf(stim.peg);
					if(hide_i==-1){
						pattern.add(stim);
					}
					else{
						hide.splice(hide_i,1);
						stim.visible = false;
					}
				}
			}
			
		
		}

		
		override public function setUniversalVariables():void {		
			if(pic){
				sortOutScaling();
				sortOutWidthHeight();
				setContainerSize();	
				setPosPercent();
				sortOutPadding();
				if(getVar("opacity")!=1)pic.alpha=getVar("opacity");
				
				/*this.graphics.beginFill(0x000343,1);
				this.scaleX=this.scaleY=1;
				this.graphics.drawRect(0,0,myWidth,myHeight);*/
			}
			
			if(getVar("mouseTransparent") as Boolean)mouseTransparent();
			
		}
		
		override public function kill():void{


			super.kill();
		}


			
	}
}
import com.xperiment.codeRecycleFunctions;
import com.xperiment.stimuli.object_baseClass;
import flash.geom.Point;

class ShapePattern{
	
	private var parent:object_baseClass;
	private var _stimuli:Array = [];
	private var params:Object;
	
	
	
	public function ShapePattern(parent:object_baseClass, params:Object){
		this.parent = parent;
		this.params = params;
	}
	
	
	public function add(stim:object_baseClass):void
	{

		_stimuli.push(stim);
		
	}



	public function make():void
	{
		var fillParentRatio:Number = params.fillParentRatio;
		var shape:String = params.shape;

		
		codeRecycleFunctions.arrayShuffle(_stimuli);
		
		var pattern:Vector.<Point> = new Vector.<Point>;
		
		generatePattern(shape,fillParentRatio,pattern);
		pruneStim(pattern.length,_stimuli);
		addStimToPattern(_stimuli, pattern);
		
	}
	
	private function addStimToPattern(stimuli:Array, pattern:Vector.<Point>):void
	{
		var stim:object_baseClass;
		var point:Point;
		
		if(stimuli.length!=pattern.length)throw new Error();
		
		for(var i:int=0;i<stimuli.length;i++){
			stim = stimuli[i];
			point = pattern[i];
			
			
			stim.myX = stim.x = point.x-stim.myWidth*.5;
			stim.myY = stim.y = point.y-stim.myHeight*.5;
		}
	}
	
	private function pruneStim(length:uint, stimuli:Array):void
	{
		if(stimuli.length<length)	throw new Error("not enough stimuli");
		
		for(var i:int=stimuli.length-1;i>=length;i--){
			(stimuli[i] as object_baseClass).visible = false;
			stimuli.splice(i,1);
		}
	}
	

	
	private function generatePattern(shape:String,fillParentRatio:Number,pattern:Vector.<Point>):Vector.<Point>
	{
		
		var width:int = fillParentRatio * parent.myWidth;
		var height:int = fillParentRatio *parent.myHeight;
		
		var shapeStr:String = shape.toLowerCase();
		

		
		if(this[shapeStr]){
			this[shapeStr](width,height,pattern);
		}
		else	throw new Error("unknown pattern");
		
		
		center(pattern,parent, width, height);
		parentRefFrame(pattern);
		
		return pattern;
	}
	
	
	
	private function parentRefFrame(pattern:Vector.<Point>):void
	{		
		for each(var point:Point in pattern){
			point.x+=parent.myX;
			point.y+=parent.myY;
		}
	}
	
	private function v2(width:int, height:int, pattern:Vector.<Point>):Vector.<Point>
	{
		pattern.push(	new Point(width*.5,0)	);
		pattern.push(	new Point(width*.5,height)	);
		
		return pattern;
	}
	
	private function v3(width:int, height:int, pattern:Vector.<Point>):Vector.<Point>
	{
		pattern.push(	new Point(width*.5,0)	);
		pattern.push(	new Point(width*.5,height*.5)	);
		pattern.push(	new Point(width*.5,height)	);
		
		return pattern;
	}
	
	private function v4(width:int, height:int, pattern:Vector.<Point>):Vector.<Point>
	{
		pattern.push(	new Point(width*.5,0)	);
		pattern.push(	new Point(width*.5,height*.333)	);
		pattern.push(	new Point(width*.5,height*.666)	);
		pattern.push(	new Point(width*.5,height)	);
		
		return pattern;
	}
	
	private function duo(width:int, height:int, pattern:Vector.<Point>):Vector.<Point>
	{
		pattern.push(	new Point(width,height*.5)		);
		pattern.push(	new Point(0,height*.5)			);
		
		return pattern;
	}
	
	private function dot(width:int, height:int, pattern:Vector.<Point>):Vector.<Point>
	{
		pattern.push(	new Point(width*.5,height*.5)				);
		return pattern;
		
	}
	
	private function diamond(width:int, height:int, pattern:Vector.<Point>):Vector.<Point>
	{

		
		pattern.push(	new Point(0,0)				);
		pattern.push(	new Point(width,0)			);
		pattern.push(	new Point(width,height)		);
		pattern.push(	new Point(0,height)			);
		
		return pattern;
	}
	
	private function triangle(width:int, height:int, pattern:Vector.<Point>):Vector.<Point>
	{
			
		pattern.push(	new Point(width*.5,0)		);
		pattern.push(	new Point(width,height)		);
		pattern.push(	new Point(0,height)			);

		
		return pattern;
		
	}	
	
	/*private function drawT(pattern:Vector.<Point>):void
	{
		var spr:Sprite = new Sprite;
		spr.graphics.beginFill(0x444444,1);
		spr.graphics.lineStyle(1,0x448888);
		for(var i:int=0;i<pattern.length;i++){
			var p:Point = pattern[i];
			
			if(i==0){
				spr.graphics.moveTo(p.x,p.y);
			}
			else{
				spr.graphics.lineTo(p.x,p.y);
			}
		}
	spr.x=parent.x;
	spr.y=parent.y;
		parent.stage.addChild(spr);
	
	}	*/

	private function center(pattern:Vector.<Point>, parent:object_baseClass, width:int, height:int):Vector.<Point>
	{
		var startX:int = (parent.myWidth - width) *.5;
		var startY: int =(parent.myHeight - height) *.5;
		
		for each(var point:Point in pattern){
			point.x+=startX;
			point.y+=startY;
		}
		
		return pattern;
	}

	public function sortBackground(bg:object_baseClass):void
	{

		
		bg.myX = bg.x = parent.myX + parent.myWidth*.5 - bg.myWidth*.5 ;
		bg.myY = bg.y = parent.myY + parent.myHeight*.5 - bg.myHeight*.5;
		
		bg.depth=50;
		
	}
}
	

