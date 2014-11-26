package com.xperiment.Results.services
{
	import com.xperiment.ExptWideSpecs.ExptWideSpecs;
	
	import jp.classmethod.aws.SES;
	import jp.classmethod.aws.core.AWSEvent;
	import jp.classmethod.aws.core.Parameter;


	public class emailResultsAmazon
	{
		private var successF:Function;
		
		private static var AWSKey:String = 'AKIAJ6THHFIECGZRL5WQ'
		private static var AWSSecret:String = 'Ao83wtKR3jxkfYlLltnHEYnEQ0HdxrSF9r6tapbpiv1U'
		
		public function emailResultsAmazon(results:String,success:Function)
		{
			
			this.successF=success;
			
			var ses:SES = new SES(SES.US_EAST_1);
			
			ses.setAWSCredentials(AWSKey,AWSSecret);

			ses.addEventListener(AWSEvent.RESULT,awsHandler);
			var vals:Array = new Array();
			vals.push(new Parameter("Destination.ToAddresses.member.1",ExptWideSpecs.IS("toWhom")));
			vals.push(new Parameter("Message.Subject.Data",ExptWideSpecs.IS("subject")));
			vals.push(new Parameter("Message.Subject.CharSet","Shift_JIS"));
			vals.push(new Parameter("Message.Body.Text.Data",ExptWideSpecs.IS("message")));                
			vals.push(new Parameter("Message.Body.Text.CharSet","Shift_JIS"));                
			vals.push(new Parameter("Source","result@xperiment.mobi"));
			ses.executeRequest(SES.SEND_EMAIL,vals);
			
		}
		//mailer.sendAttachedMail(ExptWideSpecs.IS("myAddress"),ExptWideSpecs.IS("toWhom"),ExptWideSpecs.IS("subject"),ExptWideSpecs.IS("message"),myResults,ExptWideSpecs.IS("filename"));
		
		protected function awsHandler(e:AWSEvent):void
		{
			trace(e.type);
	
			
		}
	}
}