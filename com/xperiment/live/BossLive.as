package com.xperiment.live
{
	import com.reyco1.multiuser.data.UserObject;
	
	import flash.display.Stage;


	public class BossLive
	{
		private var studyName:String;
		private var foyer:FoyerLive
		public var expt:ExptLive;
		public var toUI:Function;
		
		public function BossLive(nam:String,theStage:Stage,studyName:String,password:String):void{
			foyer = new FoyerLive(studyName,password,theStage);
			expt  = new ExptLive(studyName,theStage);
		}
		
		
		public function serviceComms(Object):Object{
			return '';
		}
		
		public function fromUI(obj:Object):void{
			throw new Error();	
		}
	}
}


import com.reyco1.multiuser.data.UserObject;
import com.xperiment.live.AbstractLive;

import flash.display.Stage;


class FoyerLive extends AbstractLive{
	
	private var details:String;

	public function FoyerLive(studyName:String, password:String, theStage:Stage){
		this.details = studyDetails(studyName,password).combined;
		super(theStage,true);
	}
	
	override protected function setupLive():void
	{
		super.setupLive();
		connection.onUserAdded 		= handleUserAdded;
	
	}

	
	// method should expect a UserObject
	protected function handleUserAdded(user:UserObject):void				
	{
		//Logger.log("User added: " + user.name + ", total users: " + connection.userCount);
		connection.sendChatMessage(details,user);
	}
	
	
}