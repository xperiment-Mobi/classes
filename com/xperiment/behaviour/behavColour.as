package com.xperiment.behaviour
{
	import com.greensock.TweenMax;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	//import com.greensock.plugins.TransformAroundCenterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.xperiment.codeRecycleFunctions;
	import com.xperiment.uberSprite;
	import com.xperiment.stimuli.object_baseClass;
	
	import flash.utils.Dictionary;
	


	public class behavColour extends behav_baseClass
	{
	
		private var tweens:Vector.<TweenMax>;
		
		override public function setVariables(list:XMLList):void {
			
			//setVar("int","rotation",180);
			setVar("int","duration",0);
			setVar("string","colour",0);
			setVar("int","brightness",1,'1 is normal brightness, 0 is much darker than normal, and 2 is twice the normal brightness, etc.');
			setVar("int","hue",0,'changes the hue of every pixel. Think of it as degrees, so 180 would be rotating the hue to be exactly opposite as normal, 360 would be the same as 0, etc.');
			setVar("int","saturation",1,'1 is normal saturation, 0 makes the DisplayObject look black and white, and 2 would be double the normal saturation');
			setVar("int","contrast",1,'1 is normal contrast, 0 has no contrast, and 2 is double the normal contrast, etc.');
			setVar("int","amount",1,'0 to 1');
			super.setVariables(list);
			//TweenPlugin.activate([TransformAroundCenterPlugin]);
			
			TweenPlugin.activate([ColorMatrixFilterPlugin]);
			
		}	
		
		override public function returnsDataQuery():Boolean {
			if(getVar("save")!=""){
				return true;
			}
			return false;
		}
		
		
		
		override public function kill():void{
			for each(var tween:TweenMax in tweens){
				tween.kill();
				tween=null;
			}
			tweens=null;
		}
		
		override public function myUniqueProps(prop:String):Function{
			uniqueProps ||= new Dictionary;
			if(uniqueProps.hasOwnProperty('colour')==false){
				uniqueProps.colour= function(what:String=null,to:String=null):String{
					
					if(to!=null){
						OnScreenElements.colour = to;
						nextStep();
					}
					return String(getVar("colour"));
				}; 
				
				uniqueProps.color=uniqueProps.colour
			}
			
			if(uniqueProps.hasOwnProperty('reverse')==false){	
				uniqueProps.reverse= function(what:String=null,to:String=null):String{
					reverse();
					return 'true';
				};  
			}

			
			if(uniqueProps.hasOwnProperty(prop)) return uniqueProps[prop]
			return super.myUniqueProps(prop);
		}
		
		private function reverse():void
		{
			if(tweens){
				for each(var tween:TweenMax in tweens){
					tween.reverse();
				}
				
			}
			
		}		
		
		
		override public function nextStep(id:String=""):void{

			var col:String = getVar("colour");
			if(col=='')col = getVar("color");
			
			//col=hack();
			
			var dur:int= int(getVar("duration"));
			
			this.ran=true;
			
			tweens ||= new Vector.<TweenMax>;
			
			var tween:TweenMax;
			
			var rand:Boolean = OnScreenElements.hasOwnProperty("rainbow");
			var colInt:int=codeRecycleFunctions.getColour(col);
			
			for each(var stimulus:uberSprite in behavObjects){
				
				if(rand) colInt = Math.random()*0xffffff;

				tween = TweenMax.to(stimulus, dur, {colorMatrixFilter:{colorize:colInt, amount:getVar("amount"),hue:getVar("hue"),brightness:getVar("brightness"),saturation:getVar("saturation"),contrast:getVar("contrast")}});
				tweens.push(tween);
			}
		}
		
		override public function storedData():Array {
			
			var stim:object_baseClass;
			var sav:String = getVar("save");
			
			objectData.push({event:peg,data:OnScreenElements.colour});
				
			
			return super.objectData;
		}
		
		//private static var hackProcessed:Array;
		//private static var hackProcessedLabels:Array = [];
		
		/*private function hack():String
		{
			
			if(!hackProcessed){
				
				function add(a1:Array,a2:Array,lab:String):void{
					tempArr.push({a:a1[0],b:a2[0],label:lab});
					tempArr.push({a:a1[0],b:a2[1],label:lab});
					tempArr.push({a:a1[0],b:a2[2],label:lab});
					tempArr.push({a:a1[1],b:a2[0],label:lab});
					tempArr.push({a:a1[1],b:a2[1],label:lab});
					tempArr.push({a:a1[1],b:a2[2],label:lab});
					tempArr.push({a:a1[2],b:a2[0],label:lab});
					tempArr.push({a:a1[2],b:a2[1],label:lab});
					tempArr.push({a:a1[2],b:a2[2],label:lab});
				}
				
				function add2(a1:Array,lab:String):void{
					tempArr.push({a:a1[0],b:a1[1],label:lab});
					tempArr.push({a:a1[0],b:a1[2],label:lab});
					tempArr.push({a:a1[1],b:a1[2],label:lab});
				}
				
			
				
				//var hack:Array = behavDrag.hack;
					
					
				var hack:Array =[{colour:0x2D859C,x:220.3,name:"a"},{colour:0xFFFFFF,x:252.05,name:"a"},{colour:0x494949,x:282.75,name:"a"},{colour:0x186F50,x:324.9,name:"a"},{colour:0xADADAD,x:403.35,name:"a"},{colour:0xE61C8E,x:452.1,name:"a"},{colour:0xFFE51D,x:465.6,name:"a"},{colour:0x228982,x:478.55,name:"a"},{colour:0x790894,x:566.95,name:"a"},{colour:0xDD7D15,x:617.75,name:"a"},{colour:0x2062A5,x:632.55,name:"a"},{colour:0xF4083D,x:660.9,name:"a"},{colour:0x9CBC27,x:661.5,name:"a"}];
				//[{colour:1,x:220.3},{colour:2,x:252.05},{colour:3,x:282.75},{colour:4,x:324.9},{colour:5,x:403.35},{colour:6,x:452.1},{colour:7,x:465.6},{colour:8,x:478.55},{colour:9,x:566.95},{colour:10,x:617.75},{colour:11,x:632.55},{colour:12,x:660.9},{colour:13,x:661.5}];
				
				
				
				var tempArr:Array=[];
				
				hackProcessed=[];
				var left:Array = [hack[0],hack[1],hack[2]];
				var middle:Array=[hack[5],hack[6],hack[7]];
				var right:Array=[hack[10],hack[11],hack[12]];
				
				add(left,middle,"leftMiddle");
				add(left,right,"leftRight");
				add(right,middle,"rightMiddle");
				add2(left,"leftLeft");
				add2(right,"rightRight");
				add2(middle,"middleMiddle");
				
				
				codeRecycleFunctions.arrayShuffle(tempArr);
				for each(var comb:Object in tempArr){

					if(Math.random()>.5){
						hackProcessed.push(comb.a.colour);
						hackProcessed.push(comb.b.colour);
					}
					else{
						hackProcessed.push(comb.b.colour);
						hackProcessed.push(comb.a.colour);
					}
					hackProcessedLabels.push(comb.label+"_"+comb.a.name+","+comb.b.name+"_"+comb.a.x+","+comb.b.x);
					hackProcessedLabels.push("");
				}

			}
			
			var txt:String = hackProcessedLabels.shift()
			if(txt!="")objectData.push({event:'label',data:txt});
			
			OnScreenElements.colour = hackProcessed.shift();

			return OnScreenElements.colour;
		}*/
	}
	
	
	
}