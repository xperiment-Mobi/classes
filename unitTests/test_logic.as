package unitTests
{

	import com.xperiment.BehavLogicAction.PropValDict;
	import com.xperiment.BehavLogicAction.Logic.LogicEquation.TopLevelLogic;
	import com.xperiment.BehavLogicAction.Logic.LogicEquation.Equation.Equation;
	import com.xperiment.BehavLogicAction.Logic.LogicEquation.Equation.EquationsLevel;
	import com.xperiment.BehavLogicAction.Logic.LogicEquation.Equation.ManyVarSide;
	import com.xperiment.parsers.CompiledObject;
	import com.xperiment.parsers.MathParser;
	
	import org.flexunit.Assert;

	
	
	
	public class test_logic
	{
		[Test( description="tests LogicExpression function in Logic" )]
		public function test1() : void
		{
			
			var testLogicExp:Function = function(lhs:* = null, rhs:* = null,lhsStr:String="123",rhsStr:String="123",comp:String="=="):Boolean{
		
				if(arguments.length<=2){
		
					lhsStr=String(lhs);
					rhsStr=String(rhs);
				}
				
				
				var logicExp:Equation = new Equation(function():void{},null);
				logicExp.setupSides();
				logicExp.left.equation=lhs;
				logicExp.left.equationOrigStr=lhsStr
				logicExp.comparison=comp;
				logicExp.right.equation=rhs;
				logicExp.right.equationOrigStr=rhsStr;

				
				return logicExp.eval();
			}
	
			//Note that this function should does not deal with variable names.  Only passed true values.  If a var name is passed and there is NO value, defualts to false

			Assert.assertTrue(testLogicExp(123,123));
			Assert.assertTrue(testLogicExp(123,124)==false);
			Assert.assertTrue(testLogicExp(123,123,"123","123","!=")==false);
			Assert.assertTrue(testLogicExp(123,123,"123","123",">")==false);
			Assert.assertTrue(testLogicExp(123,123,"123","123",">="));
			Assert.assertTrue(testLogicExp(123,123,"123","124","<="));
			Assert.assertTrue(testLogicExp(true,true));
			Assert.assertTrue(testLogicExp(true,false)==false);
			Assert.assertTrue(testLogicExp(true,!true)==false);
			Assert.assertTrue(testLogicExp(!false,!false));
			Assert.assertTrue(testLogicExp("!hello")); //assess if variable exists 			(!banana == true)
			Assert.assertTrue(testLogicExp("hello") == false); //assess if variable exists 			
			//trace("logictest:",testLogicExp("hello",null,"hello",null,"==")); //NEVER HAPPENS AS lfs String always exists
			Assert.assertTrue(testLogicExp(null,null,"!hello","!banana")); //check if two variables exists and contrasts results
			Assert.assertTrue(testLogicExp(null,null,"hello","!banana")==false); //check if two variables exists and contrasts results
			Assert.assertTrue(testLogicExp(null,null,"aaa","aaa")==false); //these variables dont exist and so ARE NOT COMPARED, defaulting to FALSE
			Assert.assertTrue(testLogicExp("'aba'","'aaa'")==false);	
			Assert.assertTrue(testLogicExp("'aaa'","!'aaa'")==false); 
			Assert.assertTrue(testLogicExp("'aaa'","'aaa'")); 
			//Assert.assertTrue(testLogicExp("!'aba'","!'aaa'","!'aba'","!'aaa'","!=")==false);
		}
		
		[Test( description="tests computeEvals function in LogicDictionaries" )]
		public function test2() : void
		{
			
			var l:EquationsLevel = new EquationsLevel("dummy",new PropValDict(),null);
			Assert.assertTrue(l.computeEvals([true,"&&",true]));
			Assert.assertTrue(l.computeEvals([false,"&&",true])==false);
			Assert.assertTrue(l.computeEvals([true,"&&",false])==false);
			Assert.assertTrue(l.computeEvals([true,"||",true]));
			Assert.assertTrue(l.computeEvals([true,"||",false]));
			Assert.assertTrue(l.computeEvals([false,"||",true]));
			Assert.assertTrue(l.computeEvals([true,"&&",true,"&&",true,"&&",false,"&&",true])==false);
			Assert.assertTrue(l.computeEvals([true,"&&",true,"&&",true,"&&",true,"&&",true]));
			Assert.assertTrue(l.computeEvals([true,"&&",true,"&&",true,"&&",true,"||",false]));
			l.kill();
			l=null;	
		}
		
		[Test( description="tests maths" )]
		public function test9() : void
		{
			
			var testMaths:Function = function(maths:String,updatesTo:String="",answer:Boolean=true):Boolean{
				if(updatesTo=="")updatesTo=maths;
				var m:ManyVarSide = new ManyVarSide(null,null);
				m.equationOrigStr = maths;		
				return answer==(m.equationNow()==updatesTo);
			}
			
			Assert.assertTrue( testMaths("a+b+3") && testMaths("((a+b))+3") && testMaths("(((a))+(((b)))+((((3)))))"));
		}
		
		[Test( description="tests maths external class" )]
		public function test10() : void
		{
			
			var mathsTest:Function = function(str:String,val:String):Boolean{
				
				var mpVal:MathParser = new MathParser([]);
				var compobjVal:CompiledObject =  mpVal.doCompile(str);
				
				if (compobjVal.errorStatus == 1) {
					trace("prob with formula");
					return false;
				}
					
				else {
					if(String(mpVal.doEval(compobjVal.PolishArray, [])).substr(0,5)==val.substr(0,5))return true
					
					
					
					return false;
				}
			}

			Assert.assertTrue(mathsTest("SQRT(2*9/3*44)","16.24807681") && mathsTest("SQRT(SIN(2*9/3*44))","0.325603265") && mathsTest("SQRT(SIN(2.1*9.999/3.1111*44.10101))","0.846223189"));
		}
		
		
		[Test( description="tests Logic Class has constructed logic correctly" )]
		public function test3() : void
		{
			
			var testLogic:Function = function(logic:String,listOfUpdates:Array,updatesTo:String,answer:Boolean=true):Boolean{
				var p:PropValDict = new PropValDict;
				var testL:TopLevelLogic = new TopLevelLogic(logic,function():void{},p);
				for(var i:uint=0;i<listOfUpdates.length;i++){
					testL.assignProp(listOfUpdates[i].what,listOfUpdates[i].to);
				}
				var test1:Boolean= testL.reconstruct(false)==updatesTo;
				var test2:Boolean=  testL.eval();

				//trace("reconstruct:",testL.reconstruct(false));
				//trace(updatesTo);
				//trace("evaluated  :",testL.eval());
				testL.kill();
				p.kill();
				return test1==true && test2==answer;
			}
	
			Assert.assertTrue(testLogic("banana>123",[{what:"banana",to:"124"}],"124>123"));//testing that variable replacement works for LHS
			Assert.assertTrue(testLogic("123>banana",[{what:"banana",to:"122"}],"123>122"));//testing that variable replacement works for RHS			
			Assert.assertTrue(testLogic("'hello'==banana",[{what:"banana",to:"'hello'"}],"'hello'=='hello'")); //testing that strings can be compoared
			Assert.assertTrue(testLogic("(((banana==banana)))",[{what:"banana",to:"124"}],"(((124==124)))")); //testing multiple brackets
			Assert.assertTrue(testLogic("banana>'banana'",[{what:"banana",to:"124"}],"124>'banana'",false));//testing mandatory fail for comparing across types
			

			Assert.assertTrue(testLogic("1.11>banana",[{what:"banana",to:"1"}],"1.11>1",true));//testing that int and number are not treated as different classes
			
			
			 // & does not work either, as well as ^ and prob other mathematical notation
			Assert.assertTrue(testLogic("banana=='banana-abc'",[{what:"banana",to:"'banana-abc'"}],"'banana-abc'=='banana-abc'",true));//testing mandatory fail for comparing across types
			
			
			Assert.assertTrue(testLogic("banana>123&&(apple==2&&(pear==3&&pineapple>2.5))",[{what:"banana",to:124},{what:"apple",to:2},{what:"pear",to:3},{what:"pineapple",to:2.6}],"124>123&&(2==2&&(3==3&&2.6>2.5))"));//uber test	
			
			
			Assert.assertTrue(testLogic("pear<3+2",[{what:"bread",to:2.1},{what:"sausage",to:.9},{what:"banana",to:124},{what:"apple",to:2},{what:"pear",to:3},{what:"pineapple",to:2.6}],"3<3+2"));//uber test
				
			Assert.assertTrue(testLogic("pear==sausage+2+banana+apple+pineapple+1",[{what:"bread",to:2.1},{what:"sausage",to:.9},{what:"banana",to:124},{what:"apple",to:2},{what:"pear",to:132.5},{what:"pineapple",to:2.6}],"132.5==0.9+2+124+2+2.6+1"));//uber test
			
			Assert.assertTrue(testLogic("pear==(((sausage+bread)))",[{what:"bread",to:2.1},{what:"sausage",to:.9},{what:"banana",to:124},{what:"apple",to:2},{what:"pear",to:3},{what:"pineapple",to:2.6}],"3==(((0.9+2.1)))"));//uber test	
			Assert.assertTrue(testLogic("banana>123&&(apple==2&&(pear==(((sausage+bread)))&&pineapple>2.5))",[{what:"bread",to:2.1},{what:"sausage",to:.9},{what:"banana",to:124},{what:"apple",to:2},{what:"pear",to:3},{what:"pineapple",to:2.6}],"124>123&&(2==2&&(3==(((0.9+2.1)))&&2.6>2.5))"));//uber test
			
	
		}
		
		[Test]
		public function test4() : void
		{
			
			var testLogic:Function = function(logic:String,listOfUpdates:Array,updatesTo:String,answer:Boolean=true):Boolean{
				var p:PropValDict = new PropValDict;
				try{
					var testL:TopLevelLogic = new TopLevelLogic(logic,function():void{},p);
					return false;
				}
				catch(e:Error){
					return true;
				}
			}
			
			Assert.assertTrue(testLogic("banana=123",[{what:"banana",to:"124"}],"124>123"));//testing that variable replacement works for LHS
		
		}
		

	}
}