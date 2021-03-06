package com.mobile.Notifications
{
	import com.Start.MobilePlayerStart.MobilePlayerStart;
	import com.hurlant.util.Base64;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	import com.xperiment.StarlingSingleton.Base;
	import com.xperiment.events.GlobalFunctionsEvent;
	
/*	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
*/
	public class NotificationHelper
	{
	
		public static var data:Object;
		
		private static var notification:Mobile_Notifications
		private static var playerStart:MobilePlayerStart;
		
		

		public static function INIT(p:MobilePlayerStart):void
		{
			playerStart = p;
			
			if(!notification){
				notification = new Mobile_Notifications(notification_started);
				/*var t:Timer = new Timer(500);
				t.addEventListener(TimerEvent.TIMER,function(e:Event):void{
					t.removeEventListener(TimerEvent.TIMER,arguments.callee);
				
				});
				t.start();*/
				//notification_started({script:"PEJvdWJhMiBleHB0VHlwZT0iV0VCIj48U0VUVVA+PGluZm8gaWQ9IjBhNjZmNjRmZDljNjQ4YzNhZTkyODg5YWE2NjA0MGEwIi8+PHNjcmVlbiBCR2NvbG91cj0iYmxhY2siIHdpZHRoPSIxMDI0IiBoZWlnaHQ9Ijc2OCIgYXNwZWN0UmF0aW89InN0cmV0Y2giIG9yaWVudGF0aW9uPSJob3Jpem9udGFsIi8+PGNvbXB1dGVyIHN0aW11bGlGb2xkZXI9InZpYnJvZm9uZSIgZW5jcnlwdD0idHJ1ZSIvPjx2YXJpYWJsZXMvPjwvU0VUVVA+PFRSSUFMIFRZUEU9IlRyaWFsIiB0cmlhbE5hbWU9IkRvRXhwdCIgaGlkZVJlc3VsdHM9InRydWUiIGJsb2NrPSIwIiBvcmRlcj0iZml4ZWQiIHRyaWFscz0iMSI+PGFkZFRleHQgY29sb3VyPSIweGU5ZTllOSIgZHJhd0JveD0idHJ1ZSIgYXV0b1NpemU9ImZhbHNlIiBhbGlnbj0ibGVmdCIgd29yZFdyYXA9InRydWUiIHdpZHRoPSI4NSUiIGhlaWdodD0iOTAlIiB4PSI1MCUiIHk9IjQlIiB2ZXJ0aWNhbD0idG9wIiB0ZXh0PSJ7Yn1CZWZvcmUgd2UgYmVnaW4sIHBsZWFzZSByZWFkIHRoZSBiZWxvdy4gIEJ5IGNsaWNraW5nIEkgQ09OU0VOVCB5b3UgaW5kaWNhdGUgeW91IGhhdmUgY29uc2VudGVkIHRvIHRha2UgcGFydC57L2J9e3AgYWxpZ249J2xlZnQnfSYjeEQ7JiN4QTsmI3g5OyYjeDk7WW91IHdpbGwgYmUgYXNrZWQgdG8gaWRlbnRpZnkgZW1vdGlvbiBpbiBmYWNlcy4gSnVzdCBjbGljayBvbiB0aGUgd29yZCB0aGF0IHlvdSBjb25zaWRlciBnb2VzIGRlc2NyaWJlcyB0aGUgZW1vdGlvbiBpbiB0aGUgZmFjZSAtIGRvbid0IHRoaW5rIHRvbyBtdWNoLCBhbmQgZG9uJ3Qgd29ycnkgaWYgeW91IGZlZWwgbGlrZSB5b3UncmUgZ3Vlc3NpbmchIFdlIGFyZSBpbnRlcmVzdGVkIGluIHBlb3BsZSdzIGludHVpdGl2ZSByZXNwb25zZXMuICYjeEQ7JiN4QTsmI3g5OyYjeDk7QXQgdGhlIGVuZCBvZiB0aGUgc3R1ZHkgd2Ugd2lsbCB0ZWxsIHlvdSBtb3JlIGFib3V0IHRoZSBwdXJwb3NlIG9mIHRoZSBzdHVkeS4gWW91IGNhbiBjb250YWN0IGFuZHlAeHBlcmltZW50Lm1vYmkgZm9yIGZ1cnRoZXIgaW5mb3JtYXRpb24gYXQgYSBsYXRlciBkYXRlIGlmIHlvdSB3aXNoLiYjeEQ7JiN4QTsmI3g5OyYjeDk7UGxlYXNlIHJlYWQgdGhlIGJlbG93IGNvbnNlbnQgc3RhdGVtZW50IGFuZCBpbmRpY2F0ZSB3aGV0aGVyIHlvdSBjb25zZW50LiYjeEQ7JiN4QTsmI3g5OyYjeDk7e3V9U3RhdGVtZW50IG9mIEluZm9ybWVkIENvbnNlbnR7L3V9JiN4RDsmI3hBOyYjeDk7JiN4OTsxLiBJIHVuZGVyc3RhbmQgdGhlIGdlbmVyYWwgcHVycG9zZSBvZiB0aGlzIGV4cGVyaW1lbnQuJiN4RDsmI3hBOyYjeDk7JiN4OTsyLiBJIHVuZGVyc3RhbmQgdGhhdCBJIGNhbiB3aXRoZHJhdyBmcm9tIHRoZSBzdHVkeSBhdCBhbnkgdGltZSBhbmQgdGhhdCBkb2luZyBzbyB3ZSB3aWxsIGRlc3Ryb3kgeW91ciBkYXRhLiYjeEQ7JiN4QTsmI3g5OyYjeDk7My4gSSB1bmRlcnN0YW5kIHRoYXQgbXkgcmVzcG9uc2VzIGFyZSBhbm9ueW1vdXMuJiN4RDsmI3hBOyYjeDk7JiN4OTs0LiBJIGFncmVlIHRvIHRha2UgcGFydCBpbiB0aGlzIG9ubGluZSBleHBlcmltZW50LnsvcH0iIHRpbWVTdGFydD0iMCIgdGltZUVuZD0iZm9yZXZlciIgZm9udFNpemU9IjE3Ii8+PEJlaGF2RnV0dXJlIHRpbWVTdGFydD0iMCIvPjxhZGRCdXR0b24gcGVnPSJuZXh0IiB0aW1lU3RhcnQ9IjAiIHdpZHRoPSIzNTAiIGVuYWJsZWQ9InRydWUiIGhlaWdodD0iMjAwIiB0ZXh0PSJJIGNvbnNlbnQiIHJlc3VsdEZpbGVOYW1lPSJjb250aW51ZSIgaG9yaXpvbnRhbD0icmlnaHQiIHg9Ijk5JSIgeT0iOTklIiB2ZXJ0aWNhbD0iYm90dG9tIi8+PC9UUklBTD48VFJJQUwgVFlQRT0iVHJpYWwiIGJsb2NrPSIxIiBvcmRlcj0iZml4ZWQiIHRyaWFscz0iMSI+PGFkZFVybFZhcmlhYmxlLz48YWRkSW5wdXRUZXh0Qm94IHk9IjQ1JSIgaGVpZ2h0PSIzMCUiIHdpZHRoPSI4MCUiIGZvbnRTaXplPSI4MCIgcGVnPSJpZCIgdGltZVN0YXJ0PSIwIiB0ZXh0PSJwYXJ0aWNpcGFudCBpZCIvPjxiZWhhdk5leHRUcmlhbCBwZWc9Im5leHRUcmlhbCIvPjxhZGRCdXR0b24gaG9yaXpvbnRhbD0icmlnaHQiIHg9Ijk5JSIgeT0iOTklIiB2ZXJ0aWNhbD0iYm90dG9tIiB0ZXh0PSJDb250aW51ZSIgaWY9InRoaXMuY2xpY2s/dGhpcy50ZXh0PSdwbGVhc2UgYW5zd2VyIHRoZSBxdWVzdGlvbnMnLHRoaXMuY2xpY2smYW1wOyZhbXA7aWQucmVzdWx0IT0nJyZhbXA7P25leHRUcmlhbC5zdGFydCgpIiBnb3RvPSIiIHRpbWVTdGFydD0iMTAwIiB3aWR0aD0iMzUwIiBoZWlnaHQ9IjIwMCIvPjwvVFJJQUw+PC9Cb3ViYTI+"});
			}
		}
		
		
		private static function notification_started(d:Object):void{
			data = d;
			
			var script:XML = XML(Base64.decode(data.script))
			if(playerStart.expt){
				playerStart.expt.loadDifferentScript(script);
			}
			else{
				playerStart.startExpt(	script, null	);
			}
		}
		
		public static function future(title:String,body:String, when:Array):void
		{
			var data:Object = {};
			data.script = Base64.encode(	playerStart.scriptXML.toString()	);
			
			
			notification.sendNotification(title,body,when,data);	
		}
	}
}