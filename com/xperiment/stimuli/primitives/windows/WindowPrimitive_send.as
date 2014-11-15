package com.xperiment.stimuli.primitives.windows
{
	import com.bit101.components.PushButton;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.System;

	public class WindowPrimitive_send extends WindowPrimitive
	{
		

		
		public function WindowPrimitive_send(obj:Object)
		{
			super(obj);
		}
		
		override protected function setupButtons():void
		{
			super.setupButtons();
			
			params.sendButtonText = "try to send email automatically";
			params.pushButtonText = "copy to clipboard";
			
	
			params.sendButtonListener = send
			params.pushButtonListener = clipboard;
			
			
			button3 = new PushButton(myWindow,0,0,params.sendButtonText);
			button3.addEventListener(MouseEvent.CLICK,params.sendButtonListener,false,0,true);
			button3.width=250;
			button3.height=200
			button3.y=30;
		
			
			button2 = new PushButton(myWindow,0,0,params.pushButtonText);
			button2.addEventListener(MouseEvent.CLICK,params.pushButtonListener,false,0,true);
			button2.width=200;
			button2.height=200;
			button2.y=30;

		
		
			var placementWidth:int = myWindow.width - (closeButton.width+button2.width+button3.width);
			var gap:int = placementWidth/3;
			
			button3.x=gap;
			closeButton.x = myWindow.width-closeButton.width-gap;
			button2.x=button3.width+button3.x+gap*.5;
		
		}
		
		protected function clipboard(e:MouseEvent):void
		{
			System.setClipboard(textArea.text);
		}
		
		protected function send(e:MouseEvent):void
		{
/*			var connector:String = "?";
			
			var urlString:String = "mailto:";
			
			urlString += ExptWideSpecs.IS("toWhom");
			urlString += connector+"subject=";
			urlString +="emergencyEmail "+ExptWideSpecs.IS("subject");
			urlString += "&body=";
			urlString +="There was a problem when trying to save your results.  We hope you don't mind, but could you send this email to us. It contains a backup copy of your results. Thanks." 
			urlString += escape("\n\n"+String(textArea.text));
			//trace(urlString);
			//if(errInfo!="")urlString += "\n\n error Info:"+errInfo;				
			navigateToURL(new URLRequest(urlString));
			trace(123,urlString)*/
			
			
			var variables:URLVariables = new URLVariables();
			variables.subject = encodeURIComponent("emergencyBackupEmail "+ExptWideSpecs.IS("subject"));
			variables.body = encodeURIComponent("There was a problem when trying to save your results.  We hope you don't mind, but could you send this email to us. It contains a backup copy of your results. Thanks.") + encodeURIComponent("\n\n"+String(textArea.text));
			
			var email:URLRequest= new URLRequest('mailTo:'+ExptWideSpecs.IS("toWhom"));
			email.data = variables;
			navigateToURL(email);
		}

	}
}