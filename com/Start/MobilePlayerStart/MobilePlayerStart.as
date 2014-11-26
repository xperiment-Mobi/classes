package com.Start.MobilePlayerStart
{
	
	import com.Start.MobilePlayerStart.services.GetStudies;
	import com.Start.MobilePlayerStart.view.PlayerView;
	import com.greensock.events.LoaderEvent;
	
	import flash.display.Stage;
	import flash.events.Event;
	
	
	
	public class MobilePlayerStart extends AbstractMobileStart
	{
		private var playerView:PlayerView;
		private var checkIfExists:CheckIfExists;
		
		override public function kill():void{
			killPlayerView();
			super.kill();
		}
		
		private function killPlayerView():void{
			if(playerView){
				if(playerView.hasEventListener(Event.COMPLETE))playerView.removeEventListener(Event.COMPLETE, arguments.callee);
				playerView.kill();
				playerView=null;
			}
		}
		
		
		override public function MobilePlayerStart(theStage:Stage,scriptName:String='')
		{		

			super(theStage,'');
			//scriptLoad("vibrofone.xml");
			//scriptLoad("assets/network1.xml");
			
			
			
			//url="http://www.opensourcesci.com/experiments/Oxford/vibrofone/vibrofone.xml"
			//scriptLoad(url);
		}
		
		private function playerViewL(e:Event):void{
			playerView.removeEventListener(Event.COMPLETE, arguments.callee);
			url=playerView.exptSelected.url;
			if(url!="")scriptLoad(url);
			else{
				playerView.exptSelected.funct();
			}
			killPlayerView();		
			
		}
		
		override public function __start():void{
	
			playerView = new PlayerView(theStage);
			
			playerView.addEventListener(Event.COMPLETE, playerViewL);
						
			
			var expt:ExptInfo = new ExptInfo(null);
			expt.title="Scan for a local study?"
			expt.special="scan";
			expt.colour='#6f2e0c'
			expt.url="assets/network1.xml"
			expt.button = "scan";
			expt.info ="Use this option when you are in an audience or lecture-hall and the Experimenter has asked you all to take part in a group study."
			playerView.addExpt(expt);
			
			expt = new ExptInfo(null);
			expt.title="Check Xperiment online for studies?"
			expt.special="online";
			expt.colour='#6f2e0c'
			expt.button="check online";
			expt.runnable=false;
			expt.info ="This requires a wifi connection. If any are available right now, a list of experiments will be downloaded. This can sometimes take upwards of 10 seconds."
			expt.funct = function():void{GetStudies.DO(givenStudies);};
			playerView.addExpt(expt);
			
			expt = new ExptInfo(null);
			expt.title="Were you given a url of an experiment?"
			expt.colour='#6f2e0c'
			expt.button="check";
			expt.runnable=false;
			expt.input="url";
			expt.info ="This requires a wifi connection. The experiment will start automatically if it is found."
			expt.funct = checkURL;
			playerView.addExpt(expt);

			
			/*expt = new ExptInfo(null);
			expt.title="Colour-flavour associations experiment from Oxford University, UK."
			expt.url="http://www.opensourcesci.com/experiments/packaging1/packaging.xml";	
			expt.info ="Here at the Crossmodal Research Lab, at the Department of Experimental Psychology, University of Oxford, we are currently conducting a study designed to assess how people associate colours and flavours in potato chips (crisps). If you decide that you would like to take part in this study, we will show you pictures of different potato chips packages and ask you to match them to a colour. The study will take about 20 minutes to complete. If you would like to participate, we would only ask that you complete the study if you are somewhere quiet. If you need glasses, please wear them before starting the experiment."
			playerView.addExpt(expt);*/
			
			//scriptLoad('weightColour.xml');
		}
		
		private function givenStudies(exptsVect:Vector.<ExptInfo>):void{
			if(exptsVect==null){
				exptsVect = new Vector.<ExptInfo>;
				
				
				var noStudiesMessage:ExptInfo = new ExptInfo(null);
				noStudiesMessage.title="NO NEW STUDIES COULD BE RETRIEVED!";
				noStudiesMessage.colour='#ff0000';
				noStudiesMessage.runnable=false;
				noStudiesMessage.info="Either you have no internet connection or there are indeed no studies available online at this time.";
				exptsVect.push(noStudiesMessage);
			}
			
			for each(var expt:ExptInfo in exptsVect){
				if(playerView)playerView.addExpt(expt);	
			}	
		};
					
		override public function startExpt(script:XML):void
		{
			
			killPlayerView();		
			
			if(checkIfExists){
				checkIfExists.kill();
				checkIfExists=null;
			}
				
			super.startExpt(script);
		}
		

		private function checkURL(given_url:String,setTextInBoxF:Function):void{
			
			if(given_url.indexOf("http")==-1){
				given_url="http://"+given_url;
			}
			
			if(given_url.indexOf("xml")==-1)given_url = addScriptText(given_url);
			
			if(!checkIfExists && given_url){

				function superkill():void{checkIfExists=null;}
				
				checkIfExists= new CheckIfExists(given_url,setTextInBoxF,superkill);
				
				url=given_url

				scriptLoad(given_url);
			}
			else checkIfExists.newMessage("be patient!");
			
		}
		
		private function addScriptText(url:String):String
		{
			
			
			var sep:String = "/";
			if(url.split("\\").length>1)sep="\\";
			
			if(url.charAt(url.length-1)!=sep)url+=sep;
			var arr:Array = url.split(sep);
			for(var i:int=arr.length-1;i>=0;i--){
				if(arr[i]!=''){
					url+=arr[i]+".xml";
					return url;
				}
			}
			return null;
		}
		
		override public function dataNotLoaded(e:LoaderEvent):void{

			if(!checkIfExists) super.dataNotLoaded(e);
			else checkIfExists.error();		
		}
	}
}

import flash.events.TimerEvent;
import flash.utils.Timer;

internal class CheckIfExists {
	private var url:String;
	private var f:Function;
	private var t:Timer;
	private var message:String = 'checking';
	private var right:Boolean = true;
	private var superkill:Function;
	
	
	public function CheckIfExists(url:String,f:Function,superkill:Function):void {
		this.url=url;
		this.f=f;
		this.superkill=superkill;
		blink(true);
	}
	
	private function blink(DO:Boolean):void
	{
		if(DO){
			t = new Timer(100);
			t.addEventListener(TimerEvent.TIMER,timerF);
			t.start();
		}
		else{
			t.removeEventListener(TimerEvent.TIMER,timerF);
			t.stop();
		}
		
	}
	
	protected function timerF(e:TimerEvent):void
	{
		if(right){
			message+=".";
		}
		else{
			message=message.substr(0,message.length-1);
		}
		if(message.length>40)right=false;
		if(message.length==1){
			message=".";
			right=true;
		}
		f(message);
	}
	
	public function error():void
	{
		blink(false);
		f("There's a problem. Either the url is wrong, or you have no internet connect.");
		t=new Timer(5000);
		t.addEventListener(TimerEvent.TIMER,function(e:TimerEvent):void{
			t.removeEventListener(TimerEvent.TIMER,arguments.callee);
			f(url);
			superkill();
		});
		t.start();
		
	}
	
	public function kill():void{
		t.stop();
		t.removeEventListener(TimerEvent.TIMER,timerF);
		f=null;
	}
	
	public function newMessage(str:String):void
	{
		message=str;
	}
}


