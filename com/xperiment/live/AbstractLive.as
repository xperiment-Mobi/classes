package com.xperiment.live
{
	import com.reyco1.multiuser.MultiUserSession;
	import com.reyco1.multiuser.data.UserObject;
	import com.reyco1.multiuser.debug.Logger;
	import com.reyco1.multiuser.filesharing.P2PSharedObject;
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	import flash.display.Stage;
	import flash.net.FileReference;

	public class AbstractLive
	{

		protected var theStage:Stage;
		protected var connection:MultiUserSession;
		private var SERVER_KEY:String = "rtmfp://stratus.adobe.com/8eb8deed424176bf57f3645e-1823ee5b6114";
		private const GROUP:String	  = "xperiment.mobi";
		static private const FOYER:String = "< - the foyer - >";
		static public const EXPT:String = "Expt";
		static protected const BOSS_DEVICE:String = "I am boss device";
		static protected const TRIAL_RESULTS:String = "trial results";
		static protected const DOWNLOADED_STIMULI:String = "downloaded stimuli";
		static protected const UNIQUE:String = "UNIQUE";
		private var foyer:Boolean;
		public var toUI:Function;
		protected var expt:String;
		
		public static var START_STUDY:String="start study";
		public static var NEXT_TRIAL:String="next trial";
		public static var FINISH_STUDY:String="finish study";
		protected const SPLIT:String = "<--split-->";
		
		public function AbstractLive(theStage:Stage,foyer:Boolean=false):void{

			this.theStage 	= theStage;
			this.foyer 		= foyer;

			beginSetup();
		}
		
		public function kill():void{
			connection.close();
			connection=null;
		}
		
		public function fromUI(obj:Object):void{
			throw new Error();	
		}
		
		public function commsUI(obj:Object):void{
			if(toUI) toUI(obj);
		}
		
		protected function beginSetup():void
		{
			setupLive();
			connect();
		}
		
		protected function connect():void{
			connection.connect( "User" + ExptWideSpecs.getSJuuid() );
		}
		
		protected function setupLive():void
		{
			
			Logger.LEVEL = Logger.ALL_BUT_NET_STATUS;
			
			// connect normally
			var group:String;
			
			if(expt)		group = expt;
			else			group = FOYER;

			connection = new MultiUserSession(SERVER_KEY, group);

			// listen for when we connect
			connection.onConnect = handleConnect;
			
			// listen for when the file we want to send is ready to be shared
			connection.onFileReady = handleFileReadyToBeSent;
			
			// listen for when a file that is being shared with us has completed being transfered
			connection.onFileReceived = handleFileReceived;
		}		
		
		
		
		
		protected function handleConnect( user:UserObject ):void
		{
			Logger.log("I'm connected: " + user.name + ", total: " + connection.userCount);
	
			// add a button to allow us to browse for a file to share.
			//browseButton  = new PushButton(this, 10, 10, "Browse for file", handleBrowseRequest);
			
			// add a button to allow us to receive a file being shared.
			//receiveButton = new PushButton(this, 10, 40, "Receive File", handleReceiveRequest);
		}
		
		
			// here we start browsing our local system for a file to share. The first parameter tells the FileSharer if it should
			// automatically share the file as soon as it is loaded. If set to false, you can then share it by calling
			// connection.session.fileSharer.startSharing();
			//connection.browseForFileToShare( true );
				
		
		// this method receives an instance of the FileReference class whose 'data' property we can access to have direct access to
		// the file we want to share with the group. In this case we are simply just adding the image to the stage
		private function handleFileReadyToBeSent( file:FileReference ):void
		{
			
			//loader = new Loader();
			//loader.loadBytes( file.data );
			
		}
		
		
			// here we tell our connection that we want to start receving the file. This can be automated if the sender sends us a 
			// message telling us that a file is ready as soon as it is ready for him to send.
			//connection.session.fileSharer.startReceiving();
		
		
		// here we handle when we have received a shared file. The method accepts an instance of the P2PSharedObject which in turn
		// has a 'data' property of type ByteArray which holds the data for the file shared.
		protected function handleFileReceived( fileObject:P2PSharedObject ):void
		{
			throw new Error();
			//loader = new Loader();
			//loader.loadBytes( fileObject.data );
			
		}
		
		
		
		protected function studyDetails(n:String,p:String=null):Object{
			var split:String = SPLIT;
			
			if(p==null){
				var arr:Array = n.split(split);
				return {studyName:arr[0],password:arr[1],exptID:arr[2]};
			}

			return {combined:n+split+p+split+EXPT+ExptWideSpecs.getSJuuid()};
		}
		
		public function composeTrialResults(trialResults:String,trialNum:int=-1000):Object{

			if(trialNum==-1000){
				var arr:Array = trialResults.split(SPLIT);
				return {trialResults:arr[1],trialResults:arr[2]};
			}
			
			return {combined:TRIAL_RESULTS+SPLIT+trialResults+SPLIT+trialNum.toString()};
		}
		
		
		
		
		
		
		
		
		
		public function buttonPressed(data:Object):void
		{
			throw new Error("override svp");
			
		}

	}
}