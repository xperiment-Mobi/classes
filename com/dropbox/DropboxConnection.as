package com.dropbox
{
	//import com.Start.MobileStart.MobileScreen;
	import com.dropbox.SQLliteDB.DropboxCredentialsTable;
	import com.greensock.TweenLite;
	import com.xperiment.RequiredActions.RequiredActions;
	import com.xperiment.stimuli.primitives.BasicButton;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import air.net.URLMonitor;
	
	import avmplus.getQualifiedClassName;
	
	import org.hamster.dropbox.DropboxClient;
	import org.hamster.dropbox.DropboxConfig;
	import org.hamster.dropbox.DropboxEvent;
	import org.hamster.dropbox.models.AccountInfo;

	public class DropboxConnection extends Sprite{

		private var dropAPI:DropboxClient;

		private var reqTokenKeyLabel:String = "";
		private var reqTokenSecretLabel:String = "";
		private var accTokenKeyLabel:String = "";
		private var accTokenSecretLabel:String = "";
		
		private var theStage:Stage;
		private var webView:StageWebView;
		private var bg:Sprite;
		private var autoSync:Boolean;
		
		public var pipeLog:Function;
		public var appKey:String="add you app key";
		public var appSecret:String="add your secrey key"
		public var folderToSync:String = 'syncFolder'
			
		private var _log:String='';
		
		public static var DROPBOX_BOSS_DONT_DELETE:Array = ['sav'];
		public static var LOCAL_BOSS_DONT_DELETE:Array = [];
		
		public static var DROPBOX_BOSS_FILETYPES:Array = ['xml','jpg','png','txt','flv','mp3','ttf'];
		public static var LOCAL_BOSS_FILETYPES:Array = ['sav'];
		public static var PERMITTED_FILETYPES:Array = ['xml','jpg','png','txt','sav','flv','mp3','ttf'];
		public static var LOCAL_DIR:String = 'localExpts';
		public static var dropboxDeterminesDelete:Boolean = true;
		
		//first checks to see if dropbox permissions exist on disk.
		private var requiredActions:RequiredActions;
		private var timeout:int = 20000;
		
		public function kill():void{
			log("dropboxAS3 kill needs specifying");

		}
		
		private function log(myLog:String):void{
			if(pipeLog != null)pipeLog(myLog);
			_log=myLog+'\n'+_log;
		}
		
		public function DropboxConnection(sta:Stage,autoSync:Boolean=false):void
		{
			theStage=sta;
			this.autoSync=autoSync;
			this.pipeLog=pipeLog;
			
			for each(var fileType:String in LOCAL_BOSS_FILETYPES){
				if(DROPBOX_BOSS_FILETYPES.indexOf(fileType)!=-1) throw new Error('you have specified filetype '+fileType+' in both DROPBOX_BOSS_FILETYPES and LOCAL_BOSS_FILETYPES. This is not allowed');
			}
			
			if(PERMITTED_FILETYPES.indexOf('*')==-1){
				for each(    fileType		 in LOCAL_BOSS_FILETYPES){
					if(PERMITTED_FILETYPES.indexOf(fileType)==-1) throw new Error('you have specified filetype '+fileType+' in LOCAL_BOSS_FILETYPES but not in PERMITTED_FILETYPES.  I cannot process this filetype.');
				}
				
				for each(    fileType		 in DROPBOX_BOSS_FILETYPES){
					if(PERMITTED_FILETYPES.indexOf(fileType)==-1) throw new Error('you have specified filetype '+fileType+' in DROPBOX_BOSS_FILETYPES but not in PERMITTED_FILETYPES.  I cannot process this filetype.');
				}
			}
		}
		
		public function link():void{

			
			var monitor:URLMonitor = new URLMonitor(new URLRequest("http://www.google.com"));
			monitor.addEventListener(StatusEvent.STATUS,function(e:StatusEvent):void{
				e.target.removeEventListener(e.type,arguments.callee);
				//anon f
//trace(monitor,222,monitor.available,monitor.lastStatusUpdate);
				if(monitor.available){
				
					
					
					var credentialsTable:DropboxCredentialsTable= new DropboxCredentialsTable(log)
					var credentials:Object = credentialsTable.getCredentials();
					
					if(!credentials){
						log('need to link to dropbox app');
						getRequestToken();
					}
					else{
						log('establishing permission to link with dropbox');
						accTokenKeyLabel=credentials.key;
						accTokenSecretLabel=credentials.secret;
						initiateLinkup();
					}
					
					
					
				}
				
				else{
					
					log('sorry, cannot access the internet');
					dispatchEvent(new Event(Event.COMPLETE));
				}
				
			});
			monitor.start();

		}
	

		
		public function killCredentials():Boolean
		{
			var credentialsTable:DropboxCredentialsTable= new DropboxCredentialsTable(log);
			credentialsTable.deleteCreds();
			return true;
		}

		
		public function initiateLinkup():void{
			var config:DropboxConfig = new DropboxConfig(appKey,appSecret);
			config.setAccessToken(accTokenKeyLabel, accTokenSecretLabel);
			dropAPI = new DropboxClient(config);
			accountInfo();
		}
		
		private function onbackground(on:Boolean):void{
				this.dispatchEvent(new Event("background"+String(on)));
		}

		private function beGrantedAccess():void
		{
			
			if (StageWebView.isSupported == true)
			{
				onbackground(true);	
				
				webView = new StageWebView();
				
				webView.stage = theStage;
				webView.assignFocus();

				webView.viewPort = new Rectangle(theStage.stageWidth*.1,theStage.stageHeight*.1,theStage.stageWidth*.8,theStage.stageHeight*.8);
				
				
				var closeButton:BasicButton = new BasicButton;
				closeButton.label.text='after linking, click me'
				closeButton.label.fontSize=30;
				//closeButton.label.font = '_serif';
				
				closeButton.x=webView.viewPort.x;
				closeButton.y=webView.viewPort.y+webView.viewPort.height+5;
				closeButton.myWidth=webView.viewPort.width;
				closeButton.myHeight=80;
				closeButton.init();	
				closeButton.sortLabelPosition(closeButton.label);
				
				theStage.addChild(closeButton);
				
				var pleaseWait:TextField = new TextField;
				pleaseWait.autoSize = TextFieldAutoSize.CENTER;
				
				pleaseWait.background=true;
				pleaseWait.backgroundColor=0x040404
				pleaseWait.text="can take >20s to contact dropbox for the first time...";
				pleaseWait.wordWrap=true;
				pleaseWait.width=theStage.stageWidth;
				var textFormat:TextFormat= new TextFormat(null,30,0xffffff);
				pleaseWait.setTextFormat(textFormat);
				theStage.addChild(pleaseWait);
				pleaseWait.y=-pleaseWait.height;
				pleaseWait.x=theStage.stageWidth*.5 - pleaseWait.width*.5;
				
				TweenLite.to(pleaseWait,1,{y:0});
				
				closeButton.addEventListener(MouseEvent.CLICK, function(e:Event):void{
					closeButton.removeEventListener(MouseEvent.CLICK, arguments.callee);
					theStage.removeChild(pleaseWait);
					TweenLite.killTweensOf(pleaseWait);
					theStage.removeChild(closeButton);
					pleaseWait=null;
					
					closeButton=null;

					webView.dispose();
					webView=null;
					onbackground(false);
					//attempt to get access token (unclear if the permissions were a success but nothing can really be done about that as webView is v limited)
					getAccessToken();
				});
				
				webView.loadURL(dropAPI.authorizationUrl);
			}
			else
			{
				log("stageWebView not supported");
			}
		}

		public function getRequestToken():void
		{	
			var config:DropboxConfig = new DropboxConfig(appKey,appSecret);
			dropAPI = new DropboxClient(config);
			dropAPI.requestToken();

			dropAPI.addEventListener(DropboxEvent.REQUEST_TOKEN_RESULT, function (evt:DropboxEvent):void
			{
				dropAPI.removeEventListener(DropboxEvent.REQUEST_TOKEN_RESULT, arguments.callee);
				var obj:Object = evt.resultObject;
				reqTokenKeyLabel = obj.key;
				reqTokenSecretLabel = obj.secret;
								
				// goto authorization web page to authorize, after that, call get access token 
				beGrantedAccess();
			});
			
			if (! dropAPI.hasEventListener(DropboxEvent.REQUEST_TOKEN_FAULT))dropAPI.addEventListener(DropboxEvent.REQUEST_TOKEN_FAULT, faultHandler);
			
		}

		private function canSync():void{
	
			this.dispatchEvent(new Event("canSync"));
			if(autoSync)syncFolder(folderToSync);
			
		}
		
		public function syncFolder(folder:String):void
		{
			var s:SyncFolder = new SyncFolder(folder, dropAPI,log);
			s.addEventListener(Event.COMPLETE,complete)
			s.start();
			
		}
		
		//cannot combine into above as loose this scope and thus cannot dispatch event in nested F
		private function complete(e:Event):void{
			this.dispatchEvent(new Event(Event.COMPLETE));
			log("---------------------fin-------------------");
			
		}
		
		private function linkedUp():void{
			this.dispatchEvent(new Event("linkedUp"));
			canSync();
		}

		private function getAccessToken():void
		{
			dropAPI.accessToken();

			var handler:Function = function (evt:DropboxEvent):void
			        {
			                dropAPI.removeEventListener(DropboxEvent.ACCESS_TOKEN_RESULT, handler);
			                var obj:Object = evt.resultObject;

							if(obj.hasOwnProperty('key')){
								accTokenKeyLabel = obj.key
				                accTokenSecretLabel = obj.secret;
								//var saveAccessToken:saveFilesInternally= new saveFilesInternally("");
								//saveAccessToken.saveFile("dropBoxAccessDetails", accTokenKeyLabel+","+accTokenSecretLabel);
								addCredentials(accTokenKeyLabel,accTokenSecretLabel);
								log("successfully have been granted permissions by DropBox");//(key-"+accTokenKeyLabel+",secret:+"+accTokenSecretLabel+")");
								linkedUp();
							}
							else log("you decided to not link Xperiment up with Dropbox");
			        };
			dropAPI.addEventListener(DropboxEvent.ACCESS_TOKEN_RESULT, handler);
			if (! dropAPI.hasEventListener(DropboxEvent.ACCESS_TOKEN_FAULT))
			{
				dropAPI.addEventListener(DropboxEvent.ACCESS_TOKEN_FAULT, faultHandler);
			}
		}
		
		private function addCredentials(key:String, secret:String):void
		{
			var credentials:DropboxCredentialsTable = new DropboxCredentialsTable(log);
			var success:Boolean = credentials.setCredentials(key, secret);
		}
		
		private function accountInfo():void
		{
			
			dropAPI.addEventListener(DropboxEvent.ACCOUNT_INFO_RESULT, function(evt:DropboxEvent):void
			{
				dropAPI.removeEventListener(DropboxEvent.ACCESS_TOKEN_RESULT, arguments.callee);
				var accountInfo:AccountInfo = AccountInfo(evt.resultObject);
				canSync();
			});
			
			dropAPI.addEventListener(DropboxEvent.ACCOUNT_INFO_FAULT, faultHandler);
			
			dropAPI.accountInfo();
		}


		private function faultHandler(evt:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE)); //things have completed, in a way!
			if(webView)webView.dispose();
			log("There is an unknown issue with logging into your dropbox account. Reissuing permission for Xperiment to use Dropbox may fix this.");//+(evt as Object).resultObject);
			reqTokenKeyLabel = "";
			reqTokenSecretLabel = "";
			//getRequestToken();
		}
		
		///////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////
		//static functions		

		
		static public function dropBoxOverrides(filename:String):Boolean{	
			if(DROPBOX_BOSS_FILETYPES.indexOf('*')!=-1) return true;
			if(DROPBOX_BOSS_FILETYPES.indexOf(fileType(filename))!=-1) return true;
			return false;
		}
		
		static public function localOverrides(filename:String):Boolean{
			if(LOCAL_BOSS_FILETYPES.indexOf('*')!=-1) return true;
			if(LOCAL_BOSS_FILETYPES.indexOf(fileType(filename))!=-1) return true;
			return false;
		}
		
		static public function localDontDelete(filename:String):Boolean{
			if(LOCAL_BOSS_DONT_DELETE.indexOf('*')!=-1) return true;
			if(LOCAL_BOSS_DONT_DELETE.indexOf(fileType(filename))!=-1) return true;
			return false;
		}
		
		static public function dropBoxDontDelete(filename:String):Boolean{
			if(DROPBOX_BOSS_DONT_DELETE.indexOf('*')!=-1) return true;
			if(DROPBOX_BOSS_DONT_DELETE.indexOf(fileType(filename))!=-1) return true;
			return false;
		}
		
		static public function fileType(filename:String):String{
			var pos:int = filename.split("").reverse().indexOf(".");
			if(pos!=-1) return filename.substr(filename.length-pos);
			return ''
		}
	
	
	}

}