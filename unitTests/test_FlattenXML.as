package unitTests
{
	import com.xperiment.Results.Results;
	
	import flash.utils.Dictionary;
	
	import org.flexunit.Assert;
	
	public class test_FlattenXML
	{
		
		[Test]
		public function test1():void
		{
			var xml:XML = <dummy><t name="boubaKiki">
						    <order>35</order>
						  </t>
						</dummy>

			
			try{
				Results.__flattenXMLListtoObj(xml.children());
			}
			catch(e:Error){
				
				Assert.assertTrue(e.message=='MUST be labelled trialData')
			}
					
			
			
			xml     = <dummy><trialData name="boubaKiki">
						<order>35</order>
					  </trialData>
					  <trialData name="boubaKiki">
						<order>36</order>
					  </trialData>
					</dummy>


			Assert.assertTrue(compare(Results.__flattenXMLListtoObj(xml.children()),{boubaKiki_order_1:'35', boubaKiki_order_2:'36'}));
			
			xml     = <dummy><trialData name="boubaKiki">
						<order>35</order>
					  </trialData>
					  <trialData name="boubaKiki">
						<order2>36</order2>
					  </trialData>
					</dummy>

Assert.assertTrue(compare(Results.__flattenXMLListtoObj(xml.children()),{boubaKiki_order:'35', boubaKiki_order2:'36'}));
		}
		
		private function compare(obj1:Object, obj2:Object):Boolean
		{

			for(var s:String in obj1){
				if(obj2[s]!=obj1[s])return false	
				delete obj2[s]
			}
			for(s in obj2){
				return false //makes sure obj2 is zero length
			}
			
			return true;
		}
		
		[Test]
		public function test2():void
		{
			
			var _inputArray:Array = new Array();
			
			_inputArray.push({xml: ( <![CDATA[<trialData name="a"></trialData>
											  <trialData name="b"></trialData>
											  <trialData name="a"></trialData>
											  <trialData name="a"></trialData>
											  <trialData name="a"></trialData>
											  <trialData name="a"></trialData>
											  <trialData name="b"></trialData>
											  <trialData name="c"></trialData>
											  <trialData name="a"></trialData>
											  <trialData name="b"></trialData>
											  <trialData name="a"></trialData>
											  <trialData name="d"></trialData>
											  <trialData name="e"></trialData>
											  <trialData name="b"></trialData>
											  <trialData name="a"></trialData>
											  <trialData name="a"></trialData>
											  <trialData name="a"></trialData>
											  <trialData name="a">
													<dummy a='2'>123</dummy>
											  </trialData>
											  ]]> ).toString(), resultxml: ( <![CDATA[
											  <trialData name="a"></trialData>
											  <trialData name="b"></trialData>
											  <trialData name="a_1"></trialData>
											  <trialData name="a_2"></trialData>
											  <trialData name="a_3"></trialData>
											  <trialData name="a_4"></trialData>
											  <trialData name="b_1"></trialData>
											  <trialData name="c"></trialData>
											  <trialData name="a_5"></trialData>
											  <trialData name="b_2"></trialData>
											  <trialData name="a_6"></trialData>
											  <trialData name="d"></trialData>
											  <trialData name="e"></trialData>
											  <trialData name="b_3"></trialData>
											  <trialData name="a_7"></trialData>
											  <trialData name="a_8"></trialData>
											  <trialData name="a_9"></trialData>
											  <trialData name="a_10">
													<dummy a='2'>123</dummy>
											  </trialData>
											  ]]> ).toString()});
		
			
			for(var _testIndex:int=0;_testIndex<_inputArray.length;_testIndex++){
				Assert.assertTrue(comparexml(_inputArray[_testIndex].xml, _inputArray[_testIndex].resultxml));
			}
		}
		

		
		private function comparexml(original:String, resultxml1:String):Boolean {
			
			var _originalxml:XMLList = XMLList(original);
			var _resultxml:XMLList = XMLList(resultxml1);
			
			var s:String =Results.__fixTrialsWithSameNames(XMLList(_originalxml));
			var outputxml:XMLList = XMLList(s);
			
			var resultxml:XMLList = XMLList(_resultxml);
			var check:Boolean = false;
			
			for(var i:int=0;i<outputxml.length();i++){
				if(outputxml[i].toXMLString() !=resultxml[i].toXMLString()) return false; 
			}
			return true;
		}
		
		
	}
}