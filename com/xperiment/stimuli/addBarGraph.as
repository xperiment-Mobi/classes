package com.xperiment.stimuli
{

	import com.greensock.TweenLite;
	import com.xperiment.uberSprite;
	import com.xperiment.Results.Results;
	import com.xperiment.stimuli.helpers.GetData;
	import com.xperiment.stimuli.primitives.graphs.bar.Bar;
	import com.xperiment.stimuli.primitives.graphs.bar.BarChart;
	import com.xperiment.stimuli.primitives.graphs.bar.BarData;
	
	import flash.events.Event;

	
	public class addBarGraph extends object_baseClass
	{

		private var chart:BarChart;
		private var data:Vector.<BarData>;
		private var columnNames:Array;
		private var columnCols:Array;
		private var DVs:Array;
		
		override public function setVariables(list:XMLList):void {	
			setVar("string","columnNames","BrainyWhite,BikeWhite,BrainyRed,BikeRed");
			setVar("string","DVs","brainyred1_*,bikered1_*,brainywhite1_*,bikewhite1_*");
			setVar("string","columnHues","0xFFFFFF,0x4f4f4f");
			super.setVariables(list);
			

			columnCols = getVar("columnHues").split(",");
			columnNames= getVar("columnNames").split(",");
			DVs		   = getVar("DVs").split(",");
		}
		

		override public function RunMe():uberSprite {

			
			super.setUniversalVariables();
			pic.scaleX=1;
			pic.scaleY=1;

			return (pic);
		}
		
		
		override public function appearedOnScreen(e:Event):void{
			


			//	var params:Object = {trialNames:"abc*,abd*",maths:"average,stderr,stdev",dv:"c", criteria:"a!=2,c>=1"};
				var params:Object = {trialNames:getVar("DVs"),maths:"average,stderr",dv:"rt", criteria:"ans==1", absent:0,maxValue:5000};
				params = GetData.retrieve(params,Results.getInstance().ongoingExperimentResults);

				
				var barData:Vector.<BarData> = new Vector.<BarData>;
				
				var nam:String;
				var dv:String;
				var hue:String;
				var col:int;
				for(var i:int=0;i<columnNames.length;i++){
					nam=columnNames[i];
					hue=columnCols[i%columnCols.length];
					dv =DVs[i];
					barData.push(new BarData(nam, params[dv].average,params[dv].stderr,int(hue)));
				
				}
				//data.push(new BarData("January", 60,10));
				//data.push(new BarData("February", 100,5));
				//data.push(new BarData("March", 30,15));// TODO Auto Generated method stub
				
			
			params = {width:pic.myWidth, height:pic.myHeight}
			chart = new BarChart(barData, params);
			pic.addChild(chart);
			
			
			var bars:Vector.<Bar> = chart.bars;
			var tweens:Vector.<TweenLite> = new Vector.<TweenLite>;
			
			var tall:int;
			for(i=0;i<bars.length;i++){
				tall = bars[i].height;
				tweens[tweens.length] = TweenLite.fromTo(bars[i],1,{height:0},{height:tall});
			}
			
			
			super.appearedOnScreen(e);
		}
		
		
		
		override public function kill():void {

			super.kill();
			
		}
	}
}