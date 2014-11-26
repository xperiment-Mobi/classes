package com.xperiment.Results.services
{

	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.SecureSocket;
	import flash.utils.getTimer;
	
	import org.bytearray.smtp.crypto.MD5;
	import org.bytearray.smtp.encoding.Base64;
	import org.bytearray.smtp.events.SMTPEvent;

	
	public class emailResultsSMTP extends SecureSocket
	{
		private var emailSent:Boolean = false;
		
		private var success:Function;

		private var host:String = 'email-smtp.us-east-1.amazonaws.com';
		private var port:int = 465;
		private var results:String;
		
		
		public function emailResultsSMTP(myResults:String, success:Function) {
			
			
			this.success=success;
			this.results = myResults;
			
			listeners(true);
	
			try
			{
				this.connect( host, port );
			}
			catch ( error:Error )
			{
				trace ( error.toString() );
			}
			
			
		}
		
		public function authenticate ( pLogin:String, pPass:String ):void
		{
			writeUTFBytes ("EHLO "+host+"\r\n");
			writeUTFBytes ("AUTH LOGIN\r\n");
			writeUTFBytes (Base64.encode64String (pLogin)+"\r\n");
			writeUTFBytes (Base64.encode64String (pPass)+"\r\n");
			flush();
		}
		
		private function listeners(DO:Boolean):void
		{
			var f:Function;
			if(DO)f=addEventListener;
			else  f=removeEventListener;
			
			f(SMTPEvent.AUTHENTICATED,mySMTPEvent);
			f(SMTPEvent.BAD_SEQUENCE,mySMTPEvent);
			f(SMTPEvent.CONNECTED,mySMTPEvent);
			f(SMTPEvent.DISCONNECTED,mySMTPEvent);
			f(SMTPEvent.MAIL_ERROR,mySMTPEvent);
			f(SMTPEvent.MAIL_SENT,mySMTPEvent);
			
			f(Event.CLOSE, myRegularEvent);
			f(Event.CONNECT, myRegularEvent);
			f(IOErrorEvent.IO_ERROR, myRegularEvent);
			f(SecurityErrorEvent.SECURITY_ERROR, myRegularEvent);
			f(ProgressEvent.SOCKET_DATA, myRegularEvent);
			

		}
		
		public function sendAttachedMail ( pFrom:String, pDest:String, pSubject:String, pMess:String, txtAttach:String, pFileName:String ) :void
		{
			try {
				
				writeUTFBytes ("HELO "+host+"\r\n");
				writeUTFBytes ("MAIL FROM: <"+pFrom+">\r\n");
				writeUTFBytes ("RCPT TO: <"+pDest+">\r\n");
				writeUTFBytes ("DATA\r\n");
				writeUTFBytes ("From: "+pFrom+"\r\n");
				writeUTFBytes ("To: "+pDest+"\r\n");
				writeUTFBytes ("Date : "+new Date().toString()+"\r\n");
				writeUTFBytes ("Subject: "+pSubject+"\r\n");
				writeUTFBytes ("Mime-Version: 1.0\r\n");
				
				var md5Boundary:String = MD5.hash ( String ( getTimer() ) );
				
				writeUTFBytes ("Content-Type: multipart/mixed; boundary=------------"+md5Boundary+"\r\n");
				writeUTFBytes("\r\n");
				writeUTFBytes ("This is a multi-part message in MIME format.\r\n");
				writeUTFBytes ("--------------"+md5Boundary+"\r\n");
				writeUTFBytes ("Content-Type: text/html; charset=UTF-8; format=flowed\r\n");
				writeUTFBytes("\r\n");
				writeUTFBytes (pMess+"\r\n");
				writeUTFBytes ("--------------"+md5Boundary+"\r\n");
				writeUTFBytes ("Content-Type: text/plain; name="+pFileName+"\r\n");
				writeUTFBytes ("Content-Disposition: attachment filename="+pFileName+"\r\n");
				//writeUTFBytes ("Content-Transfer-Encoding: base64\r\n");
				writeUTFBytes ("\r\n");
				writeUTFBytes ( txtAttach+"\r\n");
				writeUTFBytes ("--------------"+md5Boundary+"-\r\n");
				writeUTFBytes (".\r\n");
				flush();
				
			} catch ( pError:Error )
			{
				trace("Error : Socket error, please check the sendAttachedMail() method parameters");
				trace("Arguments : " + arguments );		
			}
			
		}
		
		private function myRegularEvent(e:Event):void{
			
			trace(111,e.type)
			if(e.type=='connect' && emailSent==false){
				emailSent=true;
				sendEmail()
			}
		}
		
		private function sendEmail():void
		{
			authenticate('AKIAJ6THHFIECGZRL5WQ','Ao83wtKR3jxkfYlLltnHEYnEQ0HdxrSF9r6tapbpiv1U');
			sendAttachedMail('andy.woods@xperiment.mobi',ExptWideSpecs.IS("toWhom"),ExptWideSpecs.IS("subject"),'test',results,ExptWideSpecs.IS("filename"));
			
		}		
			
		
		private function mySMTPEvent(e:SMTPEvent):void{
			var info:Object;
			info = e.result;
			trace("---");
			trace(e.type);
			for(var s:String in info){
				trace(s,":",info[s]);			
			}
		}
	}
}