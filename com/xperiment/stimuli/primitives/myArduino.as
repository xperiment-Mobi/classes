package com.xperiment.stimuli.primitives {
import com.xperiment.stimuli.primitives.ArduinoPrivate;

import flash.events.Event;

import net.eriksjodin.arduino.Arduino;
import net.eriksjodin.arduino.events.ArduinoEvent;
import net.eriksjodin.arduino.events.ArduinoSysExEvent;

	public class myArduino{
		
		private static var _instance:myArduino;
		private var arduino:Arduino;
		private var tempArduinos:Array;
		private var pins:Array;
		private var nam:String;
		
		public function myArduino(pvt:ArduinoPrivate){
			ArduinoPrivate.alert();
		}
		
		//private static var ver:Number;
		
		public function kill():void
		{
			if(myArduino._instance !=null){
				all(Arduino.OFF);
				arduino=null;  
				_instance=null;
			}

		}
		
		public static function getInstance():myArduino
		{
			if(myArduino._instance==null){
				//ver=Math.round(Math.random()*1000);
				//trace("create arduino link",ver);
				myArduino._instance=new myArduino(new ArduinoPrivate());
			}
			else trace("arduino already linked");
				
			return myArduino._instance;
		}
		
		public static function instanceExists():Boolean
		{
			return myArduino._instance!=null
		}
		
		public function commenceArduino(params:Object):void
		{
			pins=[];
			for(var i:uint=1;i<=12;i++){
				pins[i]=false;
			}
			
			var comPort:String="COM9";
			if(params.hasOwnProperty("port"))comPort="COM"+String(params.port);
			
			var listeners:Function = function(a:Arduino):void{
				a.addEventListener(Event.CONNECT,onSocketConnect); 
				a.addEventListener(ArduinoEvent.FIRMWARE_VERSION, onReceiveFirmwareVersion);
				a.addEventListener(ArduinoSysExEvent.SYSEX_MESSAGE, onReceiveSysExMessage); 
			}
			
			//arduino = new Arduino(comPort, 57600);
			arduino = new Arduino("127.0.0.1", 5331);
			listeners(arduino);
			/*if(arduino.portOpen){
				listeners(arduino);
				onSocketConnect(new Event("noEventNeeded")); //this is temporary until ANE provider can fix the eventListener issue (non firing).
			}
			else{

				var tempArduino:Arduino;
				tempArduinos=[];
				trace("!Could not open Arduino at "+comPort+".  Going through all available com ports now...");
				var comPorts:Array=arduino.getComPorts();
				arduino.dispose();
				arduino=null;
				for (i=2;i<comPorts.length;i++){
					tempArduino = new Arduino(comPorts[i], 57600);
					tempArduinos.push(tempArduino);
					if(tempArduino.portOpen){
						arduino=tempArduino;
						listeners(tempArduino);
						onSocketConnect(new Event("noEventNeeded")); //this is temporary until ANE provider can fix the eventListener issue (none firing).
						break;
 					}
				}
			}*/
			
		}
		
		// triggered when a serial socket connection has been established
		private function onSocketConnect(e:Event):void {
/*			if(!arduino){
				arduino=e.target as Arduino;
				for(var i:uint=0;i<tempArduinos.length;i++){
					(tempArduinos[i] as Arduino).removeEventListener(Event.CONNECT,onSocketConnect);
					if(tempArduinos[i]!=arduino){
						(tempArduinos[i] as Arduino).dispose();  
						tempArduinos[i]=null;
					}
					
				}
				tempArduinos=null;
			}*/

			for (var i:uint =2;i<=12;i++){
				arduino.setPinMode(i, Arduino.OUTPUT);
				arduino.writeDigitalPin(i, Arduino.OFF);
			}
			trace("Arduino initialized."); // To reduce the time Xperiment takes to load because of searching com ports, best to specify 

		}
		
		public function action(what:String,params:Array=null):void{
			var which:String="";
			if(params && params[0]) which=params[0];
			//trace(what,which,arduino);
			var pin:uint;
			if(which=="all")pin=1000;
			else pin=uint(which);
			
			if((arduino && pin >= 1 && pin <=12) || pin==1000){
				switch (what.toLowerCase()){
					case "on":
						if(pin==1000)all(Arduino.ON);
						else arduino.writeDigitalPin(pin,Arduino.ON);
						pins[which]=true;
						break;
					case "off":
						if(pin==1000)all(Arduino.OFF);
						else arduino.writeDigitalPin(pin,Arduino.OFF);
						pins[which]=true;
						break;
					case "toggle":
						if(pins[which]){
							//trace("true",pins[which]);
							if(pin==1000)all(Arduino.OFF)
							else {
								arduino.writeDigitalPin(pin,Arduino.OFF);
								pins[which]=false;
							}
						}
						else{
							//trace("false",pins[which]);
							if(pin==1000) all(Arduino.ON)
								
							else {
								arduino.writeDigitalPin(pin,Arduino.ON);
								pins[which]=true;
							}
						}
						break;
				}
			}
			else if (arduino) trace("!Wrongly formatted arduino action (what="+what+", which="+which+").  What should be either ON or OFF whilst which should be from 1 to 12.");
			else trace("no arduino found!!");
		}
		
		private function all(action:int):void{
			
			for (var i:uint=1;i<=12;i++){
				arduino.writeDigitalPin(i,action);
			}
			
		}
		

		
		// triggered when a serial socket connection has been closed
		private function onSocketClose(e:Object):void {
			trace("Socket closed!");
		}
		
		// trace out data when it arrives...    
		private function onReceiveAnalogData(e:ArduinoEvent):void {
			trace(" Analog pin " + e.pin + " on port: " + e.port +" = " + e.value);
		}
		
		// trace out data when it arrives...
		private function onReceiveDigitalData(e:ArduinoEvent):void {
			trace(" Digital pin " + e.pin + " on port: " + e.port +" = " + e.value);
		}
		
		// trace incoming sysex messages
		private function onReceiveSysExMessage(e:ArduinoSysExEvent):void {
			trace("Received SysExMessage. Command:"+e.data[0]);
		}
		
		
		// the firmware version is requested when the Arduino class has made a socket connection.
		// when we receive this event we know that the Arduino has been successfully connected.
		private function onReceiveFirmwareVersion(e:ArduinoEvent):void {
			trace("Firmware version: " + e.value);
			if(int(e.value)!=2) {
				trace("Unexpected Firmware version encountered! This Version of as3glue was written for Firmata2.");
			}
			// the port value of an event can be used to determine which board the event was dispatched from
			// this is one way of dealing with multiple boards, another is to add different listener methods
			trace("Port: " + e.port);
			
			// do some stuff on the Arduino...
			initArduino();
		}
		
		
		private function initArduino():void {
			trace("Initializing Arduino");
			
			// set a pin to output
			arduino.setPinMode(13, Arduino.OUTPUT);
			
			// set a pin to high
			arduino.writeDigitalPin(13, Arduino.HIGH);
			
			// turn on pull up on pin 4
			arduino.writeDigitalPin(4, Arduino.HIGH);
			
			// set digital pin 4 to input
			arduino.setPinMode(4, Arduino.INPUT);
			
			// enable reporting for digital pins
			arduino.enableDigitalPinReporting();
			
			// disable reporting for digital pins
			//a.disableDigitalPinReporting();
			
			// enable reporting for an analog pin
			arduino.setAnalogPinReporting(3, Arduino.ON);
			
			// disable reporting for an analog pin
			//a.setAnalogPinReporting(3, Arduino.OFF);
			
			// set a pin to PWM
			arduino.setPinMode(11, Arduino.PWM);
			
			// write to PWM (0..255)
			arduino.writeAnalogPin(11, 255);
			
			// trace out the most recently received data
			//trace("Analog pin 3 is: " + a.getAnalogData(3));
			//trace("Digital pin 4 is: " + a.getDigitalData(4));    
		}
		
		

		protected function closeApp(event:Event):void
		{
			//arduino.dispose();                              
		}
	}
}
		