package com.xperiment.make.xpt_interface.Cards.Helpers
{
	import com.xperiment.make.xpt_interface.Cards.CardLevel;

	public class Cards_orderChange
	{

		public static var __newOrder:NewOrder;
		
		public static function DO(raw_newOrder:Array,oldOrder:Array, orig_script:XML, testing:Boolean=false):void
		{
			//raw_newOrder = [[["Bouba2_12_T0","Bouba2_12_T1"]],[["Bouba2_4_T0","Bouba2_4_T1"]]];
			
			//Array of Objects, [ {BIND_ID: [1,2,3]} , etc ] 
			//where [1,2,3] are the orig Trial orders but perhaps changed
			
			var blockOrderList:Array = getBlockList(oldOrder);

			__newOrder = new NewOrder(raw_newOrder,blockOrderList);
			
			__newOrder.updateTrialOrders(orig_script);
			__newOrder.updateBlockOrders();
			
			if(!testing) __newOrder=null;
			
		}
		


		
		
		private static function getBlockList(oldOrder:Array):Array
		{
			var arr:Array = [];
			var c:CardLevel;
			
			for(var i:int=0; i<oldOrder.length;i++){
				c=oldOrder[i];
				arr.push(c.level);				
			}
			return arr;
		}
	}
}




import com.xperiment.make.xpt_interface.Bind.BindScript;
import com.xperiment.make.xpt_interface.Bind.Bind_MultiStim_change;
import com.xperiment.make.xpt_interface.Cards.CardLevel;

class NewOrder{
	
	public var __stacks:Vector.<Stack> = new Vector.<Stack>;
	
	public function NewOrder(data:Array, listOfBlocks:Array){
		
		equaliseLengths(data,listOfBlocks); 

		for(var i:int =0;i<data.length;i++){
			__stacks[__stacks.length]= new Stack(data[i].toString().split(","),listOfBlocks[i]);
			//trace(1123,stacks[stacks.length-1].bind_id,stacks[stacks.length-1].newOrder);
		}
	}
	
	
/*	var arr1:Array= [1,2,300];
	var arr2:Array= [1,2,3,4,5];
	equaliseLengths(arr2,arr1);
	trace(arr1)// = 1,2,300,301,302
	*/
	private function equaliseLengths(data:Array, listOfBlocks:Array):void
	{
		if(listOfBlocks.length<data.length){
			var max:int = listOfBlocks[listOfBlocks.length-1];
			var count:int=1;
			for(var i:int = listOfBlocks.length;i<data.length;i++){
				listOfBlocks.push(max+count);
				count++;
			}
		}
	}
	
	public function updateBlockOrders():void
	{
		var stack:Stack;
		var wasChange:Boolean = false;
		for(var i:int=0;i<__stacks.length;i++){
			wasChange=true;
			stack=__stacks[i];
			BindScript.updateAttrib(stack.bind_id,'block',stack.newOrder,null,-1,null,false);
		}
		BindScript.updated(['Cards_orderChange.updateBlockOrders']);
	}
	
	public function updateTrialOrders(orig_script:XML):void
	{
		var stack:Stack;
		for(var i:int=0;i<__stacks.length;i++){
			stack=__stacks[i];
			if(stack.trialOrderChanged){
				Bind_MultiStim_change.DO(stack.bind_id,stack.trials,orig_script);
			}
		}
		
	}
}

class Stack{
	
	public var bind_id:String;
	public var trials:Array = [];
	public var trialOrderChanged:Boolean = false;
	public var newOrder:int;
	
	
	public function Stack(st:Array, n:int){
		newOrder = n;
		var obj:Object = {};
		var arr:Array = st[0].toString().split(CardLevel.TRIAL_SPLIT);
		
		bind_id = arr.shift();

		for(var i:int=0;i<st.length;i++){
			trials.push(int(st[i].split(CardLevel.TRIAL_SPLIT)[1]));
			if(i!=trials[trials.length-1]) trialOrderChanged = true;
		}
	}
}

