package unitTests
{

	
	import org.flexunit.Assert;
	import com.xperiment.StimEvents
	
	
	
	public class test_StimEvents
	{
	
		
		[Test( description="tests ActionDict" )]
		public function test3() : void
		{	
			var test1:Function = function():Boolean{
				var stimEvents:StimEvents = new StimEvents("peg","global",true);
				try{
					stimEvents.listenFor("started",function():void{})
					return false;
				}
				catch(e:Error){				
					if(e.toString()!="Error: Error with peg peg (type global): Problem: you asked to listen for an event to occur (started) that never occurs for this object!") return false;
				}
				
				try{
					stimEvents.occured("started")
					return false
				}
				catch(e:Error){
					if(e.toString()!="Error: Error with peg peg (type global): Problem: an event occured (started) that was not preregisted (thus so probably a bug!)") return false;
				}
				
				stimEvents.registerEvents(["started","banana1","banana2"]);
				
				
				if(stimEvents.occured("started")==true) return false; //returns false if there are no listenFors
				
				stimEvents.listenFor("started",function():void{})
				if(stimEvents.occured("started")==false) return false; //returns false if there are no listenFors
				
				stimEvents.listenFor("started",function():void{})
				if(stimEvents.occured("started")==false) return false; //returns false if there are no listenFors
				if(stimEvents.countListenersFor("started")!=2) return false; 
				if(stimEvents.giveListenersFor("started").length!=2) return false; 
				
				stimEvents.listenFor("banana1",function():void{})
				stimEvents.listenFor("banana2",function():void{})
				if(stimEvents.countListeners()!=3)return false;
				
				stimEvents.listenKill("started");
				if(stimEvents.countListenersFor("started")!=0) return false; 
				
				if(stimEvents.countListeners()!=2)return false;
				
				stimEvents.killListeners();
				if(stimEvents.countListeners()!=0) return false;
				
				stimEvents.kill();
			
				return true;	
			}
			
			Assert.assertTrue(test1());//testing that variable replacement works for LHS	

		}
		
	
	

	}
}