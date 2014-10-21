package com.xperiment.make.xpt_interface.Cards
{

	import com.hurlant.util.Base64;
	import com.xperiment.make.xpt_interface.Bind.BindScript;
	import com.xperiment.make.xpt_interface.Bind.Bind_addTrial;
	import com.xperiment.make.xpt_interface.Bind.Bind_delTrial;
	import com.xperiment.make.xpt_interface.Cards.Helpers.Cards_Order;
	import com.xperiment.make.xpt_interface.Cards.Helpers.Cards_orderChange;
	
	import flash.utils.ByteArray;

	public class Cards
	{
		private static var comms:Function;
		private static var refreshScript:Function;
		
		
		public static function setup(u:Function, r:Function=null):void
		{

			comms = u;
			refreshScript = r;
			//CardOrderMem.init();
		}
		
		
		public static function generateInstructions():void
		{

			var finalList:Array = Cards_Order.GET(BindScript.script,false, true);
			
			//trace(34,JSON.stringify(finalList));
			var ba:ByteArray = new ByteArray();
			ba.writeObject(finalList);			
			ba.position=0;
			//trace(123,JSON.stringify(finalList));
			if(comms)	comms('setCards',Base64.encodeByteArray(ba));
			if(refreshScript)	refreshScript(['Cards.freshCardsApp']);
		}
		
		
			

			
		public static function change(data:Array, testing:Boolean=false):void
		{
			// TODO Auto Generated method stub
			//change {"rowsAsStringArray":[["Taste_17_0"],["Taste_8_0"],[["Taste_27_0","Taste_27_1","Taste_27_2"]],["Taste_30,Taste_67_0"],["Taste_31,Taste_67_0"],["Taste_32,Taste_67_0"],["Taste_33,Taste_67_0"],["Taste_34,Taste_67_0"],["Taste_35,Taste_67_0"],["Taste_36,Taste_67_0"],["Taste_37,Taste_67_0"],["Taste_38,Taste_67_0"],[["Taste_39,Taste_59_0","Taste_39,Taste_59_1","Taste_39,Taste_59_2","Taste_39,Taste_59_3"]],[["Taste_41,Taste_59_0","Taste_41,Taste_59_1","Taste_41,Taste_59_2","Taste_41,Taste_59_3"]],[["Taste_43,Taste_59_0","Taste_43,Taste_59_1","Taste_43,Taste_59_2","Taste_43,Taste_59_3"]],[["Taste_45,Taste_59_0","Taste_45,Taste_59_1","Taste_45,Taste_59_2","Taste_45,Taste_59_3"]],[["Taste_47,Taste_59_0","Taste_47,Taste_59_1","Taste_47,Taste_59_2","Taste_47,Taste_59_3"]],[["Taste_49,Taste_59_0","Taste_49,Taste_59_1","Taste_49,Taste_59_2","Taste_49,Taste_59_3"]],[["Taste_51,Taste_59_0","Taste_51,Taste_59_1","Taste_51,Taste_59_2","Taste_51,Taste_59_3"]],[["Taste_53,Taste_59_0","Taste_53,Taste_59_1","Taste_53,Taste_59_2","Taste_53,Taste_59_3"]],[["Taste_55,Taste_59_0","Taste_55,Taste_59_1","Taste_55,Taste_59_2","Taste_55,Taste_59_3"]],[["Taste_57,Taste_59_0","Taste_57,Taste_59_1","Taste_57,Taste_59_2","Taste_57,Taste_59_3"]],["Taste_70_0"]]}
			//trace("change",JSON.stringify(data));			
			Cards_orderChange.DO(data,Cards_Order.GET(BindScript.script,true,true),BindScript.script, testing);
		}
		
		

		
		public static function editCard(cardId:String):void
		{
			// TODO Auto Generated method stub
			
			trace("editCard");
		}
		
		public static function editCardGroup(cardGroupId:String):void
		{
			// TODO Auto Generated method stub
			trace("cardGroupId");
		}
		
		
		public static function addTrials(data:Object):void //for unit testing
		{
			///trace(123,JSON.stringify(data));
			Bind_addTrial.DO(data);
			generateInstructions();
			//var orders:Array = Cards_Order.GET(BindScript.script,false,false);
			//generateInstructions();
			/*			
			var ba:ByteArray = new ByteArray();
			ba.writeObject(orders);			
			ba.position=0;
			trace(11211113,JSON.stringify(orders));
			if(comms)	comms('setCards',Base64.encodeByteArray(ba));*/
			//return orders
		}
		
		public static function deleteTrials(obj:Object):void
		{
			Bind_delTrial.DO(obj.cards,obj.groups);
			generateInstructions();
			
		}
	}
}
