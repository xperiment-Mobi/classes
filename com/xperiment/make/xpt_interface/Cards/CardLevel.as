package com.xperiment.make.xpt_interface.Cards
{
	import com.xperiment.make.xpt_interface.Bind.BindScript;

	public class CardLevel
	{
		public static const TRIAL_SPLIT:String = "_T";

		public var level:int=0;
		public var sort_level:Number=0;
		
		public var numTrialsInBlock:int = 1;
		public var description:String = "";
		
		public var group_id:String;
		private var enabled:Boolean=true;;
		
		
		public function CardLevel(trial:XML)
		{
			
			//vertical position
			calcLevel(trial.@block.toString())

			//number trials
			var str:String = trial.@trials.toString();
			if(str != "")	numTrialsInBlock = int(str);
			
			if(numTrialsInBlock==0){
				numTrialsInBlock=1;
				enabled=false;
			}
			
			//trialname
			if(trial.hasOwnProperty('@trialName') && trial.@trialName.toString().length!="") description=trial.@trialName.toString();

			//first half id
			group_id = trial.@[BindScript.bindLabel];

			//trace(str,group_id)
			
			//addToCardList(depth,numTrialsInBlock,trial.@[BindScript.bindLabel]+"_"+numTrialsInBlock.toString(), trialName);
		/*	obj = {desc:depth,horPosition:n,id:trialID};
			if(trialName!="")obj.groupId=trialName;
			obj.bitmap = BM.make(trialID);
			cardList.push(obj);*/
		}
		
		//calcLevel("1,2,2,3");
		private function calcLevel(str:String):void
		{
			if(str.length==0)throw new Error();
			
			var arr:Array = str.split(",");
			level=Number(	arr.shift()		);
			
			if(arr.length>0){
				str = level.toString()+".";
				for(var i:int=0;i<arr.length;i++){
					str+=arr[i];
				}
				sort_level = Number(str);
			}else{
				sort_level=level;
			}
			
		}
		
		
		
		public function generateAppendCards(startNum:int,rollingVertical:int,appendArr:Array, wantImages:Boolean):void{
			var obj:Object;
			
			for(var trialNum:int=0;trialNum<numTrialsInBlock;trialNum++){
				obj = {};
				obj.id = group_id+TRIAL_SPLIT+trialNum;	//{ text:String } a single card's unique ID formed from group_id + its horizontal position among peers in SAME group.
				obj.desc = description; //{ text:String = ""} text description of card. The user can give a card a text name if they want, else "" given. 
				obj.groupID	= group_id;	//{ text:String } each group has a unique id.
				obj.verPosition = level; //{ num:int	} vertical position (zero is top).
				obj.horPosition = startNum+trialNum; //{ num:int } horizontal position in the given row of cards (nb a row can consist of several groups).
				obj.enabled	= enabled; //could disabled trials be a lighter colour.
				if(wantImages)	obj.bitmap = BM.make(obj.id);
			
				appendArr.push(obj);
			}
		}
	}
}






import com.hurlant.util.Base64;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.utils.ByteArray;

class BM{
	
	static public function make(info:String):String{
		
		
		var s:Sprite = new  Sprite();
		s.graphics.beginFill(0xffffff*Math.random());
		s.graphics.drawRect(0,0,100,100);
		
		var t:TextField = new TextField();
		t.text = info;
		s.addChild(t);
		
		
		return displayObjectToString( s );;
	}
	
	public static function displayObjectToString( displayObject:DisplayObject ):String
	{
		var bmd:BitmapData = new BitmapData(displayObject.width, displayObject.height, true);
		bmd.draw( displayObject );
		
		var bytes:ByteArray = new ByteArray();
		bytes.writeUnsignedInt( bmd.width );
		bytes.writeBytes( bmd.getPixels(bmd.rect) );
		bytes.compress();
		
		return Base64.encodeByteArray( bytes );
	}
	
	public static function stringToBitmap( str:String ):Bitmap
	{
		var data:ByteArray = Base64.decodeToByteArray( str );
		var bmd:BitmapData;
		var bm:Bitmap;
		
		if( data )
		{
			data.uncompress();
			
			var w:int = data.readUnsignedInt();
			var h:int = ((data.length - 4) / 4) / w;
			
			bmd = new BitmapData(w, h, true, 0);				
			bmd.setPixels(bmd.rect, data);
			
			bm = new Bitmap(bmd);
		}
		
		return bm;
	}
	
}

