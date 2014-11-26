package com.xperiment.stimuli.Controls
{
	import com.bit101.components.Style;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.stimuli.primitives.shape;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;

	public class Button extends Sprite
	{
		public var DOfunctions:Vector.<Function> = new Vector.<Function>;
		
		private var circledown:Shape;
		private var circle:Shape;
		private var icon:Sprite;
		private var timer:Timer = new Timer (500,1);
		
		private var myWidth:int=100;
		private var myHeight:int=100;
		
		public static var timeToDrag:int = 500;
		
		public function kill():void{
			timer.stop();
			this.removeEventListener(MouseEvent.MOUSE_DOWN,MouseListener);
			this.removeEventListener(MouseEvent.MOUSE_UP,MouseListener);
			this.removeEventListener(MouseEvent.CLICK,MouseListener);
			this.removeEventListener(MouseEvent.RELEASE_OUTSIDE,MouseListener);
			for(var f:String in DOfunctions){
				delete DOfunctions[f];
			}
			DOfunctions=null;
			
			
			this.removeChild(circle);
			this.removeChild(circledown);
			this.removeChild(icon);
			circle=null; circledown=null;
		}
		
		public function ON(yes:Boolean):void{
			circledown.visible=yes;
		}
		
		public function Button(type:String,f:Function){
			DOfunctions.push(f);
			this.name=type;
			//this.graphics.beginFill(Style.BUTTON_FACE,0);
			//this.graphics.drawRect(0,0,100,100);
			
			circle = shape.makeShape("circle",0,0,0,Style.BUTTON_FACE,myWidth*.9,myHeight*.9);
			circledown = shape.makeShape("circle",0,0,0,Style.BUTTON_DOWN,myWidth*.9,myHeight*.9);
			
			this.addChild(circle);
			this.addChild(circledown);
			
			codeRecycleFunctions.centre(circledown,myWidth,myHeight);
			codeRecycleFunctions.centre(circle,myWidth,myHeight);
			icon= new Sprite;
			
			if(["left","right","up","down"].indexOf(type)!=-1){icon.addChild(shape.makeShape("triangle",0,0,0,Style.LIST_SELECTED,this.width*.6,this.height*.6));
				this.addChild(icon);
				codeRecycleFunctions.centre(icon,myWidth,myHeight);
				
				switch(type){
					case "left":
						codeRecycleFunctions.rotateAroundCenter(icon,90);
						break;
					case "right":
						codeRecycleFunctions.rotateAroundCenter(icon,270);
						break;
					case "up":
						codeRecycleFunctions.rotateAroundCenter(icon,180);
						break;
					case "down":
						break;
					default:
						throw new Error();
					
				}
			}
			else if(type=="pause"){
				var left:Shape = shape.makeShape("square",0,0,0,Style.LIST_SELECTED,this.width*.2,this.height*.6);
				var right:Shape = shape.makeShape("square",0,0,0,Style.LIST_SELECTED,this.width*.2,this.height*.6);
				icon.addChild(left);
				icon.addChild(right);
				
				
				right.x=left.x=myWidth*.5-left.width*.5
				left.x+=left.width*.75;
				right.x-=left.width*.75;
				left.y=right.y=myHeight*.5-right.height*.5;
				
				this.addChild(icon);
			}
			else if(type=="stop"){

				icon.addChild(shape.makeShape("square",0,0,0,Style.LIST_SELECTED,this.width*.5,this.height*.5));
				codeRecycleFunctions.centre(icon,myWidth,myHeight);
				this.addChild(icon);
			}
			
			else if(["start","end"].indexOf(type)!=-1){
				
				var bar:Shape = shape.makeShape("square",0,0,0,Style.LIST_SELECTED,this.width*.6,this.height*.1);
				var arror:Shape = shape.makeShape("triangle",0,0,0,Style.LIST_SELECTED,this.width*.6,this.height*.3);
				
				icon.addChild(bar);
				icon.addChild(arror);

				bar.y+=myHeight*.3

				codeRecycleFunctions.centre(icon,myWidth,myHeight);
				
				this.addChild(icon);
				
				var rotate:int=90;
				if(type=='end')rotate=270;
				codeRecycleFunctions.rotateAroundCenter(icon,rotate);
			}	
				
			this.addEventListener(MouseEvent.MOUSE_DOWN,MouseListener);
			this.addEventListener(MouseEvent.MOUSE_UP,MouseListener);
			this.addEventListener(MouseEvent.CLICK,MouseListener);
			this.addEventListener(MouseEvent.RELEASE_OUTSIDE,MouseListener);
			
			circledown.visible=false;
						
			this.useHandCursor=true;
			this.buttonMode=true;
		}
		


		private function timerStart():void{
			timer.reset();
			timer.start();
		}
	
		
		private function MouseListener(e:MouseEvent):void{

			if(e.type==MouseEvent.MOUSE_DOWN){
				circledown.visible=true;
				timerStart();
			}

			else if(e.type==MouseEvent.MOUSE_UP){// || e.type==MouseEvent.RELEASE_OUTSIDE){
				circledown.visible=false;
			}
			else if(e.type==MouseEvent.CLICK){
				if(timer.running){
					for(var f:String in DOfunctions){
						if(
							DOfunctions[f]() //run the function
							==false) delete DOfunctions[f]; //if returns false, delete the function
					}
				}
			}
		}
	}
}