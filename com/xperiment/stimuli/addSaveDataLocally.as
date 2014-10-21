package com.xperiment.stimuli
{
	import com.bit101.components.Component;
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import com.bit101.utils.MinimalConfigurator;
	import com.xperiment.uberSprite;
	import com.xperiment.Results.Results;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.net.FileReference;

	public class addSaveDataLocally extends object_baseClass
	{
		
		public var myData:TextArea;
		private var results:Results;
		public var refresh:PushButton;
		
		override public function setVariables(list:XMLList):void {
			setVar("string","text","demo button");
			setVar("string","goto", "nextTrial");
			setVar("number","alpha",.9,"0-1");
			setVar("uint","fontSize",10);
			setVar("string","identifier","timeStamp");
			setVar("int","key",""); // use codes from here: http://www.asciitable.com/
			setVar("boolean","disableMouse",false);
			super.setVariables(list);
			
			
			if(getVar("behaviours")!="")setVar("string","goto","")
		}
		


		
		override public function RunMe():uberSprite {
			this.results=Results.getInstance();
			pic.graphics.drawRect(0,0,1,1);
			super.setUniversalVariables();
			
			var xml:XML = <comps>
							<Window title="save data menu" width={pic.width} height={pic.height}>
								<VBox y="10">
	 								<HBox x="10" y="10">
										<PushButton width="80" label="save data" event="click:saveToDisk"/>
										<PushButton width="140" label="copy to clipboard" event="click:clipboard"/>
										<PushButton id="refresh" width="80" label="refresh" event="click:refreshData"/>
	 								</HBox>
									<TextArea id="myData" text={getResults()} fontSize="20" x="10" y="20" width={pic.width-20} height={pic.height-80}/>
								</VBox>
							</Window>
						  </comps>;
			
			var config:MinimalConfigurator = new MinimalConfigurator(this);

			config.parseXML(xml);
			pic.scaleX=1;
			pic.scaleY=1;
			return (pic);
		}
		
		public function refreshData(event:MouseEvent):void
		{	
			myData.text=getResults();			
		}
		
		public function saveToDisk(event:MouseEvent):void
		{
			//
				
			var fileReference:FileReference=new FileReference();
			fileReference.save(myData.text, "SJdata"+identifier()+".sav");      
		}
		
		private function identifier():String
		{
			switch(getVar("identifier")){
				case "timeStamp":
					var date:Date=new Date();
					return "-"+date.seconds+"s-"+date.minutes+"mins-"+date.hours+"hrs-"+date.date+"-"+date.month+"-"+date.fullYear;
					break;
				default: return "";
			}
		}		
		
		public function clipboard(event:MouseEvent):void
		{
			System.setClipboard(myData.text);
		}
		
		private function getResults():String{
			var temp:String=results.finalResults as String;
			if(temp!=null) return "<Experiment>"+temp+"</Experiment>";
			temp=results.giveOngoingResults();
			if(temp!="") return "<Experiment>"+temp+"</Experiment>";
			else return "no data yet";			
		}
	

			
		
		
		
		override public function kill():void {

			super.kill();
		}
		
	
	}
}