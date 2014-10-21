package com.xperiment.Results.services
{
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.getTimer;
	
	import org.bytearray.smtp.crypto.MD5;
	import org.bytearray.smtp.encoding.Base64;
	import org.bytearray.smtp.events.SMTPEvent;
	import org.bytearray.smtp.infos.SMTPInfos;

	
	public class SMTPMailerTextAttach extends Socket
	{
		private var sHost:String;
		private var buffer:Array = new Array();
		
		// regexp pattern
		private var reg:RegExp = /^\d{3}/img;
		
		// PNG, JPEG header values
		private static const PNG:Number = 0x89504E47;
		private static const JPEG:Number = 0xFFD8;
		
		// common SMTP server response codes
		// other codes could be added to add fonctionalities and more events
		private static const ACTION_OK:Number = 0xFA;
		private static const AUTHENTICATED:Number = 0xEB;
		private static const DISCONNECTED:Number = 0xDD;
		private static const READY:Number = 0xDC;
		private static const DATA:Number = 0x162;
		private static const BAD_SEQUENCE:Number = 0x1F7;
		
		
		public function SMTPMailerTextAttach(pHost:String, pPort:int)
		{		
			super ( pHost, pPort );			
			sHost = pHost;
			addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			
		}
		
		/*
		* This method lets you authenticate, just pass a login and password
		*/
		public function authenticate ( pLogin:String, pPass:String ):void
		{
			writeUTFBytes ("EHLO "+sHost+"\r\n");
			writeUTFBytes ("AUTH LOGIN\r\n");
			writeUTFBytes (Base64.encode64String (pLogin)+"\r\n");
			writeUTFBytes (Base64.encode64String (pPass)+"\r\n");
			flush();
		}
		
		public function sendAttachedMail ( pFrom:String, pDest:String, pSubject:String, pMess:String, txtAttach:String, pFileName:String ) :void
		{
			try {
				
				writeUTFBytes ("HELO "+sHost+"\r\n");
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
		
		// check SMTP response and dispatch proper events
		// Keep in mind SMTP servers can have different result messages the detection can be modified to match some specific SMTP servers
		private function socketDataHandler ( pEvt:ProgressEvent ):void
		{
			var response:String = pEvt.target.readUTFBytes ( pEvt.target.bytesAvailable );
			buffer.length = 0;
			var result:Array = reg.exec(response);
			
	
			
			while (result != null)
			{	
				buffer.push (result[0]);
				result = reg.exec(response);
			}
			
			var smtpReturn:Number = buffer[buffer.length-1];
			var smtpInfos:SMTPInfos = new SMTPInfos ( smtpReturn, response );
			
			if ( smtpReturn == SMTPMailerTextAttach.READY ) 
				dispatchEvent ( new SMTPEvent ( SMTPEvent.CONNECTED, smtpInfos ) );
				
			else if ( smtpReturn == SMTPMailerTextAttach.ACTION_OK && (response.toLowerCase().indexOf ("queued") != -1 || response.toLowerCase().indexOf ("accepted") != -1 ||
				response.toLowerCase().indexOf ("qp") != -1) ) dispatchEvent ( new SMTPEvent ( SMTPEvent.MAIL_SENT, smtpInfos ) );
			else if ( smtpReturn == SMTPMailerTextAttach.AUTHENTICATED ) 
				dispatchEvent ( new SMTPEvent ( SMTPEvent.AUTHENTICATED, smtpInfos ) );
			else if ( smtpReturn == SMTPMailerTextAttach.DISCONNECTED ) 
				dispatchEvent ( new SMTPEvent ( SMTPEvent.DISCONNECTED, smtpInfos ) );
			else if ( smtpReturn == SMTPMailerTextAttach.BAD_SEQUENCE ) 
				dispatchEvent ( new SMTPEvent ( SMTPEvent.BAD_SEQUENCE, smtpInfos ) );
			else if ( smtpReturn != SMTPMailerTextAttach.DATA ) 
				dispatchEvent ( new SMTPEvent ( SMTPEvent.MAIL_ERROR, smtpInfos ) );	
		}
	}
}