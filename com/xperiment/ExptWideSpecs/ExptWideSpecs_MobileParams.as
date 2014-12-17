package com.xperiment.ExptWideSpecs
{	
	import com.distriqt.extension.application.Application;
	
	import flash.desktop.NativeApplication;
	import flash.events.GeolocationEvent;
	import flash.sensors.Geolocation;
	
	public class ExptWideSpecs_MobileParams
	{
		
		
		public static function SET():void{
			
			var params:Object = ExptWideSpecs._ExptWideSpecs;
			
			params.computer.app = NativeApplication.nativeApplication.applicationID;
			params.computer.dataFolderLocation = '';
			
			try{
				//switch back on
				//Application.init("75d795f721aef531b70e41c6f438a41730036748SoXvDJNmgUYIuW7uC3UHvYSPm4cPNYZms0/7OF+VWUTYS5PHf7dSAOM33HZvnSO04x7P+EtF6H38JKojMqFSFA==");
				//params.computer.deviceUUID = Application.service.device.uniqueId();
			}
			catch(e:Error){
				
			}
			
			
			if (Geolocation.isSupported){
				//Initialize the location sensor.
				var geo:Geolocation = new Geolocation();

				if(! geo.muted){
					
					geo.setRequestedUpdateInterval(1000);
					geo.addEventListener(GeolocationEvent.UPDATE, function(e:GeolocationEvent):void{
					
						geo.removeEventListener(GeolocationEvent.UPDATE,arguments.callee);
						params.computer.latitude = e.latitude;
						params.computer.longitute= e.longitude;

						geo = null;
					
					});
				}
				else geo=null;		
			}	
		}
	}
}