package unitTests
{
	import org.flexunit.Assert;
	import com.xperiment.behaviour.BehaviourBoss;
	import flash.display.Sprite;
	import com.xperiment.stimuli.object_baseClass;
	import com.xperiment.stimuli.Test_object_baseClass;
	import com.xperiment.uberSprite;
	import com.xperiment.onScreenBoss.DummyOnScreenBoss;
	
	
	public class test_abstractTrial_sortoutTimingF
	{
		[Test( description="test1" )]
		public function test1() : void
		{
	
			var test0:Function = function():Boolean{
				var o:DummyOnScreenBoss = new DummyOnScreenBoss;
				var b:BehaviourBoss = new BehaviourBoss(new Sprite,o,null);
				
				var obj:object_baseClass
				obj = new Test_object_baseClass;
				obj.pic = new uberSprite;
				obj.peg="testPeg";
				obj.OnScreenElements["behaviours"] = "click:a.start()";
				b.passObject(obj,{start:0,end:100});
				
				if(obj.myUniqueProps("does not exist")!=null) return false;
				
				var returns:String = obj.myUniqueProps("myVal")();
				if(returns!="not set") 				return false;
				returns = obj.myUniqueProps("myVal")("myVal","set");
				if(returns!="set") 			return false;
				if(obj["myVal"]!="set") return false;
				
				var err:Boolean=false;
				try{
					b.propWrapper(obj,"throw Error");
				}
				catch(e:Error){
					if(e.message!="Problem trying to set a value 'throw Error' on this object 'testPeg': propery does not exist.") return false;
					err=true;
				}
				if(err==false)return false;
				
				obj.OnScreenElements.testString =	"string" as String;
				obj.OnScreenElements.testBool =		false as Boolean;
				obj.OnScreenElements.testNumber =	1 as Number;
				obj.OnScreenElements.testArr =		[1] as Array;
				
				var f:Function = b.propWrapper(obj,"testString");
				if(f==null)return false;
				if ("updated"!=f("testString","updated")) return false;
				
				f = b.propWrapper(obj,"testBool");
				if(f==null)return false;
				if (!f("testBool",true)) return false;
				
				f = b.propWrapper(obj,"testNumber");
				if(f==null)return false;
				if (2!=f("testNumber",2)) return false;
				if (3==f("testNumber",2)) return false;
				
				f = b.propWrapper(obj,"testArr");
				if(f==null)return false;
				if ([2,3]!=f("testArr",[2,3])) return false;
				
				//time stuff
				f = b.propWrapper(obj,"timeStart");
				if(f==null)return false;
				f("timeStart",2);
				if(o.timeStart!==2)return false;
				
				f = b.propWrapper(obj,"timeEnd");
				if(f==null)return false;
				f("timeEnd",2);
				if(o.timeEnd!==2)return false;
				
				f = b.propWrapper(obj,"duration");
				if(f==null)return false;
				f("duration",2);
				if(o.duration!==2)return false;
				
				b.propValDict.kill();
				o=null;
				b.kill();
				obj.kill();
				
				return true;		
			}
			Assert.assertTrue(test0());
		}
		
		
		[Test( description="test2" )]
		public function test2() : void{
			var test1:Function = function(objsRaw:Array):Boolean{
				var o:DummyOnScreenBoss = new DummyOnScreenBoss;
				var b:BehaviourBoss = new BehaviourBoss(new Sprite,o,null);
				
				var objs:Array = [];
				var obj:object_baseClass
				var params:Object;
				
				for(var i:int=0; i<objsRaw.length; i++){
					params=objsRaw[i];
					
					if(params.hasOwnProperty("init"))b.init();
						
					else if(params.hasOwnProperty("start")){
						obj = new Test_object_baseClass;
						obj.pic = new uberSprite;
						obj.peg=params.peg;
						obj.OnScreenElements["if"] = params["if"];
						obj.OnScreenElements["behaviours"] = params.behaviours;
						objs.push(obj);
						b.passObject(obj,{start:params.start,end:params.end});
					}
					else if(params.hasOwnProperty("action")){
						var count:int=1; //below lets us specify test1 test2 test3 etc
						var prop:String;
						var before:*;
						var after:*;
						var testObj:Object;
						var testObjs:Array = [];
						while(true){							
							if(!params.hasOwnProperty("test"+String(count)))break;
							
							testObj={};
							testObj.prop=params["test"+String(count)]["prop"];
							testObj.before=params["test"+String(count)]["before"];
							testObj.after=params["test"+String(count)]["after"];
							if(testObj!=null)testObjs.push({
								prop:testObj.prop,
								before:testObj.before,
								after:testObj.after
							});
							
							count++;						
							prop=testObj.prop;
							if(!testObj.hasOwnProperty("before"))before=prop;
							else before=testObj.before;
							after =testObj.after;
							if(["timeStart","timeEnd", "duration"].indexOf(prop.split(".")[1])!=-1){
								//not testing
							}
							else if(b.propValDict.propVal(prop)!=before){
								return false;
							}
						}
						b.propValDict.incrementPerTrial(params.action);
						
						
						for(var testi:int=0;testi<testObjs.length;testi++){// iterates through each of the tests: test1, test2, test3...
							
							prop=testObjs[testi].prop;
							before=testObjs[testi].before;
							after=testObjs[testi].after;
							
							if(b.propValDict.propVal(prop)!=after) return false; //tests the Property Prop has been correctly updated
							
							var timing:String="";
							if(prop.indexOf("timeStart")!=-1)		timing="timeStart";
							else if(prop.indexOf("timeEnd")!=-1) 	timing="timeEnd";
							else if(prop.indexOf("duration")!=-1)	timing="duration";
							
							if(timing!=""){
								var arr:Array=prop.split(".");
								if(Number(o.timing[arr[0]][arr[1]])!=Number(after))return false;							
							}
							
						}
						testObjs[i]=null;
					}
					testObjs=null;
					
				}			
				
				
				b.propValDict.kill();
				o=null;
				b.kill();
				for each (obj  in objs){
					obj.kill();
				}
				return true;		
			}
			
			Assert.assertTrue(test1([
				{	peg:		"a",
					behaviours:	"click:a.start(),myVal='banana',a.timeEnd=2000,a.timeStart=1000,a.duration=10",
					start: 		100,
					end:		1000
				},
				{	peg:		"b",//below tests left to right order of updates
					behaviours:	"rightUp:myVal='banana2',myVal=2,a.timeEnd=2001,a.timeStart=1001+2+a.timeEnd,a.duration=11+myVal",
					start: 		100,
					end:		1000
				},
				{	peg:		"c",
					behaviours:	"mouseOver:myVal='hello',myVal=1+3+' hello '+ 2,myVal=2+3+myVal+2+1+' sausage ',c.testProp=1+2,testBanana='oober'+2+3",
					start: 		100,
					end:		1000
				},
				{
					init:		true
				},
				{
					action:		"a.click",
					test1:		{prop:"myVal", before:"myVal", after:"'banana'"},
					test2:		{prop:"a.timeEnd", after:2000},
					test3:		{prop:"a.timeStart", after:1000},
					test4:		{prop:"a.duration", after:10}//NOTE!! Only this value here (should be 1010) as using a 
					//DummyOnscreenBoss without necessary algorithms.  This issue is covered in tests on the OnScreenBoss.
				},
				{
					action:		"b.rightUp",
					test1:		{prop:"myVal", before:"'banana'", after:"2"},
					test2:		{prop:"a.timeEnd", after:2001},
					test3:		{prop:"a.timeStart", after:3004},
					test4:		{prop:"a.duration", after:13}
				}
				,
				{
					action:		"c.mouseOver",
					test1:		{prop:"myVal", before:2, after:"'54 hello 23 sausage '"},	
					test2:		{prop:"c.testProp",before:"not set",after:3}, //testing object specific properties
					test3:		{prop:"testBanana",before:"testBanana",after:"'oober5'"} //testing Experiment wide properties
				}
			]
			));
			
			
		}
		

	}
}