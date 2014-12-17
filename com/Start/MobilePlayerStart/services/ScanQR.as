package com.Start.MobilePlayerStart.services
{
	import com.distriqt.extension.scanner.Scanner;
	
	import flash.display.Stage;
	import flash.events.Event;

	public class ScanQR
	{

		public static function DO(parent:Stage, callBackF:Function):void
		{
			trace("hrerere");
			var scanner:TestScanner = new TestScanner;
			scanner.addEventListener(Event.COMPLETE,function(e:Event):void{
				e.currentTarget.removeEventListener(Event.COMPLETE, arguments.callee);
				parent.removeChild(scanner);
				callBackF(scanner.url);

			});
				
			parent.addChild(scanner);
			scanner.init();
		}
		
	}
}

	import com.distriqt.extension.scanner.Scanner;
	import com.distriqt.extension.scanner.ScannerOptions;
	import com.distriqt.extension.scanner.events.ScannerEvent;
	import flash.display.Sprite;
	import flash.events.Event;


	class TestScanner extends Sprite
	{
		private var _devKey		: String ="75d795f721aef531b70e41c6f438a41730036748fU+9BAj39Yb+gWBFNMNqHFB5nWsIjGajJC7Vb/hV80UZHFf+WGYipIeBSlAEXC2QoRC5XVU/4qWfCQ0XnZMy0A0YmF7Sxnt94lJgJyxrePlBdjApGnq47XBkg0p9KccH0Z8wH/TUKMFIWOQh3EubaWtW+SazPQ//jpVSpoT4EdM5qXcNYRowTWgIvenTX/cjrLfNcakiNDUmolp4wlbef3JP60O0q+fmV1QVx6C0IZ0tWSz6RMOoOhLdL5OrUpIWw0ll/AgQx/5lkecBRpMCYPVOVo6G/Hfr3kSoYhIqTmnCe1tF66frFDSFUDDrXUU9rg29SaoR5pubd6ytQHz4nw==";
		private var killed:Boolean = false;
		public var url:String='';

		public function init( ):void
		{
			try
			{
		
				Scanner.init( _devKey );
				Scanner.service.addEventListener( ScannerEvent.CODE_FOUND, scannerL );
				Scanner.service.addEventListener( ScannerEvent.SCAN_STOPPED, scannerL );
				Scanner.service.addEventListener( ScannerEvent.CANCELLED, scannerL );
				
			}
			catch (e:Error)
			{

				kill();
				return;
			}
			
			//
			//	Do something when user clicks screen?
			//
			
			var options:ScannerOptions = new ScannerOptions();
			options.heading = "Scan a study barcode";
			options.cancelLabel = "quit";
			options.x_density = 1;
			options.y_density = 1;
			options.refocusInterval = 0;
			options.camera    = ScannerOptions.CAMERA_REAR;
			options.torchMode = ScannerOptions.TORCH_AUTO;
			
			var success:Boolean = Scanner.service.startScan( options );
			if(success == false)	kill();
		}
		
		private function kill():void{

			if(killed == false && Scanner.service){
				killed = true;
				Scanner.service.removeEventListener( ScannerEvent.CODE_FOUND, scannerL );
				Scanner.service.removeEventListener( ScannerEvent.SCAN_STOPPED, scannerL );
				Scanner.service.removeEventListener( ScannerEvent.CANCELLED, scannerL );
		
				
				//Scanner.service.dispose();
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			
		}
		

		
		private function stopScan():void
		{
			Scanner.service.stopScan();
		}
		

		
		
		private function scannerL( event:ScannerEvent ):void
		{
			Scanner.service.stopScan();
			if(event.hasOwnProperty('data'))	url = event.data;
			kill();
		}
		
	}


