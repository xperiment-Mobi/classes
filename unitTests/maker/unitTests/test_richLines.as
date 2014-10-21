package unitTests.maker.unitTests
{

	
	import org.flexunit.Assert;
	
	import com.xperiment.make.richSync.RichPoorLineLinker;
	import com.xperiment.make.richSync.RichStr;
	import com.xperiment.make.richSync.RichXML;
	import com.xperiment.make.richSync.SimpleAttrib;

	

	public class test_richLines
	{

		[Test]
		public function test_isNode_RegExp():void{	
			
			RichPoorLineLinker._isNode.lastIndex = 0; Assert.assertTrue(RichPoorLineLinker._isNode.test("<t "));
			RichPoorLineLinker._isNode.lastIndex = 0; Assert.assertTrue(RichPoorLineLinker._isNode.test("<tt "));
			RichPoorLineLinker._isNode.lastIndex = 0; Assert.assertTrue(RichPoorLineLinker._isNode.test("<tt_1 "));
			RichPoorLineLinker._isNode.lastIndex = 0; Assert.assertTrue(RichPoorLineLinker._isNode.test("<t t "));
			RichPoorLineLinker._isNode.lastIndex = 0; Assert.assertTrue(RichPoorLineLinker._isNode.test("<t >"));
			RichPoorLineLinker._isNode.lastIndex = 0; Assert.assertTrue(RichPoorLineLinker._isNode.test("< t >")==false);
			RichPoorLineLinker._isNode.lastIndex = 0; Assert.assertTrue(RichPoorLineLinker._isNode.test("<t>")==false);
			RichPoorLineLinker._isNode.lastIndex = 0; Assert.assertTrue(RichPoorLineLinker._isNode.test("t ")==false);
		}
		
		[Test]
		public function test__addLineNumsToNodes():void{			
			
			Assert.assertTrue(RichPoorLineLinker._addLineNumsToNodes(" ",1)==" ");
			Assert.assertTrue(RichPoorLineLinker._addLineNumsToNodes("<n",1)=="<n");
			Assert.assertTrue(RichPoorLineLinker._addLineNumsToNodes("<n ",1)=="<n _L='1' ");
			Assert.assertTrue(RichPoorLineLinker._addLineNumsToNodes(" <n ",1)==" <n _L='1' ");
			Assert.assertTrue(RichPoorLineLinker._addLineNumsToNodes("<n >",1)=="<n _L='1' >");
		}
		
		[Test]
		public function test__isWellformed():void{			
			
			Assert.assertTrue(RichPoorLineLinker._isWellformed("<>"));
			Assert.assertTrue(RichPoorLineLinker._isWellformed("g<g>g"));
			try{
				RichPoorLineLinker._isWellformed("<<"); Assert.assertTrue(false);
			}
			catch(e:Error){
				Assert.assertTrue(true);
			}
			
			try{
				RichPoorLineLinker._isWellformed("<<>"); Assert.assertTrue(false);
			}
			catch(e:Error){
				Assert.assertTrue(true);
			}
			
			try{
				RichPoorLineLinker._isWellformed("<><><><<"); Assert.assertTrue(false);
			}
			catch(e:Error){
				Assert.assertTrue(true);
			}
			
			try{
				RichPoorLineLinker._isWellformed("<><><><><>>"); Assert.assertTrue(false);
			}
			catch(e:Error){
				Assert.assertTrue(true);
			}	
		}
		
		
		[Test]
		public function test__RichLines():void{		
			var r:RichStr = new RichStr;
			r.compute("<n >\n<nn ");
			

			//below just demonstrates that imposing XML works fine with \n
			Assert.assertTrue(XML(r._composeLabelledLines()+"/></n>") is XML);
			
			Assert.assertTrue(r._composeLabelledLines()=="<n _L='0' >\n<nn _L='1' ");
			
			r.wipe();
			
			Assert.assertTrue(r._rich_poor_connects == null);

		}
		
		[Test]
		public function test__findMarks():void{		
			
			Assert.assertTrue(RichStr._findMarks.exec("dfdf_L=\"12\"").toString()=="_L=\"12\"");
			Assert.assertTrue(RichStr._findMarks.exec("dfdf_L=\"1\"").toString()=="_L=\"1\"");
			
			Assert.assertTrue(RichStr._findMarks.exec("dfdfL=\"1\"")==null);
			
			
			
			//Assert.assertTrue(x._composeLabelledLines()=="<n >\n<nn e='33' /> </n>");
		}

	    [Test]
		public function test__removeLineNum():void{		
			Assert.assertTrue(RichStr._removeLineNum("sssssssss_L=\"22\"222",'22')=="sssssssss222");
		}
		
		[Test]
		public function test__SimpleAttrib():void{
			var a:SimpleAttrib = new SimpleAttrib("gffgf = 'ddfdfd'","gffgf = 'ddfdfd'");
			
			Assert.assertTrue(a.name=='gffgf');
			Assert.assertTrue(a.value=='ddfdfd');	//note that the brackets have been removed
			
			Assert.assertTrue(a._removeBlanks("   d"),"d");
			Assert.assertTrue(a._removeBlanks("   dddd "),"dddd ");
			
			Assert.assertTrue(a._clipWings("qwert")=="wer");
			
			Assert.assertTrue(a.updatedAttrib("qwert")=="gffgf = 'qwert'");
		}
		
		[Test]
		public function test__updateXML_SIMPLE():void{		
			var scriptStr:String = "<n >\n<nn e= '22' />\n</n>";
			
			var x:RichXML = new RichXML;
			
			x.compute(scriptStr);
			
			var scriptXML:XML=x.composeXML();
			
			Assert.assertTrue(scriptXML is XML);
			
			scriptXML.nn.@e=33;
			
			x.updateWithXML(scriptXML);
			
			Assert.assertTrue(x.composeUpdatedLines()=="<n >\n<nn e= '33' />\n</n>");
			
			scriptXML.nn.@new1='test';
			delete scriptXML.nn.@e;
			
			x.updateWithXML(scriptXML);
			
			Assert.assertTrue(x.composeUpdatedLines()=="<n >\n<nn new1=\"test\" />\n</n>");	
			
			scriptXML.nn.@eee='222';
			x.updateWithXML(scriptXML);
			
			Assert.assertTrue(x.composeUpdatedLines()=="<n >\n<nn new1=\"test\" eee=\"222\" />\n</n>");	
		}
		
		[Test]
		public function test__updateXML_COMPLEX():void{		
			
			
			var scriptStr:String = "<n >\n<nn e= '22' />\n<nn e= '33' d='44' />\n<nn e= '22'   f='1' />\n</n>";
			
			var x:RichXML = new RichXML;
			
			x.compute(scriptStr);
			
			var scriptXML:XML=x.composeXML();
			
			Assert.assertTrue(scriptXML is XML);
			
			scriptXML.nn[0].@e=33;
			scriptXML.nn[1].@f=33;
			
			x.updateWithXML(scriptXML);
			
			Assert.assertTrue(x.composeUpdatedLines()=="<n >\n<nn e= '33' />\n<nn e= '33' d='44' f=\"33\" />\n<nn e= '22'   f='1' />\n</n>");
			
			scriptXML.nn[2].@f='\n123\n123\n';
			
			x.updateWithXML(scriptXML);
			Assert.assertTrue(x.composeUpdatedLines()=="<n >\n<nn e= '33' />\n<nn e= '33' d='44' f=\"33\" />\n<nn e= '22'   f='\n123\n123\n' />\n</n>");
			
		}
		
		[Test]
		public function test__updateXML_COMPLEX_newlines():void{		
			
			
			var scriptStr:String = "<n >\n<nn e= '22' />\n<nn e= '33' d='44' />\n<nn e= '22'   f='1' />\n</n>";
			
			var x:RichXML = new RichXML;
			
			x.compute(scriptStr);
			
			var scriptXML:XML=x.composeXML();
			
			Assert.assertTrue(scriptXML is XML);
			
			
		}
		
		


	}
}