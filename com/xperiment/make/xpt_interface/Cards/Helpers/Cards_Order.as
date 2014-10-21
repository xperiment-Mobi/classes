package com.xperiment.make.xpt_interface.Cards.Helpers
{
	import com.xperiment.make.xpt_interface.Cards.CardLevel;

	public class Cards_Order
	{
		static public function GET(script:XML, wantCardLevels:Boolean, wantImages:Boolean):Array
		{
			
			//trace(runner.trialProtocolList)
			var cardList:Array = [];
			var card:CardLevel;
	
			for (var depth:int=0; depth<script.TRIAL.length(); depth++) { 
				card=new CardLevel(script.TRIAL[depth]);
				cardList.push(card);
				
			}
			
			cardList.sortOn("level",Array.NUMERIC);
			if(wantCardLevels) 	return cardList;
			
			var finalList:Array = [];
			
			var prevLevel:int;
			var startVal:int;
			var prevLength:int;
			var rollingVertical:int = -1;
			
			while(cardList.length>0){
				card = cardList.shift();
				
				if(prevLevel && prevLevel==card.level){
					startVal 	= 	prevLength;
					prevLength	+=	card.numTrialsInBlock;
				}
				else{
					startVal	=	0;
					prevLength	=	card.numTrialsInBlock;
					rollingVertical++;
				}
				
				prevLevel = 	card.level;
				
				card.generateAppendCards(startVal,rollingVertical,finalList,wantImages);
				card=null;
			}

			return finalList;
		}
		
		
	}
}