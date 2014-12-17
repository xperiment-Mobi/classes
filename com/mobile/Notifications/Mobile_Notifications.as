package com.mobile.Notifications{	
	import com.distriqt.extension.notifications.Notification;
	import com.distriqt.extension.notifications.Notifications;
	import com.distriqt.extension.notifications.events.NotificationEvent;

	
	public class Mobile_Notifications{
		
		
		private var _devKey		: String;
		private var _count		: int = 0;
		private var _notificationId	: int;
		private var started_via_Notification:Boolean = false;
		private var callBack:Function;
		private var initiated:Boolean = false;
		private var receivedCalls:Array;

		
		public function Mobile_Notifications(callBack:Function)
		{
			this.callBack=callBack;
		
			if	(	initiated==false && init()==true	){
				initiated = true;
				listeners(true);
				message( "Registering for notifications" );
				Notifications.service.register();
			}
		}
		
		
		private function listeners(ON:Boolean):void{
			if(initiated == false)	return;
			var f:Function;
			if(ON)	f=Notifications.service.addEventListener;
			else	f=Notifications.service.removeEventListener;
			//trace("listeners:",ON);
			//f( NotificationEvent.NOTIFICATION_DISPLAYED, notifications_notificationDisplayedHandler );
	
			f( NotificationEvent.NOTIFICATION_SELECTED,  notifications_notificationSelectedHandler );
			//f( NotificationEvent.NOTIFICATION, notifications_notificationHandler );
		}
		
		public function init():Boolean{
			initiated = true;
			_devKey = "75d795f721aef531b70e41c6f438a41730036748fU+9BAj39Yb+gWBFNMNqHFB5nWsIjGajJC7Vb/hV80UZHFf+WGYipIeBSlAEXC2QoRC5XVU/4qWfCQ0XnZMy0A0YmF7Sxnt94lJgJyxrePlBdjApGnq47XBkg0p9KccH0Z8wH/TUKMFIWOQh3EubaWtW+SazPQ//jpVSpoT4EdM5qXcNYRowTWgIvenTX/cjrLfNcakiNDUmolp4wlbef3JP60O0q+fmV1QVx6C0IZ0tWSz6RMOoOhLdL5OrUpIWw0ll/AgQx/5lkecBRpMCYPVOVo6G/Hfr3kSoYhIqTmnCe1tF66frFDSFUDDrXUU9rg29SaoR5pubd6ytQHz4nw==";
			try
			{
				Notifications.init( _devKey );
				message( String(Notifications.isSupported) );
				message( Notifications.service.version );
			}
			catch(e:Error){
				return false;
			}
			return true;
		}
		
	
		
		public function sendNotification(title:String,body:String, when:Array, data:Object):void
		{
			
			if(started_via_Notification==false){
				
				cancelAllNotifications();
				
				var notification:Notification;
				
				for(var i:int=0;i<when.length;i++){
					var time:int = when[i];
					notification= new Notification
					
					notification.id 		= int(Math.random()*int.MAX_VALUE);
					notification.tickerText = "Can you do an experiment now? ("+i+"/"+when.length+")";
					notification.title 		= title;
					notification.body		= body;
					//notification.iconType	= NotificationIconType.DOCUMENT;
					notification.count		= 0;
					notification.vibrate	= true;
					notification.playSound  = true;
					notification.soundName  = "fx05.caf";
					notification.delay		= time;
			
					
					// use Notifications.service.cancelAll() to cancel repeat notifications like the following:
					//			notification.repeatInterval = NotificationRepeatInterval.REPEAT_MINUTE;
					
					//			var fireDate:Date = new Date(2012,05,13, 1,1,1);
					//			var current:Date = new Date();
					//			var seconds:int = int((fireDate.time - current.time)/ 1000);
					//			
					//			notification.delay = seconds;
					data.notificationCount =	i;
					data.time =	time;
					notification.data		= createDataStr( data );
					
					try
					{
						Notifications.service.notify( notification.id, notification );
						
						//				_count ++;
						//				Notifications.service.setBadgeNumber( _count );
						message( "sendNotification(): sent:"+notification.id );
					}
					catch (e:Error)
					{
						message( "ERROR:"+e.message );
					}
					
					
					/*var t:Timer = new Timer(1000,0);
					t.start();
					t.addEventListener(TimerEvent.TIMER,function(e:Event):void{
					NativeApplication.nativeApplication.exit();
					});*/
				}
			}
			
		}
		
		private function createDataStr(obj:Object):String{
			return JSON.stringify(obj);
		}
		
		private function createData(str:String):Object{
			return JSON.parse(str);
		}
		
		
		public function cancelLastNotification():void
		{
			message( "cancelNotification(): cancel:"+_notificationId );
			Notifications.service.cancel( _notificationId );
			
			
		}
		
		
		public function cancelAllNotifications():void
		{
			message( "cancelNotification(): cancelAll()" );
			Notifications.service.cancelAll();
		}
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		
		
		private function message( m:String ):void
		{
			trace( m );
			
		}
		
		
	


		private function notifications_notificationDisplayedHandler( event:NotificationEvent ):void
		{
			message( event.type + "::["+event.id+"]::"+event.data );
		}
		
		
		private function notifications_notificationSelectedHandler( event:NotificationEvent ):void
		{
			message( event.type + "::["+event.id+"]::"+event.data );
			try
			{
				_count --;
				Notifications.service.cancel( event.id );
				Notifications.service.setBadgeNumber( _count );
				//				Notifications.service.cancelAll();
			}
			catch (e:Error)
			{
			}
			
			
			receivedCalls||=[];
			if(receivedCalls.indexOf(event.id)==-1){
				receivedCalls.push(event.id);
				callBack(  createData(event.data)  );
			}
		}
		private var n:Number = Math.random();
		
		
		private function notifications_notificationHandler( event:NotificationEvent ):void
		{
			started_via_Notification = true;
			
			message( event.type + "::["+event.id+"]::"+event.data );
		}
		

		

	}
	
	
}


