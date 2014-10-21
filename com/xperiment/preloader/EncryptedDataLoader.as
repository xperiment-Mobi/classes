package com.xperiment.preloader
{
	import com.greensock.loading.DataLoader;
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.util.Base64;
	import com.xperiment.events.GlobalFunctionsEvent;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.ByteArray;

	
	public class EncryptedDataLoader extends DataLoader
	{
		private static var backlog:Vector.<EncryptedDataLoader>;
		private static var cipher:ICipher;
		private var decrypted:Boolean = true;
		public static var stage:Stage;
		
		public function EncryptedDataLoader(urlOrRequest:*, vars:Object=null)
		{
			this.addEventListener(Event.COMPLETE,decryptL);
			super(urlOrRequest, vars);
		}
		
		public function decryptL(e:Event):void {
			e.stopImmediatePropagation();
			this.removeEventListener(Event.COMPLETE,decryptL);
			
			backlog ||= new Vector.<EncryptedDataLoader>;
			backlog.push(this);
			if(cipher)	pingBacklog();
		}
		
		public function decipher():void
		{
			
			try{
				_content = Base64.decodeToByteArray( _content );
				cipher.decrypt( _content );
			}
			catch (e:Error){
				stage.dispatchEvent(new GlobalFunctionsEvent(GlobalFunctionsEvent.COMMAND,GlobalFunctionsEvent.PROBLEM,"Problem decrypting stimuli (make sure you are logged out of xpt.mobi before running an experiment)."));
			}
					
			
			decrypted=true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public static function setCipher(_key:String):void{
			var keyBA:ByteArray = new ByteArray;
			keyBA.writeMultiByte(_key, "iso-8859-1"); 
			
			cipher = Crypto.getCipher("simple-aes", keyBA);
			pingBacklog();
		}
		
		public static function kill():void{
			cipher.dispose();
			cipher = null;	
		}
		
		public static function pingBacklog():void{
			if(backlog){
				var encrypted:EncryptedDataLoader;
				while(backlog.length>0){
					encrypted=backlog.shift();
					encrypted.decipher();
				}
				backlog=null;
			}
		}
	}
}